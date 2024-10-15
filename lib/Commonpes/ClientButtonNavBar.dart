import 'package:flutter/material.dart';
class  ClientButtonNavBar extends StatefulWidget {
  final int selectedIndex;
  const ClientButtonNavBar({required this.selectedIndex});

  @override
  State<ClientButtonNavBar> createState() => _ClientButtonNavBarState();
}

class _ClientButtonNavBarState extends State<ClientButtonNavBar> {
  late int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        {
          Navigator.pushNamed(context, '/CategorieDeListVoitures');
        }
        break;

      case 1:
        {
          Navigator.pushNamed(context, '/CategorieDeListPieces');
        }
        break;
      case 2:
        {
          Navigator.pushNamed(context, '/EditProfile');
        }
        break;
      case 3:
        {
          Navigator.pushNamed(context, '/notifications');
        }
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.red,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.car_crash_outlined),
          label: 'Voiture',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build_circle),
          label: 'piece de rechange',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Compte',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.send),
          label: 'send',
        ),
      ],
      currentIndex:widget.selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
