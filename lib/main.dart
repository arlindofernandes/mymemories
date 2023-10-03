import 'package:flutter/material.dart';

import 'package:mymemories/providers/memorie_provider.dart';

import 'package:provider/provider.dart';

import './screens/map_screen.dart';
import './screens/home_screen.dart';
import './screens/memories_management_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemorieProvider(),
      child: MaterialApp(
        title: 'My Memories',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        routes: {
          MemoriesManagementScreen.route: (_) => const MemoriesManagementScreen(),
          MapScreen.route: (_) => const MapScreen(),
        },
      ),
    );
  }
}
