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

import '../dal/destination_dao.dart';
import '../model/destination.dart';
import '../util/crypto_util.dart';
import '../util/toast_message_util.dart';

class DestinationAddEditView extends StatefulWidget {
  const DestinationAddEditView({Key? key, required this.destination})
      : super(key: key);

  /* Route */
  static const String addDestinationRoute = '/destinations/add';
  static const String editDestinationRoute = '/destinations/edit';

  final Destination destination;

  @override
  State<DestinationAddEditView> createState() => _DestinationAddEditViewState();
}

class _DestinationAddEditViewState extends State<DestinationAddEditView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Destination destinationInstance = Destination(0, '', '');
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    /* Set values to the TextFields. */
    setDestinationDetails();
    if (_isUpdateOperation()) {
      destinationInstance.id = widget.destination.id;
      destinationInstance.name = widget.destination.name;
      destinationInstance.location = widget.destination.location;

      setState(() {
        isValid = _isInputValid();
      });
    }

    _nameController.addListener(() {
      final String name = _nameController.text;
      debugPrint('NameTextField: $name');
      destinationInstance.name = name.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _locationController.addListener(() {
      final String location = _locationController.text;
      debugPrint('LocationTextField: $location');
      destinationInstance.location = location.trim();

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
    return widget.destination.id > 0;
  }

  Text _getTitleWidgets() {
    if (_isUpdateOperation()) {
      return const Text('Update Destination');
    } else {
      return const Text('Add New Destination');
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
          hintText: 'Destination ID',
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
            hintText: 'Enter destination name',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextField(
          controller: _locationController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter destination location',
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
                        final DestinationDAO destinationDAO =
                            DestinationDAO.getInstance();
                        destinationDAO.updateDestination(destinationInstance);
                        /* Print all the destinations. */
                        debugPrint(
                            '************** Destination List ***************************');
                        destinationDAO.getAll().forEach(
                            (Destination destination) =>
                                debugPrint(destination.toString()));
                        displayToastMessage('Destination updated successfully!',
                            Colors.blue[900]);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/destinations', ModalRoute.withName('/'));
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/destinations', (Route route) => route.isFirst);
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
                  final DestinationDAO destinationDAO =
                      DestinationDAO.getInstance();
                  destinationDAO.deleteDestinationById(destinationInstance.id);
                  /* Print all the destinations. */
                  debugPrint(
                      '************** Destination List ***************************');
                  destinationDAO.getAll().forEach((Destination destination) =>
                      debugPrint(destination.toString()));
                  displayToastMessage(
                      'Destination deleted successfully!', Colors.amber);
                } catch (e) {
                  debugPrint(e.toString());
                  displayToastMessage(
                      'Error: something went wrong!', Colors.red);
                }

                /* Navigate to previous screen. */
                // Navigator.pushNamedAndRemoveUntil(
                //     context, '/destinations', ModalRoute.withName('/'));
                Navigator.pushNamedAndRemoveUntil(
                    context, '/destinations', (Route route) => route.isFirst);
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
                        final DestinationDAO destinationDAO =
                            DestinationDAO.getInstance();
                        destinationDAO.createDestination(destinationInstance);
                        /* Print all the destinations. */
                        debugPrint(
                            '************** Destination List ***************************');
                        destinationDAO.getAll().forEach(
                            (Destination destination) =>
                                debugPrint(destination.toString()));
                        displayToastMessage(
                            'Destination added successfully!', Colors.green);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/destinations', ModalRoute.withName('/'));
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/destinations', (Route route) => route.isFirst);
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

  /* Set destination details into TextFields. */
  void setDestinationDetails() {
    if (_isUpdateOperation()) {
      _idController.text = widget.destination.id.toString();
    }
    _nameController.text = widget.destination.name;
    _locationController.text = widget.destination.location;

    setState(() {
      isValid = _isInputValid();
    });
  }

  /* Validate the user input. */
  bool _isInputValid() {
    bool validationStatus = true;
    if (_isUpdateOperation()) {
      /* Update operation. */
      if (!(destinationInstance.id > 0) ||
          destinationInstance.name.isEmpty ||
          destinationInstance.location.isEmpty) {
        validationStatus = false;
      }
    } else {
      /* Add operation. */
      if (!(destinationInstance.id == 0) ||
          destinationInstance.name.isEmpty ||
          destinationInstance.location.isEmpty) {
        validationStatus = false;
      }
    }

    if (!isChanged(
        widget.destination.toString(), destinationInstance.toString())) {
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
                Text('Destination name and location should be letters. '
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
