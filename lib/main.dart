import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/income_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IncomeProvider(),
      child: MaterialApp(
        title: '워킹 머니 트래커',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'NotoSansKR',
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}