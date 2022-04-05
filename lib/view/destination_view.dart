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

import '../dal/destination_dao.dart';
import '../model/destination.dart';
import 'destination_add_edit_view.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({Key? key}) : super(key: key);

  /* Route */
  static const String route = '/destinations';

  @override
  State<DestinationView> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  final DestinationDAO destinationDAO = DestinationDAO.getInstance();
  late final List<Destination> destinationList;

  @override
  void initState() {
    super.initState();
    destinationList = destinationDAO.getAll();
    debugPrint(
        '\nDestinationView initState: **************  Destination List ***************************');
    destinationDAO.getAll().forEach((Destination destination) => debugPrint(destination.toString()));
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
        title: const Text('Destinations'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                debugPrint('Click on add icon');
                // Navigator.pushNamed(context, '/destinations/add');
                // Navigator.pushNamed(context, '/destinations/edit');
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        DestinationAddEditView(destination: Destination(0, '', ''))));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ))
        ],
      ),
      body: (destinationList.isEmpty)
          ? const SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(15),
              child: Text('No destinations found, try adding a new one!'),
            ))
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: destinationList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push<void>(MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            DestinationAddEditView(destination: destinationList[index])));
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
                          StringUtils.capitalize(destinationList[index].name,
                              allWords: true),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          StringUtils.capitalize(destinationList[index].location,
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
