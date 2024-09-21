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
      'question': '1. Which workout do you prefer?',
      'options': ['Cardio', 'Strength Training', 'Flexibility']
    },
    {
      'question': '2. How often do you exercise per week?',
      'options': ['1-2 times', '3-4 times', '5-6 times']
    },
    {
      'question': '3. Preferred workout time?',
      'options': ['Morning', 'Afternoon', 'Evening']
    },
  ];

  // List to store the selected options for each question
  List<String?> _selectedOptions = List<String?>.filled(3, null);

  @override
  Widget build(BuildContext context) {
    bool isAllAnswered = _selectedOptions.every((option) => option != null);
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('logo-black.png'),
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
               padding: const EdgeInsets.all(8.0),
                child: Text(widget.title)
              )
            ],
        ),
      ),
      // Center the content
      body: Center(
        // Make the content scrollable
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,  // Center the content horizontally
              children: [
                // Displaying the questions with radio buttons
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,  
                  child: ElevatedButton(
                  onPressed: isAllAnswered
                  ? () {
                    // Handle form submission or display selected values
                    for (int i = 0; i < questions.length; i++) {
                      print('Question: ${questions[i]['question']}');
                      print('Selected Option: ${_selectedOptions[i]}');
                    }
                  }
                  : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),  // Make the button taller
                  ),
                  child: const Text('Submit'),
                  ),
                )
              ],
            ),
          ),
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
    return Card(
      elevation: 4.0,  // Add some elevation to give the card a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),  // Rounded edges for the card
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),  // Set margin for spacing
      child: Padding(
        padding: const EdgeInsets.all(16.0),  // Add padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  // Center the content
          children: <Widget>[
            Text(
              question,
              textAlign: TextAlign.center,  // Center the question text
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            // Center and generate radio buttons for the given options, each inside a narrow card
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,  // Center the options horizontally
              children: options.map((option) {
                return Card(
                  color: Colors.white,  // Set background color for the card
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Narrow card for each option
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2.0,  // Add some elevation for the option cards
                  child: ListTile(
                    title: Center(
                      child: Text(
                        option,
                        style: const TextStyle(color: Colors.black),  // Set option text color to white
                      ),
                    ),
                    leading: Radio<String>(
                      value: option,
                      groupValue: selectedOption,
                      onChanged: onChanged,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
