import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal TrAIner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color.fromARGB(255, 200, 128, 20),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(title: 'Personal TrAIner'),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const apiKey = String.fromEnvironment('API_KEY');

  // Define the list of questions and their corresponding options
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which workout do you prefer?',
      'options': ['Cardio', 'Strength Training', 'Flexibility']
    },
    {
      'question': 'How often do you exercise per week?',
      'options': ['1-2 times', '3-4 times', '5-6 times']
    },
    {
      'question': 'Preferred workout time?',
      'options': ['Morning', 'Afternoon', 'Evening']
    },
  ];

  // List to store the selected options for each question
  List<String?> _selectedOptions = List<String?>.filled(3, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final questionData = questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: RadioButtonWidget(
                      question: questionData['question'],
                      options: questionData['options'],
                      selectedOption: _selectedOptions[index],
                      onChanged: (value) {
                        setState(() {
                          _selectedOptions[index] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle form submission or display selected values
                for (int i = 0; i < questions.length; i++) {
                  print('Question: ${questions[i]['question']}');
                  print('Selected Option: ${_selectedOptions[i]}');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioButtonWidget extends StatelessWidget {
  const RadioButtonWidget({
    Key? key,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  }) : super(key: key);

  final String question;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          question,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        // Dynamically generate radio buttons for the given options
        ...options.map((option) {
          return ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: selectedOption,
              onChanged: onChanged,
            ),
          );
        }).toList(),
      ],
    );
  }
}
