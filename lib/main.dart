import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/app/splash_screen/splash_screen.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/home_page.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/login_page.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/profile_page.dart';
import 'package:smartup_test/features/user_auth/presentation/pages/sign_up_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBQ38Cmzu60XQXhzJvuk3BtCxnL8gtR4Ag",
            appId: "1:488939344201:web:97a5072bc1eb4ceb688a98",
            messagingSenderId: "488939344201",
            projectId: "smartup-test-d823e"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twitter',
      routes: {
        '/': (context) => SplashScreen(
              child: SignUpPage(),
            ),
        '/login': (context) => LoginPage(),
        '/register': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
