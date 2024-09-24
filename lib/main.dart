import 'package:currency_converter/core/routes.dart';
import 'package:currency_converter/feature/currency_conversion/viewmodels/convertion_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ConversionViewModel(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advance Exchanger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 33, 243, 75),brightness: Brightness.dark),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routes: routes,
    );
  }
}



