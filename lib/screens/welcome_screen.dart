import 'package:flashChat/components/rounded_button.dart';
import 'package:flashChat/screens/login_screen.dart';
import 'package:flashChat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  repeatForever: true,
                  text: ['Flash Chat'],
                  speed: Duration(milliseconds: 300),
                  textStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            WelcomeButtons(
              color: Colors.lightBlue,
              text: 'Log in',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
                // var result = FirebaseAuth.instance.signInWithEmailAndPassword(
                //     email: 'test@test.com', password: '123123');
                // print('The user logged' + result.toString());
              },
            ),
            WelcomeButtons(
              color: Colors.blueAccent,
              text: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
