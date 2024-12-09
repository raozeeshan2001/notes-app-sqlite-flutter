import 'package:flutter/material.dart';
import 'package:notes_app_sqlite/data/local/db_helper.dart';
import 'package:notes_app_sqlite/db_provider.dart';
import 'package:notes_app_sqlite/home_Screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DbProvider(dbHelper: DbHelper.getinstance),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
