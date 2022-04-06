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
import '../model/destination.dart';
import '../model/hotel.dart';
import '../model/menu_tile.dart';
import '../model/restaurant.dart';
import '../model/transportation.dart';

/* temporary sample data. */
List<MenuTile> menuTiles = <MenuTile>[
  // MenuTile(),
  MenuTile.name('https://bit.ly/3LLEyKA', 'Hotels', '/hotels'),
  MenuTile.name('https://bit.ly/3xdn1XH', 'Restaurants', '/restaurants'),
  MenuTile.name('https://bit.ly/3uWyMyH', 'Transportation', '/transportation'),
  MenuTile.name('https://bit.ly/38ALmfP', 'Destination', '/destinations'),
  // MenuTile.name('https://picsum.photos/250?image=12', 'Battery', '/battery-info'),

];

/* temporary sample data. */
List<Restaurant> restaurantList = <Restaurant>[
  Restaurant.name(1, 'Royal Ramesses', 'Seeduwa'),
  Restaurant.name(2, 'Amora Lagoon', 'Seeduwa'),
  Restaurant.name(3, 'Angel Beach Hotel', 'Galle'),
];

/* temporary sample data. */
List<Transportation> transportationList = <Transportation>[
  Transportation.name(1, 'PA-1234', 'Toyota', '4','abc'),
  Transportation.name(2, 'CAS-5555', 'Benz', '4','abc'),
  Transportation.name(3, 'NA-5656', 'Toyota', '10','abcd'),
];

/* temporary sample data. */
List<Destination> destinationList = <Destination>[
  Destination.name(1, 'Galle Fort', 'Galle'),
  Destination.name(2, 'Jaffna Fort', 'Jaffna'),
  Destination.name(3, 'Hikkaduwa Beach', 'Hikkaduwa'),
];
