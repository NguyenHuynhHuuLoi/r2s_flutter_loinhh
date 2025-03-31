
import 'package:flutter/material.dart';

void main() {
  runApp(PavlovaRecipe());
}
class PavlovaRecipe extends StatelessWidget{
  const PavlovaRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: buildHomePage(),);
  }

  Widget buildHomePage(){
    const titleText = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        'Strawberry Pavlova',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: 25,
        ),
      ),
    );

    const subTitle = Text(
      'Pavlova is a meringue-based dessert named after the Russian ballerina '
      'Anna Pavlova. Pavlova features a crisp crust and soft, light inside, '
      'topped with fruit and whipped cream.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 20,
      ),
    );

    //#docregion ratings, stars

    var stars = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star,color: Colors.green[500]),
        Icon(Icons.star,color: Colors.green[500]),
        Icon(Icons.star,color: Colors.green[500]),
        const Icon(Icons.star, color: Colors.black),
        const Icon(Icons.star, color: Colors.black),
      ],
    );

    //#enddocregion stars

    var ratings = Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          stars,
          const Text(
            '170 Reviews',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );

    //#docregion iconList
    const descTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 18,
      height: 2,
    );

    final iconList = DefaultTextStyle.merge(
        style: descTextStyle,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.kitchen,color: Colors.green[500]),
                  const Text('PREP:'),
                  const Text('25 min'),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.timer,color:Colors.green[500]),
                  const Text('COOK:'),
                  const Text('1 hr'),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.restaurant,color:Colors.green[500]),
                  const Text('FEEDS:'),
                  const Text('4-6'),
                ],
              ),
            ],
          ),
        ),
    );

    final mainImage = Image.asset(
      'images/cake.png',
    );

    // #docregion mainColumn
    final mainColumn = Container(
    padding: const EdgeInsets.all(20),
    child: Column(
    children: [
    titleText,
    subTitle,
    ratings,
    iconList,
     //mainImage,
     Expanded(child: mainImage),
    ],
    ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pavlova Recipe'),
      ),
       body: mainColumn,
    );
  }
}