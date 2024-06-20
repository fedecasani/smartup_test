import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartup_test/features/user_auth/presentation/widgets/navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, String>> _stories = [];

  @override
  void initState() {
    super.initState();
    _fetchStoryData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchStoryData() async {
    List<Map<String, String>> stories = [];
    for (int i = 0; i < 10; i++) {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final name = '${data['results'][0]['name']['first']} ${data['results'][0]['name']['last']}';
        final imageUrl = data['results'][0]['picture']['large'];
        stories.add({'name': name, 'imageUrl': imageUrl});
      } else {
        stories.add({
          'name': 'Placeholder Name',
          'imageUrl': 'https://via.placeholder.com/150'
        });
      }
    }
    setState(() {
      _stories = stories;
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
          FontAwesomeIcons.twitter,
          color: Colors.blue,
          size: 26.0,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.starHalfAlt,
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
                  Navigator.pushNamed(context, "/register");
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 100.0,
            color: Colors.grey[900],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 31.0,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          radius: 28.0,
                          backgroundImage: NetworkImage(_stories[index]['imageUrl']!),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        _stories[index]['name']!,
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(
            color: Colors.grey[800],
            thickness: 1.0,
          ),
          Expanded(
            child: Center(
              child: Text(
                "Welcome to Home",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            // Acción al presionar el botón de pluma
          },
          backgroundColor: Colors.blue,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.feather,
                color: Colors.white,
                size: 18.0,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 10.0,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
