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
import '../model/hotel.dart';
import '../objectbox.g.dart';

class HotelDAO {
  HotelDAO._internal();

  factory HotelDAO.getInstance() {
    return _hotelDAO;
  }

  static final HotelDAO _hotelDAO = HotelDAO._internal();

  static Store store = ObjectBox.getStore();
  final Box<Hotel> hotelBox = store.box<Hotel>();

  /// Get hotel by Id. */
  Hotel? getHotelById(int hotelId) {
    return hotelBox.get(hotelId);
  }

  /// Get all hotels. */
  List<Hotel> getAll() {
    // List<Hotel> result = [];
    final List<Hotel> hotelList = hotelBox.getAll();
    return hotelList;
  }

  /// Create a new hotel.
  /// Hotel ID should be ZERO. */
  int createHotel(Hotel hotel) {
    /* create new hotel and return the id of the new hotel. */
    hotelBox.put(hotel);
    return hotel.id;
  }

  /// Update a existing hotel. */
  void updateHotel(Hotel hotel) {
    /* update the hotel. */
    hotelBox.put(hotel);
  }

  /// Delete hotel by Id. */
  void deleteHotelById(int hotelId) {
    /* delete the hotel. */
    hotelBox.remove(hotelId);
  }
}
