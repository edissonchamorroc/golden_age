import 'package:flutter/material.dart';
import 'package:golden_age/pages/rutina_page.dart';
import 'package:golden_age/pages/login_pages.dart';
import 'package:golden_age/pages/seguimiento_page.dart';
import 'package:golden_age/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    RutinaPage(),
    SeguimientoPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar sesión'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salir'),
              onPressed: () {
                //Navigator.of(context).pop();
                // Lógica para logout (redireccionar o limpiar sesión)
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: Icon(Icons.menu, color: Colors.white),
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                //color: Theme.of(context).primaryColor,
                color: Colors.black,
              ),
              margin: EdgeInsets.zero,
              child: Container(
                height: kToolbarHeight, // Utiliza la altura del AppBar
                alignment: Alignment.center,
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                //funcion
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                _logout(); // Despliega el diálogo de logout
              },
            ),
          ],
        ),
      ),
      body: Container(
        /*
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/olimpiashadow2.png"),
            fit: BoxFit
                .cover, // Ajusta la imagen para que cubra toda la pantalla
          ),
        ),*/
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: "Rutina"),
          BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq_rounded), label: "Seguimiento"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
