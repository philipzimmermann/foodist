import 'package:flutter/cupertino.dart';
import 'package:foodist/recipes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';

Future<void> insertRecipe(Recipe recipe) async {
  if ((await recipeDb
          .query('recipes', where: 'name=?', whereArgs: [recipe.name]))
      .isEmpty) {
    await recipeDb.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<void> deleteRecipe(Recipe recipe) async {
  if ((await recipeDb
          .query('recipes', where: 'name=?', whereArgs: [recipe.name]))
      .isNotEmpty) {
    await recipeDb.delete('recipes', where: 'name=?', whereArgs: [recipe.name]);
  }
}

Future<Database> initDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'recipe_database.db'),
    // When the database is first created, create a table to store recipes.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE recipes(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL UNIQUE, ingredients TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  recipeDb = await database;

  var pasta = const Recipe(
    name: 'pasta',
    ingredients: "spaghetti,tomato",
  );
  await insertRecipe(pasta);
  return database;
}

Future<List<Recipe>> getRecipes() async {
  // Query the table for all the recipes.
  final List<Map<String, dynamic>> maps = await recipeDb.query('recipes');

  // Convert the List<Map<String, dynamic> into a List<Recipe>.
  return List.generate(maps.length, (i) {
    return Recipe(
      name: maps[i]['name'],
      ingredients: maps[i]['ingredients'],
    );
  });
}
