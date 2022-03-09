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
import 'dart:core';

import 'package:objectbox/objectbox.dart';

@Entity()
class BatteryInfo {
  // BatteryInfo(this.id, this.batteryPercentage, this.dateTime);
  BatteryInfo(
      {required this.id, required this.batteryPercentage, DateTime? dateTime})
      : dateTime = dateTime ?? DateTime.now();

  BatteryInfo.name(this.id, this.batteryPercentage, this.dateTime);

  @Id()
  int id;
  int batteryPercentage;

  // Time with millisecond precision restored in UTC time zone.
  @Transient()
  DateTime dateTime;

  int get dbUtcDate {
    return dateTime.millisecondsSinceEpoch;
  }

  set dbUtcDate(int value) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(value);
  }

  @override
  String toString() {
    return 'BatteryInfo{id: $id, batteryPercentage: $batteryPercentage, dateTime: ${dateTime.toIso8601String()}}';
  }
}
