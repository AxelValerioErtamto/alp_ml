import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Note: Make sure these imports point to your actual file locations!
import 'package:alp_ml/viewmodel/calculator_viewmodel.dart';
import 'package:alp_ml/view/calculator_view.dart'; 

void main() {
  runApp(
    // We wrap the entire app in MultiProvider.
    // This makes the ViewModel available to every screen in the app.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the "Debug" banner
      title: 'Obesity Calculator',
      theme: ThemeData(
        // I used a Teal theme here to match the clean health look
        // You can change 'seedColor' to whatever you like.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // This tells the app: "Start at the Calculator Screen!"
      home: CalculatorScreen(),
    );
  }
}