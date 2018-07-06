// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:firstapp/fragments/accordianWidget/accordianWidget.dart';
import 'package:firstapp/fragments/gallaryImageWidget.dart';
import 'package:firstapp/fragments/cameraImageWidget.dart';
import 'package:firstapp/fragments/shoppingWidget/shoppingMain.dart';
import 'package:firstapp/fragments/third_fragment.dart';
import 'package:firstapp/fragments/first_fragment.dart';

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  })  : _icon = icon,
        _color = color,
        _title = title,
        item = new BottomNavigationBarItem(
          icon: icon,
          // activeIcon: activeIcon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(
      BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: new Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomInactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
        margin: const EdgeInsets.all(4.0),
        width: iconTheme.size - 8.0,
        height: iconTheme.size - 8.0,
        decoration: new BoxDecoration(
          border: new Border.all(color: iconTheme.color, width: 2.0),
        ));
  }
}

class BottomNavigation extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _BottomNavigationDemoState createState() => new _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  //BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        title: 'Alarm',
        color: Colors.deepPurple,
        vsync: this,
      ),
      new NavigationIconView(
        activeIcon: new CustomIcon(),
        icon: new CustomInactiveIcon(),
        title: 'Box',
        color: Colors.deepOrange,
        vsync: this,
      ),
      new NavigationIconView(
        activeIcon: const Icon(Icons.cloud),
        icon: const Icon(Icons.cloud_queue),
        title: 'Cloud',
        color: Colors.teal,
        vsync: this,
      ),
      new NavigationIconView(
        activeIcon: const Icon(Icons.favorite),
        icon: const Icon(Icons.favorite_border),
        title: 'Favorites',
        color: Colors.indigo,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.event_available),
        title: 'Event',
        color: Colors.pink,
        vsync: this,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack(_currentIndex) {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews) {
      print(_currentIndex);

      transitions.add(view.transition(_type, context));
    }

    // We want to have the newly animating (fading in) views on top.
    // transitions.sort((FadeTransition a, FadeTransition b) {
    //   final Animation<double> aAnimation = a.opacity;
    //   final Animation<double> bAnimation = b.opacity;
    //   final double aValue = aAnimation.value;
    //   final double bValue = bAnimation.value;
    //   return aValue.compareTo(bValue);
    // });
    switch (_currentIndex) {
      case 0:
        return new FirstFragment();
      case 1:
        return new CameraImageWidget();
      case 2:
        return new AccordianWidget();
      case 3:
        return new GallaryImageWidget();
      case 4:
        return new ShoppingMain();

      default:
        return new FirstFragment();
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      // appBar: new AppBar(
      //   // title: const Text('Bottom navigation'),
      //   actions: <Widget>[
      //     new PopupMenuButton<BottomNavigationBarType>(
      //       onSelected: (BottomNavigationBarType value) {
      //         setState(() {
      //           _type = value;
      //         });
      //       },
      //       itemBuilder: (BuildContext context) =>
      //           <PopupMenuItem<BottomNavigationBarType>>[
      //             const PopupMenuItem<BottomNavigationBarType>(
      //               value: BottomNavigationBarType.fixed,
      //               child: const Text('Fixed'),
      //             ),
      //             const PopupMenuItem<BottomNavigationBarType>(
      //               value: BottomNavigationBarType.shifting,
      //               child: const Text('Shifting'),
      //             )
      //           ],
      //     )
      //   ],
      // ),
      body: new Center(child: _buildTransitionsStack(_currentIndex)),
      bottomNavigationBar: botNavBar,
    );
  }
}

// import 'package:flutter/material.dart';

// class SecondFragment extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return new Center(
//       child: new Text("Hello Fragment 2"),
//     );
//   }

// }
