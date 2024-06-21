import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartup_test/features/user_auth/presentation/models/tweet_model.dart';
import 'package:smartup_test/features/user_auth/presentation/widgets/navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Importa el paquete para formatear fechas
import 'dart:math'; // Importa el paquete para generar números aleatorios

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, String>> _stories = [];
  final Random _random = Random();

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
    final currentUser = FirebaseAuth.instance.currentUser;
    List<Map<String, String>> stories = [];
    if (currentUser != null) {
      // Obtener imagen del usuario actual
      final imageUrl =
          currentUser.photoURL ?? 'https://via.placeholder.com/150';
      stories.add({
        'name': 'Add',
        'imageUrl': imageUrl,
      });
    }
    for (int i = 0; i < 9; i++) {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final name =
            '${data['results'][0]['name']['first']} ${data['results'][0]['name']['last']}';
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

  Future<void> _createTweet(String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final tweet = Tweet(
        id: FirebaseFirestore.instance.collection('tweets').doc().id,
        content: content,
        userId: user.uid,
        userEmail: user.email ?? '',
        userProfileImageUrl:
            user.photoURL ?? 'https://via.placeholder.com/150', // Nuevo campo
        timestamp: Timestamp.now(),
      );
      await FirebaseFirestore.instance
          .collection('tweets')
          .doc(tweet.id)
          .set(tweet.toMap());
    }
  }

  void _showTweetDialog() {
    String tweetContent = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Create Tweet',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Form(
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'What\'s happening?',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        tweetContent = value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            TextButton(
              onPressed: () {
                _createTweet(tweetContent);
                Navigator.of(context).pop();
              },
              child: Text(
                'Tweet',
                style: TextStyle(color: Colors.blue, fontSize: 16.0),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return DateFormat('MMM dd').format(timestamp.toDate());
    }
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
                  Navigator.pushNamed(context, "/home");
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, "/profile");
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
                if (index == 0) {
                  // Primer elemento: círculo de perfil con "Add"
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 31.0,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 28.0,
                                // Mostrar la imagen del usuario actual aquí
                                backgroundImage:
                                    NetworkImage(_stories[index]['imageUrl']!),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          bottom: 20, // Ajuste aquí para subir el icono "Add"
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Elementos siguientes: historias
                  final storyIndex = index;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 31.0,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: 28.0,
                            backgroundImage:
                                NetworkImage(_stories[storyIndex]['imageUrl']!),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          _stories[storyIndex]['name']!,
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Divider(
            color: Colors.grey[800],
            thickness: 1.0,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tweets')
                  .orderBy('timestamp', descending: true) // Ordenar por timestamp en orden descendente
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final tweets = snapshot.data!.docs
                    .map((doc) =>
                        Tweet.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (context, index) {
                    final tweet = tweets[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: Colors.grey[850],
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(tweet
                              .userProfileImageUrl), // Usar la URL de la imagen del tweet
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tweet.userEmail,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    _formatTimestamp(tweet.timestamp),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              tweet.content,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildIconWithCount(FontAwesomeIcons.comment),
                            SizedBox(width: 10),
                            _buildIconWithCount(FontAwesomeIcons.retweet),
                            SizedBox(width: 10),
                            _buildIconWithCount(FontAwesomeIcons.heart),
                            SizedBox(width: 10),
                            IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.arrowUpFromBracket,
                                color: Colors.white,
                                size: 16.0,
                              ),
                              onPressed: () {
                                // Acción cuando se presiona el ícono de compartir
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
          onPressed: _showTweetDialog,
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

  Widget _buildIconWithCount(IconData iconData) {
    final int count = _random.nextInt(10) + 1;
    return Row(
      children: [
        IconButton(
          icon: FaIcon(
            iconData,
            color: Colors.white,
            size: 16.0,
          ),
          onPressed: () {
            // Acción cuando se presiona el ícono
          },
        ),
        Text(
          '$count',
          style: TextStyle(color: Colors.white, fontSize: 12.0),
        ),
      ],
    );
  }
}
