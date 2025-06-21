import 'package:flutter/material.dart';
import 'note_page.dart';

class OnboardingPage extends StatelessWidget {
  // ignore: use_super_parameters
  const OnboardingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NotePage()),
            );
          },
          child: Text('Go to Notes'),
        ),
      ),
    );
  }
}
