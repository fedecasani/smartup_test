import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/password_input_page.dart';
import 'package:smartup_test/global/toast.dart';
import 'package:smartup_test/features/user_auth/presentation/widgets/form_container_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            Navigator.pop(context);
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
                "To get started, first enter your email",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 20,
            child: GestureDetector(
              onTap: () {
                _launchURL('https://twitter.com/account/begin_password_reset');
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 20,
            child: SizedBox(
              width: 65,
              height: 35,
              child: FloatingActionButton(
                onPressed: _navigateToPasswordInput,
                backgroundColor: Colors.blue,
                child: _isSigning
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateToPasswordInput() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty && email.contains('@')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordInputPage(email: email),
        ),
      );
    } else {
      showToast(message: "Please enter a valid email");
    }
  }
  Future<void> _launchURL(String url) async {
    try {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } catch (e) {
      showToast(message: 'Could not launch $url');
    }
  }
}
