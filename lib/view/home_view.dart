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
import 'package:flutter/material.dart';

import '../dal/hotel_dao.dart';
import '../data/data.dart';
import '../model/hotel.dart';
import '../model/menu_tile.dart';
import 'menu_card_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('My App'),
          actions: const <Widget>[],
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

  void _goToCart() {
    debugPrint('Clicks to go to Cart !');
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

  /// Show a simple dialog box. */
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                // redirectToHotelView(context);
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _redirectToNextRoute(
      BuildContext context, List<MenuTile> menuTiles, int index) {
    debugPrint('Card index: $index');
    Navigator.pushNamed(context, menuTiles[index].route);
  }
}
