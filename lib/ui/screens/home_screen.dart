import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/ui/screens/page_views/chat_list_screen.dart';

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
      //UniversalVariables.blackColor,
      body: PageView(
        children: <Widget>[
          Container(
            child: ChatListScreen(),
          ),
          Center(
              child: Text(" A mere screen 2",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
          Center(
              child: Text(" A mere screen 3",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        child: Padding(
          // padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CupertinoTabBar(
            backgroundColor: Colors.deepPurple,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: (_page == 0) ? Colors.white : Colors.purple,
                  size: 30,
                ),
                // title: Text(
                //   "Chat",
                //   style: TextStyle(
                //     fontSize: 10.0,
                //     color: (_page == 0) ? Colors.deepPurple : Colors.white,
                //   ),
                // ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.call,
                  color: (_page == 1) ? Colors.white : Colors.purple,
                  size: 30,
                ),
                // title: Text(
                //   "Call",
                //   style: TextStyle(
                //     fontSize: 10.0,
                //     color: (_page == 1) ? Colors.deepPurple : Colors.white,
                //   ),
                // ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.import_contacts,
                  color: (_page == 2) ? Colors.white : Colors.purple,
                  size: 30.0,
                ),
                // title: Text(
                //   "Contact",
                //   style: TextStyle(
                //     fontSize: 10.0,
                //     color: (_page == 2) ? Colors.deepPurple : Colors.white,
                //   ),
                // ),
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
