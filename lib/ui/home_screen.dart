import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;

  void navigationTapped(page) {
    pageController.jumpToPage(page);
//    pageController.jumpTo(page);
  }

  void onPageChanged(page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: PageView(
        children: <Widget>[
          Center(child: Text(" A mere screen 1", style: TextStyle(color: Colors.white,))),
          Center(child: Text(" A mere screen 2", style: TextStyle(color: Colors.white,))),
          Center(child: Text(" A mere screen 3", style: TextStyle(color: Colors.white,))),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: CupertinoTabBar(
            backgroundColor: Colors.black26,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: (_page == 0) ? Colors.purpleAccent : Colors.white12,
                ),
                title: Text(
                  "Chat",
                  style: TextStyle(
                    fontSize: 10.0,
                    color: (_page == 0) ? Colors.purpleAccent : Colors.white12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.call,
                  color: (_page == 1) ? Colors.purpleAccent : Colors.white12,
                ),
                title: Text(
                  "Call",
                  style: TextStyle(
                    fontSize: 10.0,
                    color: (_page == 1) ? Colors.purpleAccent : Colors.white12,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.contacts,
                  color: (_page == 2) ? Colors.purpleAccent : Colors.white12,
                ),
                title: Text(
                  "Contact",
                  style: TextStyle(
                    fontSize: 10.0,
                    color: (_page == 2) ? Colors.purpleAccent : Colors.white12,
                  ),
                ),
              ),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
