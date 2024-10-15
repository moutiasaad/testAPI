import 'package:flutter/material.dart';
class  ButtonNavBar extends StatefulWidget {
  final int selectedIndex;
  const ButtonNavBar({required this.selectedIndex});

  @override
  State< ButtonNavBar> createState() => _ButtonNavBarState();
}

class _ButtonNavBarState extends State<ButtonNavBar> {
  late int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        {
          Navigator.pushNamed(context, '/CategorieListVoitures');
        }
        break;

      case 1:
        {
          Navigator.pushNamed(context, '/CategorieListPieces');
        }
        break;
      case 2:
        {
          Navigator.pushNamed(context, '/CategorieDeListVoitures');
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
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build_circle),
          label: 'piece de rechange',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Compte',
        ),
      ],
      currentIndex:widget.selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}
