import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartup_test/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/home_page.dart';
import 'package:smartup_test/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:smartup_test/global/toast.dart';

class PasswordInputPage extends StatefulWidget {
  final String email;

  const PasswordInputPage({Key? key, required this.email}) : super(key: key);

  @override
  _PasswordInputPageState createState() => _PasswordInputPageState();
}

class _PasswordInputPageState extends State<PasswordInputPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.twitter,
              color: Colors.blue,
              size: 26.0,
            ),
          ),
        ),
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.lightBlue,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register'); // Navegar a la pantalla de registro
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Enter your password",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65,
        height: 35,
        child: FloatingActionButton(
          onPressed: _signIn,
          backgroundColor: Colors.blue,
          child: _isSigning
              ? SizedBox(
                width: 20,
                height: 15,
                child: CircularProgressIndicator(color: Colors.white))
              : Text("Log in", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String password = _passwordController.text;
    User? user =
        await _auth.signInWithEmailAndPassword(widget.email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      print("User is successfully signed in");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      print("Some error occurred");
      showToast(message: "Some error occurred");
    }
  }
}
