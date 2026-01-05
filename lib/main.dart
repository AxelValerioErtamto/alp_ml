import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:alp_ml/viewmodel/calculator_viewmodel.dart';
import 'package:alp_ml/view/calculator_view.dart';
import 'package:alp_ml/view/history_view.dart';
import 'package:alp_ml/view/tips_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

// --- GO ROUTER CONFIGURATION ---
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      // This builder wraps all child routes with the DashboardShell (Bottom Nav)
      builder: (context, state, child) {
        return DashboardShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => CalculatorScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => HistoryView(),
        ),
        GoRoute(
          path: '/tips',
          builder: (context, state) => TipsView(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Obesity Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFEF8354)),
        useMaterial3: true,
      ),
    );
  }
}

// --- DASHBOARD SHELL (BOTTOM NAV) ---
class DashboardShell extends StatelessWidget {
  final Widget child;
  const DashboardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    // We calculate the current index based on the route location
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location == '/history') currentIndex = 1;
    if (location == '/tips') currentIndex = 2;

    return Scaffold(
      body: child, // The screen content goes here
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/history');
                break;
              case 2:
                context.go('/tips');
                break;
            }
          },
          backgroundColor: Colors.white,
          indicatorColor: Color(0xFFEF8354).withOpacity(0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.calculate_outlined),
              selectedIcon: Icon(Icons.calculate, color: Color(0xFFEF8354)),
              label: 'Calculator',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history, color: Color(0xFFEF8354)),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb_outline),
              selectedIcon: Icon(Icons.lightbulb, color: Color(0xFFEF8354)),
              label: 'Tips',
            ),
          ],
        ),
      ),
    );
  }
}