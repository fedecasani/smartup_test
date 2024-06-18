import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartup_test/features/user_auth/presentation/widgets/navigation_bar.dart';

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
        title: Image.asset(
          'assets/twitter_icon.png',
          height: 40,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(
              '✨',
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
            onPressed: () {
              // Acción al presionar el emoji de estrella brillante
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
        backgroundColor: Colors.black, // Color de fondo personalizado para el BottomNavigationBar
      ),
    );
  }
}
