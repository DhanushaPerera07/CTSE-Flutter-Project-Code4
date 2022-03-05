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

import '../objectbox.g.dart';

class ObjectBox {
  /* Constructor. */
  factory ObjectBox.getInstance() {
    if (hasNotBeenInitialized) {
      _createStore();
      debugPrint('Created Store successfully!');
      hasNotBeenInitialized = false;
    }
    debugPrint('ObjectBox.getInstance() works!');
    return _objectBox;
  }

  /* Constructor (private/internal). */
  ObjectBox._internal();

  static final ObjectBox _objectBox = ObjectBox._internal();
  static late final Store _store;

  /* ObjectBox - Store has not been initialized or not. */
  static bool hasNotBeenInitialized = true;

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<void> _createStore() async {
    debugPrint('_createStore() works!');
    // print("IsOpen: ");
    // print(Store.isOpen(null));
    // if (!Store.isOpen(null)) {
    //   print("Store is created!");
    //   Store store = await openStore();
    // }
    _store = await openStore();
  }

  static Future<void> closeObjectBox() async {
    if (Store?.isOpen(null)) {
      _store.close();
      debugPrint('Store is closed!');
    }
  }

  static Store getStore() {
    return _store;
  }
}
