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
import '../model/battery_info.dart';
import '../objectbox.g.dart';

class BatteryInfoDAO {
  BatteryInfoDAO._internal();

  factory BatteryInfoDAO.getInstance() {
    return _batteryInfoDAO;
  }

  static final BatteryInfoDAO _batteryInfoDAO = BatteryInfoDAO._internal();

  static Store store = ObjectBox.getStore();
  final Box<BatteryInfo> batteryInfoBox = store.box<BatteryInfo>();

  /// Get batteryInfo by Id. */
  BatteryInfo? getBatteryInfoById(int batteryInfoId) {
    return batteryInfoBox.get(batteryInfoId);
  }

  /// Get all batteryInfos. */
  List<BatteryInfo> getAll() {
    // List<BatteryInfo> result = [];
    final List<BatteryInfo> batteryInfoList = batteryInfoBox.getAll();
    return batteryInfoList;
  }

  /// Create a new batteryInfo.
  /// BatteryInfo ID should be ZERO. */
  int createBatteryInfo(BatteryInfo batteryInfo) {
    /* create new batteryInfo and return the id of the new batteryInfo. */
    batteryInfoBox.put(batteryInfo);
    return batteryInfo.id;
  }

  /// Update a existing batteryInfo. */
  void updateBatteryInfo(BatteryInfo batteryInfo) {
    /* update the batteryInfo. */
    batteryInfoBox.put(batteryInfo);
  }

  /// Delete batteryInfo by Id. */
  void deleteBatteryInfoById(int batteryInfoId) {
    /* delete the batteryInfo. */
    batteryInfoBox.remove(batteryInfoId);
  }
}
