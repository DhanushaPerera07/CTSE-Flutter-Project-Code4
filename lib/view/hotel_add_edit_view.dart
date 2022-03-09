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

import '../model/hotel.dart';
import '../util/crypto_util.dart';

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

  final Hotel hotelInstance = Hotel(0, '', '');
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    /* Set values to the TextFields. */
    setHotelDetails();
    if (_isUpdateOperation()) {
      final String text = _idController.text;
      hotelInstance.id = int.parse(text.trim());

      final String name = _nameController.text;
      hotelInstance.name = name.trim();

      final String location = _locationController.text;
      hotelInstance.location = location.trim();

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
              onPressed: isValid ? () {} : null,
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
              onPressed: () {},
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
                      debugPrint('Saved button works!');
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

  // bool _enableButton() {
  //   return isChanged(widget.hotel.toString(), hotelInstance.toString());
  // }

  void setHotelDetails() {
    if (_isUpdateOperation()) {
      _idController.text = widget.hotel.id.toString();
    }
    _nameController.text = widget.hotel.name;
    _locationController.text = widget.hotel.location;

    setState(() {
      isValid = _isInputValid();
    });
  }

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
}
