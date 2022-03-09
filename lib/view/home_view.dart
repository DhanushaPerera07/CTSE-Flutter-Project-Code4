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
 * FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

import '../dal/battery_info_dao.dart';
import '../dal/hotel_dao.dart';
import '../data/data.dart';
import '../model/battery_info.dart';
import '../model/hotel.dart';
import '../model/menu_tile.dart';
import 'menu_card_view.dart';

class Home extends StatelessWidget {
  const Home(
      {Key? key, required this.batteryState, required this.batteryPercentage})
      : super(key: key);

  final BatteryState batteryState;
  final int batteryPercentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('My App'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  /* go to the battery info view. */
                  // Navigator.pushNamed(context, '/battery-info');
                },
                icon: GestureDetector(
                    child: buildBatteryIcon(batteryState),
                    onTap: () {
                      debugPrint('onTap:  battery !');
                      _printAllBatteryInfoRecords();
                    })),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text('$batteryPercentage%',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        )))
              ],
            )
          ],
        ),
        body: GridView.builder(
            itemCount: menuTiles.length,
            /* TODO: getMenuTiles via a method. */
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: MenuCardState(
                    menuTiles: menuTiles, child: MenuCard(index: index)),
                onTap: () {
                  _redirectToNextRoute(context, menuTiles, index);
                },
              );
            }));
  }

  /// Print all Hotel records. */
  void _printAllHotelRecords() {
    debugPrint('printAllHotelRecords() executed!');
    // ObjectBox objectBox = ObjectBox.createObjectBox();
    // print("////////////////////////////////");
    // print(objectBox);
    final HotelDAO hotelDAO = HotelDAO.getInstance();
    // Hotel myHotel = Hotel(0, "Angel Beach Hotel", "Galle");
    // hotelDAO.createHotel(myHotel);
    debugPrint('************** Hotel List ***************************');
    // print(hotelDAO.getAll());
    hotelDAO.getAll().forEach((Hotel hotel) => debugPrint(hotel.toString()));
  }

  /// Print all battery info records. */
  void _printAllBatteryInfoRecords() {
    debugPrint('printAllBatteryInfoRecords() executed!');
    // ObjectBox objectBox = ObjectBox.createObjectBox();
    // print("////////////////////////////////");
    // print(objectBox);
    final BatteryInfoDAO batteryInfoDAO = BatteryInfoDAO.getInstance();
    // Hotel myHotel = Hotel(0, "Angel Beach Hotel", "Galle");
    // hotelDAO.createHotel(myHotel);
    debugPrint('************** BatteryInfo List ***************************');
    // print(hotelDAO.getAll());
    batteryInfoDAO.getAll().forEach(
        (BatteryInfo batteryInfo) => debugPrint(batteryInfo.toString()));
  }

  void _redirectToNextRoute(
      BuildContext context, List<MenuTile> menuTiles, int index) {
    debugPrint('Card index: $index');
    Navigator.pushNamed(context, menuTiles[index].route);
  }

  Widget buildBatteryIcon(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return const Icon(Icons.battery_charging_full,
            size: 28, color: Colors.lightGreenAccent);
      case BatteryState.full:
        return const Icon(
          Icons.battery_full,
          size: 28,
          color: Colors.green,
        );
      case BatteryState.discharging:
        return const Icon(Icons.battery_std, size: 28, color: Colors.white);
      case BatteryState.unknown:
        return const Icon(Icons.battery_unknown, size: 28, color: Colors.amber);
    }
  }
}
