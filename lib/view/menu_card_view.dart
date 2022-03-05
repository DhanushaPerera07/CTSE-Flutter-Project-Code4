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

import '../model/menu_tile.dart';

class MenuCardState extends InheritedWidget {
  const MenuCardState(
      {Key? key, required this.menuTiles, required Widget child})
      : super(key: key, child: child);

  final List<MenuTile> menuTiles;

  static MenuCardState of(BuildContext context) {
    final MenuCardState? result =
        context.dependOnInheritedWidgetOfExactType<MenuCardState>();
    assert(result != null, 'No MenuCardState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MenuCardState oldWidget) {
    return oldWidget.menuTiles != menuTiles;
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Image.network(
                MenuCardState.of(context).menuTiles[index].imageUrl,
                width: 100),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            alignment: Alignment.center,
            child: Text(MenuCardState.of(context).menuTiles[index].title,
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
