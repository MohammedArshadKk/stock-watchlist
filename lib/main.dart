import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock/services/database_services.dart';

import 'views/widgets/bottom_navigation.dart';

final DatabaseServices databaseServices = DatabaseServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await databaseServices.initDatabase();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[600]!),
          useMaterial3: true,
          iconTheme: IconThemeData(color: Colors.blue[600]),
          appBarTheme: AppBarTheme(
              color: Colors.blue[600],
              toolbarHeight: 80,
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold))),
      home: BottomNavigation(),
    );
  }
}
