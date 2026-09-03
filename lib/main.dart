import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/app_models.dart';
import 'screens/dashboard_screen.dart';
import 'screens/spaced_repetition_screen.dart';
import 'screens/homework_list_screen.dart';
import 'screens/curriculum_screen.dart';
import 'screens/focus_timer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const DijitalDersAjandamApp());
}

class DijitalDersAjandamApp extends StatelessWidget {
  const DijitalDersAjandamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dijital Ders Ajandam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeColors.primary,
          primary: ThemeColors.primary,
          secondary: ThemeColors.secondary,
          surface: ThemeColors.surface,
        ),
        scaffoldBackgroundColor: ThemeColors.surface,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(onNavigateTab: (idx) {
        setState(() => _currentIndex = idx);
      }),
      const SpacedRepetitionScreen(),
      const HomeworkListScreen(),
      const FocusTimerScreen(),
      const CurriculumScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
        },
        backgroundColor: ThemeColors.surface,
        indicatorColor: ThemeColors.primary.withOpacity(0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome, color: ThemeColors.primary),
            label: 'Bugün',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_alt_outlined),
            selectedIcon: Icon(Icons.psychology_alt, color: ThemeColors.primary),
            label: 'Tekrarlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt, color: ThemeColors.primary),
            label: 'Ödevler',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: ThemeColors.primary),
            label: 'Odak',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune, color: ThemeColors.primary),
            label: 'Yönetim',
          ),
        ],
      ),
    );
  }
}
