import 'package:flutter/material.dart';

import '../containers/containers.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (_selectedTabIndex) {
      case 0:
        body = ShoppingScreen();
        break;

      case 1:
        body = CouponScreen();
        break;
    }
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('Shopping')),
          BottomNavigationBarItem(icon: Icon(Icons.redeem), title: Text('Coupons')),
        ],
        currentIndex: _selectedTabIndex,
        onTap: (int index) {
          setState(() {
            _selectedTabIndex = index;
          });
        }
      ),
    );
  }
}