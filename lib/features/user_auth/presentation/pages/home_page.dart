import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartup_test/features/user_auth/presentation/widgets/navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importa el paquete

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Estado para el índice seleccionado del bottom navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.blue),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: FaIcon(
          FontAwesomeIcons.twitter, // Ícono de Twitter
          color: Colors.blue,
          size: 26.0,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.starHalfAlt, // Ícono de estrella sólida
              color: Colors.blue,
              size: 24.0,
            ),
            onPressed: () {
              // Acción al presionar el icono de estrella brillante
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[850],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: 40),
              ListTile(
                leading: Icon(Icons.home, color: Colors.blue),
                title: Text('Home', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Welcome to Home",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: SizedBox(
        width: 50, // Ancho del botón
        height: 50, // Alto del botón
        child: FloatingActionButton(
          onPressed: () {
            // Acción al presionar el botón de pluma
          },
          backgroundColor: Colors.blue,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // Radio del borde del botón
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.feather, // Icono de pluma
                color: Colors.white, // Color del ícono
                size: 18.0, // Tamaño del ícono
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: FaIcon(
                  FontAwesomeIcons.plus, // Icono de signo más
                  color: Colors.white, // Color del ícono
                  size: 10.0, // Tamaño del ícono
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Ubicación del botón en la esquina inferior derecha
    );
  }
}
