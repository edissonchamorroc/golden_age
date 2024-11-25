import 'package:flutter/material.dart';
import 'package:golden_age/pages/login_pages.dart';
import 'package:golden_age/pages/rutina_page.dart';
import 'package:golden_age/pages/seguimiento_page.dart';
import 'package:golden_age/repository/firebase_api.dart';
import 'package:golden_age/pages/create_routine_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0;
  final FirebaseApi _firebaseApi = FirebaseApi();

  Future<void> _onLogoutButtonClicked() async {
    await _firebaseApi.singOutUser();
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  static const List<Widget> _widgetOptions = <Widget>[
    RutinaPage(),
    SeguimientoPage(),
    CreateRoutinePage()
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavigationBarPage()));
              },
            ),
            TextButton(
              child: Text('Salir'),
              onPressed: () {
                _onLogoutButtonClicked();
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
        backgroundColor: const Color.fromARGB(206, 0, 0, 0),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout(); // Despliega el diálogo de logout
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagenes/olimpiashadow2.png"),
            fit: BoxFit
                .cover, // Ajusta la imagen para que cubra toda la pantalla
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: "Genera tu Rutina"),
          BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq_rounded), label: "Seguimiento"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_outlined),
              label: "Diseña tu Rutina"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
