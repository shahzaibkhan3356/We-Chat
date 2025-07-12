import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chat_app/Presentation/Ui/Chats/ChatsPage.dart';
import 'package:chat_app/Presentation/Ui/Contacts/ContactsPage.dart';
import 'package:chat_app/Presentation/Ui/Profile/ProfilePage/ProfilePage.dart';
import 'package:chat_app/Utils/Constants/AppFonts/AppFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final List<Widget> _screens = [const Chatspage(), const Contactspage(), const Profilepage()];

  final iconList = <IconData>[
    CupertinoIcons.chat_bubble,
    Icons.contacts_outlined,
    CupertinoIcons.arrow_2_circlepath,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curve);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 1
              ? 'Chats'
              : _currentIndex == 2
              ? 'Stories'
              : _currentIndex == 2
              ? 'Contacts'
          style: AppFonts.headingSmall,
        ),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        iconSize: 25,
        scaleFactor: 10,
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        backgroundColor: Colors.black26,
        activeColor: Colors.deepPurpleAccent,
        inactiveColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        splashColor: Colors.deepPurpleAccent,
        leftCornerRadius: 32,
        elevation: 10,
      ),
    );
  }
}
