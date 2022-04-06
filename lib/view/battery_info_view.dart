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
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

import '../dal/battery_info_dao.dart';
import '../model/battery_info.dart';
// import 'hotel_add_edit_view.dart';

class BatteryInfoView extends StatefulWidget {
  const BatteryInfoView({Key? key}) : super(key: key);

  /* Route */
  static const String route = '/batteryInfo';

  @override
  State<BatteryInfoView> createState() => _BatteryInfoViewState();
}

class _BatteryInfoViewState extends State<BatteryInfoView> {
  final BatteryInfoDAO batteryInfoDAO = BatteryInfoDAO.getInstance();
  late final List<BatteryInfo> batteryInfoList;

  @override
  void initState() {
    super.initState();
    batteryInfoList = batteryInfoDAO.getAll();
    debugPrint(
        '\nBatteryInfoView initState: **************  Battery Info List ***************************');
    batteryInfoDAO.getAll().forEach((BatteryInfo batteryInfo) => debugPrint(batteryInfo.toString()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Battery Info'),
      ),
      body: (batteryInfoList.isEmpty)
          ? const SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(15),
              child: Text('No battery info found'),
            ))
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: batteryInfoList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[500],
                        borderRadius: BorderRadius.circular(2)),
                    height: 80,
                    // color: Colors.lightBlue[500],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringUtils.capitalize(batteryInfoList[index].batteryPercentage.toString(),
                              allWords: true),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          StringUtils.capitalize(batteryInfoList[index].dateTime.toString(),
                              allWords: true),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
    );
  }
}
