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
import '../database/objectbox.dart';
import '../model/transportation.dart';
import '../objectbox.g.dart';

class TransportationDAO {
  TransportationDAO._internal();

  factory TransportationDAO.getInstance() {
    return _transportationDAO;
  }

  static final TransportationDAO _transportationDAO = TransportationDAO._internal();

  static Store store = ObjectBox.getStore();
  final Box<Transportation> transportationBox = store.box<Transportation>();

  /// Get transportation by Id. */
  Transportation? getTransportationById(int transportationId) {
    return transportationBox.get(transportationId);
  }

  /// Get all transportations. */
  List<Transportation> getAll() {
    // List<Transportation> result = [];
    final List<Transportation> transportationList = transportationBox.getAll();
    return transportationList;
  }

  /// Create a new transportation.
  /// Transportation ID should be ZERO. */
  int createTransportation(Transportation transportation) {
    /* create new transportation and return the id of the new transportation. */
    transportationBox.put(transportation);
    return transportation.id;
  }

  /// Update a existing transportation. */
  void updateTransportation(Transportation transportation) {
    /* update the transportation. */
    transportationBox.put(transportation);
  }

  /// Delete transportation by Id. */
  void deleteTransportationById(int transportationId) {
    /* delete the transportation. */
    transportationBox.remove(transportationId);
  }
}
