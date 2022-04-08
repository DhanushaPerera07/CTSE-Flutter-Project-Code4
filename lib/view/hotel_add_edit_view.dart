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
import '../model/hotel.dart';
import '../util/crypto_util.dart';
import '../util/toast_message_util.dart';

class HotelAddEditView extends StatefulWidget {
  const HotelAddEditView({Key? key, required this.hotel}) : super(key: key);

  /* Route */
  static const String addHotelRoute = '/hotels/add';
  static const String editHotelRoute = '/hotels/edit';

  final Hotel hotel;

  @override
  State<HotelAddEditView> createState() => _HotelAddEditViewState();
}

class _HotelAddEditViewState extends State<HotelAddEditView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();

  Hotel hotelInstance = Hotel(0, '', '', '', '');
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    /* Set values to the TextFields. */
    setHotelDetails();
    if (_isUpdateOperation()) {
      hotelInstance.id = widget.hotel.id;
      hotelInstance.name = widget.hotel.name;
      hotelInstance.location = widget.hotel.location;
      hotelInstance.email = widget.hotel.email;
      hotelInstance.contactNo = widget.hotel.contactNo;

      setState(() {
        isValid = _isInputValid();
      });
    }

    _nameController.addListener(() {
      final String name = _nameController.text;
      debugPrint('NameTextField: $name');
      hotelInstance.name = name.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _locationController.addListener(() {
      final String location = _locationController.text;
      debugPrint('LocationTextField: $location');
      hotelInstance.location = location.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _emailController.addListener(() {
      final String email = _emailController.text;
      debugPrint('EmailTextField: $email');
      hotelInstance.email = email.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _contactNoController.addListener(() {
      final String contactNo = _contactNoController.text;
      debugPrint('ContactNoTextField: $contactNo');
      hotelInstance.contactNo = contactNo.trim();

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
    return widget.hotel.id > 0;
  }

  Text _getTitleWidgets() {
    if (_isUpdateOperation()) {
      return const Text('Update Hotel');
    } else {
      return const Text('Add New Hotel');
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
          hintText: 'Hotel ID',
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
            hintText: 'Enter hotel name',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextField(
          controller: _locationController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter hotel location',
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter hotel email',
            ),
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextField(
          controller: _contactNoController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter hotel contact no',
          ),
        ),
      )
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
                        final HotelDAO hotelDAO = HotelDAO.getInstance();
                        hotelDAO.updateHotel(hotelInstance);
                        /* Print all the hotels. */
                        debugPrint(
                            '************** Hotel List ***************************');
                        hotelDAO.getAll().forEach(
                            (Hotel hotel) => debugPrint(hotel.toString()));
                        displayToastMessage(
                            'Hotel updated successfully!', Colors.blue[900]);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/hotels', ModalRoute.withName('/'));
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/hotels', (Route route) => route.isFirst);
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
                  final HotelDAO hotelDAO = HotelDAO.getInstance();
                  hotelDAO.deleteHotelById(hotelInstance.id);
                  /* Print all the hotels. */
                  debugPrint(
                      '************** Hotel List ***************************');
                  hotelDAO
                      .getAll()
                      .forEach((Hotel hotel) => debugPrint(hotel.toString()));
                  displayToastMessage(
                      'Hotel deleted successfully!', Colors.amber);
                } catch (e) {
                  debugPrint(e.toString());
                  displayToastMessage(
                      'Error: something went wrong!', Colors.red);
                }

                /* Navigate to previous screen. */
                // Navigator.pushNamedAndRemoveUntil(
                //     context, '/hotels', ModalRoute.withName('/'));
                Navigator.pushNamedAndRemoveUntil(
                    context, '/hotels', (Route route) => route.isFirst);
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
                        final HotelDAO hotelDAO = HotelDAO.getInstance();
                        hotelDAO.createHotel(hotelInstance);
                        /* Print all the hotels. */
                        debugPrint(
                            '************** Hotel List ***************************');
                        hotelDAO.getAll().forEach(
                            (Hotel hotel) => debugPrint(hotel.toString()));
                        displayToastMessage(
                            'Hotel added successfully!', Colors.green);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      // Navigator.pushNamed(context, '/hotels');
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/', ModalRoute.withName(HotelAddEditView.addHotelRoute));
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/hotels', (Route route) => route.isFirst);
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

  /* Set hotel details into TextFields. */
  void setHotelDetails() {
    if (_isUpdateOperation()) {
      _idController.text = widget.hotel.id.toString();
    }
    _nameController.text = widget.hotel.name;
    _locationController.text = widget.hotel.location;
    _emailController.text = widget.hotel.email;
    _contactNoController.text = widget.hotel.contactNo;

    setState(() {
      isValid = _isInputValid();
    });
  }

  /* Validate the user input. */
  bool _isInputValid() {
    bool validationStatus = true;
    if (_isUpdateOperation()) {
      /* Update operation. */
      if (!(hotelInstance.id > 0) ||
          hotelInstance.name.isEmpty ||
          hotelInstance.location.isEmpty) {
        validationStatus = false;
      }
    } else {
      /* Add operation. */
      if (!(hotelInstance.id == 0) ||
          hotelInstance.name.isEmpty ||
          hotelInstance.location.isEmpty) {
        validationStatus = false;
      }
    }

    if (!isChanged(widget.hotel.toString(), hotelInstance.toString())) {
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
                Text('Hotel name and location should be letters. '
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
