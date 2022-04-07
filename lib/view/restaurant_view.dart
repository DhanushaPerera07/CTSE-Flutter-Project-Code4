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

import '../dal/restaurant_dao.dart';
import '../model/restaurant.dart';
import 'restaurant_add_edit_view.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({Key? key}) : super(key: key);

  /* Route */
  static const String route = '/restaurants';

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  final RestaurantDAO restaurantDAO = RestaurantDAO.getInstance();
  late final List<Restaurant> restaurantList;

  @override
  void initState() {
    super.initState();
    restaurantList = restaurantDAO.getAll();
    debugPrint(
        '\nRestaurantView initState: **************  Restaurant List ***************************');
    restaurantDAO
        .getAll()
        .forEach((Restaurant restaurant) => debugPrint(restaurant.toString()));
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
        title: const Text('Restaurants'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                debugPrint('Click on add icon');
                // Navigator.pushNamed(context, '/restaurants/add');
                // Navigator.pushNamed(context, '/restaurants/edit');
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (BuildContext context) => RestaurantAddEditView(
                        restaurant: Restaurant(0, '', '', ''))));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ))
        ],
      ),
      body: (restaurantList.isEmpty)
          ? const SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(15),
              child: Text('No restaurants found, try adding a new one!'),
            ))
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: restaurantList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push<void>(MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            RestaurantAddEditView(
                                restaurant: restaurantList[index])));
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
                          StringUtils.capitalize(restaurantList[index].name,
                              allWords: true),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                         RichText(
                          text:  TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Icon(Icons.pin_drop),
                                ),
                              ),
                              TextSpan(text: ' : ${restaurantList[index].location}'),
                            ],
                          ),
                        ),
                        RichText(
                          text:  TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Icon(Icons.call),
                                ),
                              ),
                              TextSpan(text: ' : ${restaurantList[index].phoneNumber}'),
                            ],
                          ),
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
