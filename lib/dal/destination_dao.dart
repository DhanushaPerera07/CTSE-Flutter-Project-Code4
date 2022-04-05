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
import '../model/destination.dart';
import '../objectbox.g.dart';

class DestinationDAO {
  DestinationDAO._internal();

  factory DestinationDAO.getInstance() {
    return _destinationDAO;
  }

  static final DestinationDAO _destinationDAO = DestinationDAO._internal();

  static Store store = ObjectBox.getStore();
  final Box<Destination> destinationBox = store.box<Destination>();

  /// Get destination by Id. */
  Destination? getDestinationById(int destinationId) {
    return destinationBox.get(destinationId);
  }

  /// Get all destinations. */
  List<Destination> getAll() {
    // List<Destination> result = [];
    final List<Destination> destinationList = destinationBox.getAll();
    return destinationList;
  }

  /// Create a new destination.
  /// Destination ID should be ZERO. */
  int createDestination(Destination destination) {
    /* create new Destination and return the id of the new destination. */
    destinationBox.put(destination);
    return destination.id;
  }

  /// Update a existing Destination. */
  void updateDestination(Destination destination) {
    /* update the destination. */
    destinationBox.put(destination);
  }

  /// Delete destination by Id. */
  void deleteDestinationById(int destinationId) {
    /* delete the Destination. */
    destinationBox.remove(destinationId);
  }
}
