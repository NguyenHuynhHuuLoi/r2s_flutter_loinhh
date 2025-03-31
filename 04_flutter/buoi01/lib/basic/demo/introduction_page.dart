
import 'package:flutter/material.dart';

void main() {
  runApp(IntroductionPage());
}
class IntroductionPage extends StatelessWidget{
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _buildHomePage(),);
  }

  Widget _buildHomePage(){
    return Scaffold(
      appBar:  AppBar(title: const Text('Introdution Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text(
            'Hello',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            overflow: TextOverflow.visible,
          ),
            Builder(
                builder: (context) {
                 return ElevatedButton(
                      onPressed: (){
                        //Handel button press
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Button Pressed')),
                        );
                      },
                     child: Text('Login'),
                 );
                },
            ),
          Container(
              color: Colors.yellow,
              width: 200,
              height: 200,
            child: Text('Hello Word'),
          ),
          ],
        ),
      ),
    );
  }
}