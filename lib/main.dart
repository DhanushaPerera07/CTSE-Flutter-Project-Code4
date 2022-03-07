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

import 'database/objectbox.dart';
import 'view/home_view.dart';
import 'view/hotel_view.dart';

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
  late StreamSubscription<BatteryState> _batteryStreamSubscription;

  @override
  void initState() {
    super.initState();
    debugPrint('MyApp: initState() works!');
    ObjectBox.getInstance();
    printBatteryState();
    // Be informed when the state (full, charging, discharging) changes
    _batteryStreamSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      // Do something with new state
      debugPrint('MyApp: onBatteryStateChanged() works! : $state');
      setState(() {
        _batteryState =  state;
      });
    });
  }

  Future<void> printBatteryState() async {
    final int batteryLevel = await _battery.batteryLevel;
    debugPrint(batteryLevel.toString());
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('MyApp: dispose() works!');
    ObjectBox.closeObjectBox();
    _batteryStreamSubscription.cancel();
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
        Hotel.route: (BuildContext context) => const Hotel(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        // '/second': (BuildContext context) => const SecondScreen(),
      },
      home: Home(
        batteryState: _batteryState,
      ),
    );
  }


}
