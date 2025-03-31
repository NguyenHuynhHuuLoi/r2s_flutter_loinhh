import 'package:flutter/cupertino.dart';




class ProductWidget extends StatelessWidget {
   const ProductWidget(
   {super.key,
   required this.imagePath,
   required this.name,
   required this.description,
   required this.price});

   final String imagePath;
   final String name;
   final String description;
   final num price;

   @override
   Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
    child: Row(
      children: [
       SizedBox(
         width: 100,
         height: 100,
         child: Image.asset(imagePath),
   ),
        Column(
          children: [
            Text(name),
            Text(description),
            Text('$price'),
          ],
        )
      ],
    ),
    );
   }
}