import 'package:firstapp/fragments/first_fragment.dart';
import 'package:firstapp/fragments/bottomNavigation.dart';
import 'package:firstapp/fragments/third_fragment.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/fragments/favWordsScreen.dart';
import 'package:firstapp/fragments/accordianWidget/accordianWidget.dart';
import 'package:firstapp/fragments/gallaryImageWidget.dart';
import 'package:firstapp/fragments/cameraImageWidget.dart';
import 'package:firstapp/fragments/shoppingWidget/shoppingMain.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("All Word Listing", Icons.local_pizza),
    new DrawerItem("Accordian List Widget", Icons.widgets),
    new DrawerItem("Image Upload Gallery", Icons.image),
    new DrawerItem("Image Upload Camera", Icons.camera),
    new DrawerItem("Shopping List Widget", Icons.shopping_basket)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new BottomNavigation();
      case 1:
        return new FirstFragment();
      case 2:
        return new AccordianWidget();
      case 3:
        return new GallaryImageWidget();
      case 4:
        return new CameraImageWidget();
      case 5:
        return new ShoppingMain();

      case 6:
        return new ThirdFragment();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("John Doe"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
