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

import '../dal/restaurant_dao.dart';
import '../model/restaurant.dart';
import '../util/crypto_util.dart';
import '../util/toast_message_util.dart';

class RestaurantAddEditView extends StatefulWidget {
  const RestaurantAddEditView({Key? key, required this.restaurant})
      : super(key: key);

  /* Route */
  static const String addRestaurantRoute = '/restaurants/add';
  static const String editRestaurantRoute = '/restaurants/edit';

  final Restaurant restaurant;

  @override
  State<RestaurantAddEditView> createState() => _RestaurantAddEditViewState();
}

class _RestaurantAddEditViewState extends State<RestaurantAddEditView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  Restaurant restaurantInstance = Restaurant(0, '', '', '');
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    /* Set values to the TextFields. */
    setRestaurantDetails();
    if (_isUpdateOperation()) {
      restaurantInstance.id = widget.restaurant.id;
      restaurantInstance.name = widget.restaurant.name;
      restaurantInstance.location = widget.restaurant.location;
      restaurantInstance.phoneNumber = widget.restaurant.phoneNumber;

      setState(() {
        isValid = _isInputValid();
      });
    }

    _nameController.addListener(() {
      final String name = _nameController.text;
      debugPrint('NameTextField: $name');
      restaurantInstance.name = name.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _locationController.addListener(() {
      final String location = _locationController.text;
      debugPrint('LocationTextField: $location');
      restaurantInstance.location = location.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _phoneNumberController.addListener(() {
      final String phoneNumber = _phoneNumberController.text;
      debugPrint('PhoneNumberTextField: $phoneNumber');
      restaurantInstance.phoneNumber = phoneNumber.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });
  }

  @override
  void dispose() {
    if (_isUpdateOperation()) {
      _idController.dispose();
    }
    _nameController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _getTitleWidgets(),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  debugPrint('Click on help icon');
                  _showMyDialog();
                },
                icon: const Icon(
                  Icons.contact_support_outlined,
                  color: Colors.white,
                  size: 30.0,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(child: Column(children: _getFormFields())),
              _getSaveOrUpdateDeleteButton()
            ],
          ),
        ));
  }

  bool _isUpdateOperation() {
    return widget.restaurant.id > 0;
  }

  Text _getTitleWidgets() {
    if (_isUpdateOperation()) {
      return const Text('Update Restaurant');
    } else {
      return const Text('Add New Restaurant');
    }
  }

  List<Widget> _getFormFields() {
    final Widget idTextField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        controller: _idController,
        readOnly: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Restaurant ID',
        ),
      ),
    );

    final List<Widget> list = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter restaurant name',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextField(
          controller: _locationController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter restaurant location',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextField(
          controller: _phoneNumberController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter restaurant phone number',
          ),
        ),
      ),
    ];

    if (_isUpdateOperation()) {
      /* insert ID TextField as the first Widget in the list. */
      list.insert(0, idTextField);
      return list;
    } else {
      return list;
    }
  }

  /* Create a Widget containing necessary buttons for the respective operation. */
  Widget _getSaveOrUpdateDeleteButton() {
    final List<Widget> list = <Widget>[];
    if (_isUpdateOperation()) {
      /* Creating Update button. */
      final Widget updateButton = Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: SizedBox(
            width: 110,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: isValid
                    ? MaterialStateProperty.all<Color>(Colors.green)
                    : MaterialStateProperty.all<Color>(Colors.grey),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: isValid
                  ? () {
                      /* Perform Update Operation. */
                      try {
                        final RestaurantDAO restaurantDAO =
                            RestaurantDAO.getInstance();
                        restaurantDAO.updateRestaurant(restaurantInstance);
                        /* Print all the restaurants. */
                        debugPrint(
                            '************** Restaurant List ***************************');
                        restaurantDAO.getAll().forEach(
                            (Restaurant restaurant) =>
                                debugPrint(restaurant.toString()));
                        displayToastMessage('Restaurant updated successfully!',
                            Colors.blue[900]);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/restaurants', ModalRoute.withName('/'));
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/restaurants', (Route route) => route.isFirst);
                    }
                  : null,
              child: const Text('UPDATE', style: TextStyle(fontSize: 16)),
            ),
          ));

      /* Creating Delete button. */
      final Widget deleteButton = Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: SizedBox(
            width: 110,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                /* Perform Delete Operation. */
                try {
                  final RestaurantDAO restaurantDAO =
                      RestaurantDAO.getInstance();
                  restaurantDAO.deleteRestaurantById(restaurantInstance.id);
                  /* Print all the restaurants. */
                  debugPrint(
                      '************** Restaurant List ***************************');
                  restaurantDAO.getAll().forEach((Restaurant restaurant) =>
                      debugPrint(restaurant.toString()));
                  displayToastMessage(
                      'Restaurant deleted successfully!', Colors.amber);
                } catch (e) {
                  debugPrint(e.toString());
                  displayToastMessage(
                      'Error: something went wrong!', Colors.red);
                }

                /* Navigate to previous screen. */
                // Navigator.pushNamedAndRemoveUntil(
                //     context, '/restaurants', ModalRoute.withName('/'));
                Navigator.pushNamedAndRemoveUntil(context,
                    '/restaurants', (Route route) => route.isFirst);
              },
              child: const Text('DELETE', style: TextStyle(fontSize: 16)),
            ),
          ));

      list.add(updateButton);
      list.add(deleteButton);
    } else {
      /* Add operation. */
      final Widget saveButton = Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: SizedBox(
            width: 110,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: isValid
                    ? MaterialStateProperty.all<Color>(Colors.blue)
                    : MaterialStateProperty.all<Color>(Colors.grey),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: isValid
                  ? () {
                      /* Perform Save Operation. */
                      try {
                        final RestaurantDAO restaurantDAO =
                            RestaurantDAO.getInstance();
                        restaurantDAO.createRestaurant(restaurantInstance);
                        /* Print all the restaurants. */
                        debugPrint(
                            '************** Restaurant List ***************************');
                        restaurantDAO.getAll().forEach(
                            (Restaurant restaurant) =>
                                debugPrint(restaurant.toString()));
                        displayToastMessage(
                            'Restaurant added successfully!', Colors.green);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/restaurants', ModalRoute.withName('/'));
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/restaurants', (Route route) => route.isFirst);
                    }
                  : null,
              child: const Text('SAVE', style: TextStyle(fontSize: 16)),
            ),
          ));

      list.add(saveButton);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: list,
    );
  }

  /* Set restaurant details into TextFields. */
  void setRestaurantDetails() {
    if (_isUpdateOperation()) {
      _idController.text = widget.restaurant.id.toString();
    }
    _nameController.text = widget.restaurant.name;
    _locationController.text = widget.restaurant.location;
    _phoneNumberController.text = widget.restaurant.phoneNumber;

    setState(() {
      isValid = _isInputValid();
    });
  }

  /* Validate the user input. */
  bool _isInputValid() {
    bool validationStatus = true;
    if (_isUpdateOperation()) {
      /* Update operation. */
      if (!(restaurantInstance.id > 0) ||
          restaurantInstance.name.isEmpty ||
          restaurantInstance.location.isEmpty ||
          restaurantInstance.phoneNumber.isEmpty) {
        validationStatus = false;
      }
    } else {
      /* Add operation. */
      if (!(restaurantInstance.id == 0) ||
          restaurantInstance.name.isEmpty ||
          restaurantInstance.location.isEmpty ||
          restaurantInstance.phoneNumber.isEmpty) {
        validationStatus = false;
      }
    }

    if (!isChanged(
        widget.restaurant.toString(), restaurantInstance.toString())) {
      validationStatus = false;
    }

    return validationStatus;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tip'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Restaurant name, location and phone number should be letters. '
                    'If you want you can use numbers along with letters.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
