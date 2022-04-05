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
import '../model/restaurant.dart';
import '../objectbox.g.dart';

class RestaurantDAO {
  RestaurantDAO._internal();

  factory RestaurantDAO.getInstance() {
    return _restaurantDAO;
  }

  static final RestaurantDAO _restaurantDAO = RestaurantDAO._internal();

  static Store store = ObjectBox.getStore();
  final Box<Restaurant> restaurantBox = store.box<Restaurant>();

  /// Get restaurant by Id. */
  Restaurant? getRestaurantById(int restaurantId) {
    return restaurantBox.get(restaurantId);
  }

  /// Get all restaurants. */
  List<Restaurant> getAll() {
    // List<Restaurant> result = [];
    final List<Restaurant> restaurantList = restaurantBox.getAll();
    return restaurantList;
  }

  /// Create a new restaurant.
  /// Restaurant ID should be ZERO. */
  int createRestaurant(Restaurant restaurant) {
    /* create new restaurant and return the id of the new restaurant. */
    restaurantBox.put(restaurant);
    return restaurant.id;
  }

  /// Update a existing restaurant. */
  void updateRestaurant(Restaurant restaurant) {
    /* update the restaurant. */
    restaurantBox.put(restaurant);
  }

  /// Delete restaurant by Id. */
  void deleteRestaurantById(int restaurantId) {
    /* delete the restaurant. */
    restaurantBox.remove(restaurantId);
  }
}
