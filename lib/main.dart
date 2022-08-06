import 'dart:math';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:foodist/recipes.dart';
import 'package:page_transition/page_transition.dart';

// For database
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// My other files
import 'database.dart';
import 'design.dart';
import 'startup_anim.dart';

late final Database recipeDb;
const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

void main() async {
  await initDB();
  //recipeDb.delete("recipes");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  bool firstRun = true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor swatch = createMaterialColor(const Color(0xFFAA0000));
    return MaterialApp(
      title: 'Foodist',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: swatch,
      ),
      home: AnimatedSplashScreen(
        duration: 1000,
        splash: const StartAnimation(),
        nextScreen: const MyHomePage(
          title: 'Foodist',
        ),
        splashIconSize: 1000,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late List<Widget> widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateWidgetOptions(BuildContext context) {
    widgetOptions = <Widget>[
      /// Tab 1
      buildScreen1(context),

      /// Tab 2
      buildScreen2(context),

      /// Tab 3
      buildScreen3(context),
    ];
  }

  @override
  Widget build(BuildContext context) {
    updateWidgetOptions(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ramen_dining),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Meal Plan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildScreen1(context) {
    return const Text(
      'What do I eat',
      style: optionStyle,
    );
  }

  buildScreen2(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(flex: 9, child: buildRecipeList()),
        Expanded(
          flex: 1,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddRecipeScreen(),
                  ),
                ).then((value) => value != null && value
                    ? setState(() => updateWidgetOptions(context))
                    : null);
              },
              child: const Text("Add Recipe")),
        ),
      ],
    );
  }

  buildScreen3(BuildContext context) {
    return const Text(
      'Meal Plan',
      style: optionStyle,
    );
  }

  buildRecipeList() {
    return FutureBuilder<List>(
        future: getRecipes(),
        initialData: const [],
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (_, int position) {
                    final item = snapshot.data![position];
                    //get your item data here ...
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeView(recipe: item),
                            ),
                          ).then((value) => value != null && value
                              ? setState(() => updateWidgetOptions(context))
                              : null);
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}
