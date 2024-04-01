import 'package:flutter/material.dart';
import 'package:places_app/src/screens/screens.dart'
    show PlaceScreen, MapScreen, AccountScreen;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    PlaceScreen(),
    MapScreen(),
    AccountScreen(),
  ];

  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.place),
                label: 'Lugares',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Mapa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Cuenta',
              ),
            ],
            onTap: _changeScreen,
          ),
          floatingActionButton: _currentIndex != 0
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    // TODO agregar un nuevo
                  },
                  child: const Icon(Icons.add),
                )),
    );
  }
}
