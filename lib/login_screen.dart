import 'package:flutter/material.dart';
import 'package:damh/sign_in.dart';
import 'package:damh/sign_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/ghibli.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 120, 5, 20),
              ),
              Image.asset(
                'images/shoelogo.jpg',
                height: 150,
              ),
              SizedBox(height: 100),
              button(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SignUp()));
                },
                text: 'Sign up',
              ),
              SizedBox(height: 45),
              button(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SignIn()));
                },
                text: 'Sign in',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class button extends StatelessWidget {
  String text;
  final void Function() onPressed;

  button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 94, 92, 92),
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
