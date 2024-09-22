import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'second_page.dart';
import 'routine_page.dart';
import 'radio_button_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color.fromARGB(255, 200, 128, 20),
        ),
        useMaterial3: true,
      ),
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final List<Map<String, dynamic>> questionsPage1 = [
    {
      'question': '1. What are your fitness goals?',
      'options': ['Weight loss 🏃‍♀️', 'Muscle gain 💪', 'Endurance 🏋️‍♂️', 'Flexibility 🧘‍♀️']
    },
    {
      'question': '2. Where are you working out today?',
      'options': ['Home 🏡', 'Gym 🏋️', 'Outside (Park) 🌳']
    },
    {
      'question': '3. Preferred workout time?',
      'options': ['Morning ☀️', 'Afternoon 🌤️', 'Evening 🌙']
    },
  ];

  List<String?> _selectedOptionsPage1 = List<String?>.filled(3, null);

  @override
  Widget build(BuildContext context) {
    bool isPage1Completed = _selectedOptionsPage1.every((option) => option != null);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('logo-black.png'),
              fit: BoxFit.contain,
              height: 32,  // Adjust the height of the image if needed
            ),
            const SizedBox(width: 8),  // Add some space between the image and the title
            const Text('Personal TrAIner - Page 1/2'),
          ],
        ),
        centerTitle: true,  // Center the title and image horizontally
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questionsPage1.length,
                  itemBuilder: (context, index) {
                    final questionData = questionsPage1[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: RadioButtonWidget(
                        question: questionData['question'],
                        options: questionData['options'],
                        selectedOption: _selectedOptionsPage1[index],
                        onChanged: (value) {
                          setState(() {
                            _selectedOptionsPage1[index] = value;
                          });
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: isPage1Completed
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecondPage(
                                  answersPage1: _selectedOptionsPage1,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
