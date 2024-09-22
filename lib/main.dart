import 'package:flutter/material.dart';
import 'first_page.dart';  // Import the FirstPage for the first question page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State variable to keep track of the theme mode (light or dark)
  ThemeMode _themeMode = ThemeMode.light;

  // Function to toggle between light and dark mode
  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTAI',
      theme: ThemeData(  // Light theme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 200, 128, 20),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(  // Dark theme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF212121),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,  // Set background color for dark mode
      ),
      themeMode: _themeMode,  // Use the theme mode from state
      home: MainPage(onToggleTheme: _toggleTheme),  // Pass the toggle function
    );
  }
}

class MainPage extends StatefulWidget {
  final Function(bool) onToggleTheme;
  const MainPage({super.key, required this.onToggleTheme});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDarkMode = false;  // State variable for the toggle switch

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Define a bounce animation for the arrow
    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Personal TrAIner'),
            // Toggle switch to switch between light and dark mode
            Row(
              children: [
                const Icon(Icons.wb_sunny),  // Sun icon for light mode
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    widget.onToggleTheme(value);  // Call the function to toggle theme
                  },
                ),
                const Icon(Icons.nights_stay),  // Moon icon for dark mode
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo above the app name
                const Image(
                  image: AssetImage('logo-black.png'),  // Logo image
                  height: 80,  // Adjust logo size
                ),
                const SizedBox(height: 20),
                const Text(
                  'PTAI',  // App name
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Your AI-powered personal fitness trainer. Start your fitness journey today and achieve your goals with customized plans.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Start Your Journey'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FirstPage(),  // Navigate directly to FirstPage
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: _animation.value),
                      // child: const Icon(
                      //   Icons.arrow_right_alt,
                      //   color: Color.fromARGB(255, 120, 120, 120),
                      //   size: 32,
                      // ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
