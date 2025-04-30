import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_pal/screens/home_screen.dart';
import 'package:mood_pal/screens/zoo_screen.dart';
import 'package:mood_pal/screens/history_screen.dart';
import 'package:mood_pal/screens/settings_screen.dart';
import 'package:mood_pal/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:mood_pal/providers/mood_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoodProvider()),
      ],
      child: MaterialApp(
        title: 'MoodPal',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ZooScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Mood Zoo',
    'History',
    'Settings',
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.pets_rounded,
    Icons.history_rounded,
    Icons.settings_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: List.generate(_titles.length, (index) {
              return BottomNavigationBarItem(
                icon: _buildNavIcon(index),
                label: _titles[index],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(int index) {
    final bool isSelected = index == _selectedIndex;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _icons[index],
        size: isSelected ? 28 : 24,
      ),
    );
  }
}