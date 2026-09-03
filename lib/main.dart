import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_models.dart';
import 'providers/homework_provider.dart';
import 'providers/exam_provider.dart';
import 'providers/subject_provider.dart';
import 'providers/study_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/homework_list_screen.dart';
import 'screens/exam_entry_screen.dart';
import 'screens/curriculum_screen.dart';
import 'screens/focus_timer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DijitalDersAjandamApp());
}

class DijitalDersAjandamApp extends StatelessWidget {
  const DijitalDersAjandamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeworkProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => ExamProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => StudyProvider()..loadAll()),
      ],
      child: MaterialApp(
        title: 'Dijital Ders Ajandam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AppColors.primary,
          scaffoldBackgroundColor: AppColors.surface,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
        home: const MainNavigationShell(),
      ),
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

  final List<Widget> _pages = const [
    DashboardScreen(),
    HomeworkListScreen(),
    ExamEntryScreen(),
    CurriculumScreen(),
    FocusTimerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Bugün'),
          NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment),
              label: 'Ödevler'),
          NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Sınavlar'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Dersler'),
          NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer),
              label: 'Odak'),
        ],
      ),
    );
  }
}
