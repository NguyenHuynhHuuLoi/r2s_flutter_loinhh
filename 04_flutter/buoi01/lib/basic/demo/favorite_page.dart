
import 'package:flutter/material.dart';

void main() {
  runApp(FavoritePage());
}
class FavoritePage extends StatelessWidget{
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _buildHomePage(),);
  }

  Widget _buildHomePage(){
    return Scaffold(
      appBar:  AppBar(title: const Text('Thế giới Ninja')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/imgsd.png"),
            Row(
              children: [
                Text('Naruto Shippudent'),
                const Icon(Icons.star, color: Colors.red),
                const Text('41'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on),
                Icon(Icons.import_contacts),
                Icon(Icons.access_alarm),
              ],
            ),
            Text(
                'Chào mừng bạn đến với làng ninja'
            ),
          ],
        ),
      ),
    );
  }
}