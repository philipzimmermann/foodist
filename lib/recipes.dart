import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodist/main.dart';

import 'database.dart';

class Recipe {
  final String name;
  final String ingredients;

  const Recipe({
    required this.name,
    required this.ingredients,
  });

  // Convert a Recipe into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients,
    };
  }

  // Implement toString to make it easier to see information about
  // each recipe when using the print statement.
  @override
  String toString() {
    return 'Recipe{name: $name, ingredients: $ingredients}';
  }
}

class RecipeView extends StatelessWidget {
  const RecipeView({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(recipe.ingredients),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /// delete item from database
          deleteRecipe(recipe);
          Navigator.pop(context, true);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete),
      ),
    );
  }
}

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Recipe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          TextFormField(
            controller: myController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter recipe name',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Recipe newRecipe =
                    Recipe(name: myController.text, ingredients: "tomato");
                insertRecipe(newRecipe);
                Navigator.pop(context, true);
              },
              child: const Text("Add Recipe")),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
