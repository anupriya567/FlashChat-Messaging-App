import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    // controller =
    //     AnimationController(duration: Duration(seconds: 5), vsync: this);
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    //
    // controller.forward();
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed)
    //     controller.reverse(from: 1.0);
    //   else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    // controller.addListener(() {
    //   setState(() {});
    //   print(animation.value);
    // });
  }
  @override
  void dispose()
  {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.png'),
                  height: 60.0
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 45.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Flash Chat'),
                    ],

                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: "LogIn", colour: Colors.lightBlueAccent, onPressed: (){Navigator.pushNamed(context, 'login_screen');} ),
            RoundedButton(title: "Register", colour: Colors.blueAccent, onPressed: (){Navigator.pushNamed(context, 'registration_screen');} ),
          ],
        ),
      ),
    );
  }
}

