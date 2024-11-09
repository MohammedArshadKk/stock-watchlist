import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock/riverpod/bottom_navigation_riverpod.dart';
import 'package:stock/views/screens/home.dart';
import 'package:stock/views/screens/watchlist.dart';

class BottomNavigation extends ConsumerWidget {
  BottomNavigation({super.key});

  final List<Widget> widgetOptions = [Home(), Watchlist()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      body: widgetOptions[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined),
            label: 'Watchlist',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blue[600],
        onTap: (value) {
          ref.watch(bottomNavIndexProvider.notifier).state = value;
        },
      ),
    );
  }
}
