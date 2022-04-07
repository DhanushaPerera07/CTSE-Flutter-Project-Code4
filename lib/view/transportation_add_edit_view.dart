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

import '../dal/transportation_dao.dart';
import '../model/transportation.dart';
import '../util/crypto_util.dart';
import '../util/toast_message_util.dart';

class TransportationAddEditView extends StatefulWidget {
  const TransportationAddEditView({Key? key, required this.transportation})
      : super(key: key);

  /* Route */
  static const String addTransportationRoute = '/transportations/add';
  static const String editTransportationRoute = '/transportations/edit';

  final Transportation transportation;

  @override
  State<TransportationAddEditView> createState() =>
      _TransportationAddEditViewState();
}

class _TransportationAddEditViewState extends State<TransportationAddEditView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _vehicleNoController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleSeatNoController =TextEditingController();
  final TextEditingController _vehicleOwnerNameController =TextEditingController();

  Transportation transportationInstance = Transportation(0, '', '', '', '');
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    /* Set values to the TextFields. */
    setTransportationDetails();
    if (_isUpdateOperation()) {
      transportationInstance.id = widget.transportation.id;
      transportationInstance.vehicleNo = widget.transportation.vehicleNo;
      transportationInstance.vehicleModel = widget.transportation.vehicleModel;
      transportationInstance.noSeats = widget.transportation.noSeats;
      transportationInstance.ownerName = widget.transportation.ownerName;

      setState(() {
        isValid = _isInputValid();
      });
    }

    _vehicleNoController.addListener(() {
      final String vehicleNo = _vehicleNoController.text;
      debugPrint('VehicleNoField: $vehicleNo');
      transportationInstance.vehicleNo = vehicleNo.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _vehicleModelController.addListener(() {
      final String vehicleModel = _vehicleModelController.text;
      debugPrint('VehicleModelTextField: $vehicleModel');
      transportationInstance.vehicleModel = vehicleModel.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _vehicleSeatNoController.addListener(() {
      final String noSeat = _vehicleSeatNoController.text;
      debugPrint('SeatNoTextField: $noSeat');
      transportationInstance.noSeats = noSeat.trim();

      setState(() {
        isValid = _isInputValid();
      });
    });

    _vehicleOwnerNameController.addListener(() {
      final String ownerName = _vehicleOwnerNameController.text;
      debugPrint('VehicleOwnerNameTextField: $ownerName');
      transportationInstance.ownerName = ownerName.trim();

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
    _vehicleNoController.dispose();
    _vehicleModelController.dispose();
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
    return widget.transportation.id > 0;
  }

  Text _getTitleWidgets() {
    if (_isUpdateOperation()) {
      return const Text('Update Transportation');
    } else {
      return const Text('Add New Transportation');
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
          hintText: 'Transportation ID',
        ),
      ),
    );

    final List<Widget> list = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          controller: _vehicleNoController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter vehicle number',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextField(
          controller: _vehicleModelController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter vehicle model',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: _vehicleSeatNoController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter vehicle seat no',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          controller: _vehicleOwnerNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Owners name',
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
                        final TransportationDAO transportationDAO =
                            TransportationDAO.getInstance();
                        transportationDAO
                            .updateTransportation(transportationInstance);
                        /* Print all the transportations. */
                        debugPrint(
                            '************** Transportation List ***************************');
                        transportationDAO.getAll().forEach(
                            (Transportation transportation) =>
                                debugPrint(transportation.toString()));
                        displayToastMessage(
                            'Transportation updated successfully!',
                            Colors.blue[900]);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/transportation', ModalRoute.withName('/'));
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
                  final TransportationDAO transportationDAO =
                      TransportationDAO.getInstance();
                  transportationDAO
                      .deleteTransportationById(transportationInstance.id);
                  /* Print all the transportations. */
                  debugPrint(
                      '************** Transportation List ***************************');
                  transportationDAO.getAll().forEach(
                      (Transportation transportation) =>
                          debugPrint(transportation.toString()));
                  displayToastMessage(
                      'Transportation deleted successfully!', Colors.amber);
                } catch (e) {
                  debugPrint(e.toString());
                  displayToastMessage(
                      'Error: something went wrong!', Colors.red);
                }

                /* Navigate to previous screen. */
                Navigator.pushNamedAndRemoveUntil(
                    context, '/transportation', ModalRoute.withName('/'));
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
                        final TransportationDAO transportationDAO =
                            TransportationDAO.getInstance();
                        transportationDAO
                            .createTransportation(transportationInstance);
                        /* Print all the transportations. */
                        debugPrint(
                            '************** Transportation List ***************************');
                        transportationDAO.getAll().forEach(
                            (Transportation transportation) =>
                                debugPrint(transportation.toString()));
                        displayToastMessage(
                            'Transportation added successfully!', Colors.green);
                      } catch (e) {
                        debugPrint(e.toString());
                        displayToastMessage(
                            'Error: something went wrong!', Colors.red);
                      }

                      /* Navigate to previous screen. */
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/transportation', ModalRoute.withName('/'));
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

  /* Set transportation details into TextFields. */
  void setTransportationDetails() {
    if (_isUpdateOperation()) {
      _idController.text = widget.transportation.id.toString();
    }
    _vehicleNoController.text = widget.transportation.vehicleNo;
    _vehicleModelController.text = widget.transportation.vehicleModel;
    _vehicleSeatNoController.text = widget.transportation.noSeats;
    _vehicleOwnerNameController.text = widget.transportation.ownerName;

    setState(() {
      isValid = _isInputValid();
    });
  }

  /* Validate the user input. */
  bool _isInputValid() {
    bool validationStatus = true;
    if (_isUpdateOperation()) {
      /* Update operation. */
      if (!(transportationInstance.id > 0) ||
          transportationInstance.vehicleNo.isEmpty ||
          transportationInstance.vehicleModel.isEmpty ||
          transportationInstance.noSeats.isEmpty ||
          transportationInstance.ownerName.isEmpty) {
        validationStatus = false;
      }
    } else {
      /* Add operation. */
      if (!(transportationInstance.id == 0) ||
          transportationInstance.vehicleNo.isEmpty ||
          transportationInstance.vehicleModel.isEmpty ||
          transportationInstance.noSeats.isEmpty ||
          transportationInstance.ownerName.isEmpty) {
        validationStatus = false;
      }
    }

    if (!isChanged(
        widget.transportation.toString(), transportationInstance.toString())) {
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
                Text('Please fill all the values '
                    'Insert the vehicle details here!.'),
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
