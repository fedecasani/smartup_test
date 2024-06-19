import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartup_test/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/home_page.dart';
import 'package:smartup_test/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:smartup_test/global/toast.dart';

class SignUpDetailsPage extends StatefulWidget {
  const SignUpDetailsPage({super.key});

  @override
  State<SignUpDetailsPage> createState() => _SignUpDetailsPageState();
}

class _SignUpDetailsPageState extends State<SignUpDetailsPage> {
  bool _isSigningUp = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.twitter, // Ícono de Twitter
                  color: Colors.blue,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false, // Desactiva el botón de "volver" automático
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create your account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FormContainerWidget(
                  controller: _usernameController,
                  hintText: "Name",
                  isPasswordField: false,
                  maxLength: 50,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 80), // Añadir un espacio para evitar que los campos se superpongan con el botón
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 35,
        child: FloatingActionButton(
          onPressed: _isSigningUp ? null : _signUp,
          backgroundColor: Colors.blue,
          child: _isSigningUp
              ? SizedBox(
                  width: 20,
                  height: 15,
                child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
              )
              : Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _isSigningUp = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isSigningUp = false;
    });

    if (user != null) {
      print("User is successfully created");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      showToast(message: "Some error occurred");
    }
  }
}
