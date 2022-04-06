/*
 * MIT License
 *
 * Copyright (c) 2022 Code4 v2 Technologies.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

import 'dal/battery_info_dao.dart';
import 'database/objectbox.dart';
import 'model/battery_info.dart';
import 'model/restaurant.dart';
import 'stream/battery_percentage_stream.dart';
import 'util/toast_message_util.dart';
import 'view/home_view.dart';
import 'view/hotel_view.dart';
import 'view/transportation_view.dart';
import 'view/restaurant_view.dart';
import 'view/destination_view.dart';
import 'view/battery_info_view.dart';



void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // ObjectBox.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Battery _battery = Battery();

  BatteryState _batteryState = BatteryState.unknown;
  int _batteryPercentage = 0;
  late BatteryInfo batteryInfo;
  late StreamSubscription<BatteryState> _batteryStreamSubscription;

  late Timer timer;

  // late BatteryPercentageStream batteryPercentageStream;
  final Stream<int> _bpStream = BatteryPercentageStream.stream;
  final StreamController<int> _bpStreamController =
      BatteryPercentageStream.bpStreamController;
  late StreamSubscription<int> _bpStreamSubscription;

  final int batteryLowMinPercentage = 20;
  bool willDisplayBatteryLowAlert = true;

  @override
  void initState() {
    super.initState();
    debugPrint('MyApp: initState() works!');
    /* update the current batteryPercentage. */
    updateBatteryPercentage();
    /* update the current batteryState. */
    updateBatteryState();
    ObjectBox.getInstance();
    // Be informed when the state (full, charging, discharging) changes
    listenToBatteryStateChanges();
    timer = Timer.periodic(const Duration(seconds: 4),
        (Timer t) => emitValuesForBatteryPercentageStream());
    listenToBatteryPercentage();
  }

  @override
  void dispose() {
    debugPrint('MyApp: dispose() works!');
    ObjectBox.closeObjectBox();
    _batteryStreamSubscription.cancel();
    _bpStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CRUD Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, Widget Function(BuildContext)>{
        // When navigating to the "/" route, build the FirstScreen widget.
        HotelView.route: (BuildContext context) => const HotelView(),
        RestaurantView.route: (BuildContext context) => const RestaurantView(),
        TransportationView.route: (BuildContext context) => const TransportationView(),
        DestinationView.route: (BuildContext context) => const DestinationView(),
        BatteryInfoView.route: (BuildContext context) => const BatteryInfoView(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        // HotelAddEditView.addHotelRoute: (BuildContext context) =>
        //     const HotelAddEditView(isUpdate: false),
        // HotelAddEditView.editHotelRoute: (BuildContext context) =>
        //     const HotelAddEditView(isUpdate: true),
      },
      home: Home(
        // batteryState: BatteryState.charging,
        batteryState: _batteryState,
        batteryPercentage: _batteryPercentage,
      ),
    );
  }

  void listenToBatteryPercentage() {
    _bpStreamSubscription = _bpStream.listen((int bpValue) {
      // debugPrint(
      //     'Listening to battery percentage: $bpValue%,  DateTime: ${DateTime.now().toIso8601String()}');

      if (bpValue > batteryLowMinPercentage) {
        /* reset the alert prompt value. */
        willDisplayBatteryLowAlert = true;
      }

      if (bpValue <= batteryLowMinPercentage && willDisplayBatteryLowAlert) {
        debugPrint('Battery is low, please connect to a charger! : $bpValue%');
        displayToastMessage(
            'Battery is low, please connect to a charger! : $bpValue%}',
            Colors.red);
        willDisplayBatteryLowAlert = false;
      }
    });
  }

  /* Emit/Add values to the stream through controller. */
  Future<void> emitValuesForBatteryPercentageStream() async {
    _bpStreamController.add(_batteryPercentage);
  }

  /* Listen to the changes happening to the BatteryState. */
  Future<void> listenToBatteryStateChanges() async {
    // Be informed when the state (full, charging, discharging) changes
    _batteryStreamSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) async {
      // Do something with new state
      // debugPrint('MyApp: onBatteryStateChanged() works! : $state');
      // debugPrint(
      //     'MyApp: previous state: $_batteryState, current state: $state');
      await updateBatteryPercentage();
      /* If battery is charging then, save the BatteryInfo in the database. */
      if (_batteryState != BatteryState.charging &&
          state == BatteryState.charging) {
        final BatteryInfoDAO batteryInfoDAO = BatteryInfoDAO.getInstance();
        /* update and set the current batteryPercentage. */
        final DateTime currentDateTime = DateTime.now();
        debugPrint(
            'MyApp: Hooray! My phone is charging! : $state, batteryPercentage: $_batteryPercentage, DateTime: ${currentDateTime.toIso8601String()}');
        batteryInfo = BatteryInfo(
            id: 0,
            batteryPercentage: _batteryPercentage,
            dateTime: currentDateTime);
        final int newBatteryInfoId =
            batteryInfoDAO.createBatteryInfo(batteryInfo);

        /* toast message. */
        deviceChargingToastMessage(batteryInfoDAO, newBatteryInfoId);
      }
      setState(() {
        _batteryState = state;
      });
    });
  }

  /* Device is charging toast message. */
  Future<void> deviceChargingToastMessage(
      BatteryInfoDAO batteryInfoDAO, int newBatteryInfoId) async {
    final BatteryInfo batteryInfo =
        batteryInfoDAO.getBatteryInfoById(newBatteryInfoId)!;
    debugPrint('newBatteryInfoId : $batteryInfo\n');
    displayToastMessage('Device Charging!', Colors.green);
  }

  /// get the current battery percentage and update the battery
  /// percentage variable. */
  Future<void> updateBatteryPercentage() async {
    final int batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryPercentage = batteryLevel;
    });
  }

  /// get the current battery state and update the battery
  /// state variable. */
  Future<void> updateBatteryState() async {
    final BatteryState batteryState = await _battery.batteryState;
    setState(() {
      _batteryState = batteryState;
    });
  }

  // /// Print the current battery percentage. */
  // Future<void> printBatteryState() async {
  //   final int batteryLevel = await _battery.batteryLevel;
  //   debugPrint(batteryLevel.toString());
  // }
}
