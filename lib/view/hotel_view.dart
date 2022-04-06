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

import '../dal/hotel_dao.dart';
import '../model/hotel.dart';
import 'hotel_add_edit_view.dart';

class HotelView extends StatefulWidget {
  const HotelView({Key? key}) : super(key: key);

  /* Route */
  static const String route = '/hotels';

  @override
  State<HotelView> createState() => _HotelViewState();
}

class _HotelViewState extends State<HotelView> {
  final HotelDAO hotelDAO = HotelDAO.getInstance();
  late final List<Hotel> hotelList;

  @override
  void initState() {
    super.initState();
    hotelList = hotelDAO.getAll();
    debugPrint(
        '\nHotelView initState: **************  Hotel List ***************************');
    hotelDAO.getAll().forEach((Hotel hotel) => debugPrint(hotel.toString()));
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
        title: const Text('Hotels'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                debugPrint('Click on add icon');
                // Navigator.pushNamed(context, '/hotels/add');
                // Navigator.pushNamed(context, '/hotels/edit');
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        HotelAddEditView(hotel: Hotel(0, '', '', '', ''))));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ))
        ],
      ),
      body: (hotelList.isEmpty)
          ? const SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(15),
              child: Text('No hotels found, try adding a new one!'),
            ))
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: hotelList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push<void>(MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            HotelAddEditView(hotel: hotelList[index])));
                  },
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
                          StringUtils.capitalize(hotelList[index].name,
                              allWords: true),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          StringUtils.capitalize(hotelList[index].location,
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
