import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'routine_page.dart';
import 'radio_button_widget.dart';
import 'dart:ui';

class SecondPage extends StatefulWidget {
  final List<String?> answersPage1;

  const SecondPage({super.key, required this.answersPage1});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  static const apiKey = String.fromEnvironment('API_KEY');
  late final GenerativeModel _model;
  late final ChatSession _chat;

  final List<Map<String, dynamic>> questionsPage2 = [
    {
      'question': '4. How much time do you have to exercise? ⏱️',
      'options': ['30 min', '1 hr', '1 hr 30 min', '2 hr']
    },
    {
      'question':'5.Which part of your body do you want to train?',
      'options': ['Upper Body (Chest, Back, Arms) 💪','Lower Body (Legs, Glutes) 🦵', 'Core (Abs, Obliques) 🤸', 'Full Body 🏋️‍♂️']
    },
    {
      'question': '6. How intense do you want the workout to be?',
      'options': ['Light 🌿', 'Moderate 😊👍', 'Intense 🔥']
    },
  ];

  List<String?> _selectedOptionsPage2 = List<String?>.filled(3, null);
  bool _isLoading = false;  // Track loading state

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
  }

  Future<void> _submitAnswers(BuildContext context) async {
    setState(() {
      _isLoading = true;  // Show the loading indicator
    });

    // Combine answers from both pages
    String userInput = [
      ...widget.answersPage1.whereType<String>(),
      ..._selectedOptionsPage2.whereType<String>()
    ].join(", ");

    // Simulate API call (you can replace this with real API call)
    final response = await _chat.sendMessage(
      Content.text(
        "Based on my answers: " +
        "$userInput, " +
        "If user's input is flexibility, it means yoga or any relaxing exercise" +
        "no need to put date like monday or tuesday etc" +
        "Don't put day 1" +
        "can you recommend a detailed one day fitness routine?"
      ),   
    );
    final routine = response.text ?? 'Error: No routine generated.';

    setState(() {
      _isLoading = false;  // Hide the loading indicator
    });

    // Navigate to the routine display page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutinePage(routine: routine),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPage2Completed = _selectedOptionsPage2.every((option) => option != null);

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
            const Text('Personal TrAIner - Page 2/2'),
          ],
        ),
        centerTitle: true,  // Center the title and image horizontally
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: questionsPage2.length,
                      itemBuilder: (context, index) {
                        final questionData = questionsPage2[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: RadioButtonWidget(
                            question: questionData['question'],
                            options: questionData['options'],
                            selectedOption: _selectedOptionsPage2[index],
                            onChanged: (value) {
                              setState(() {
                                _selectedOptionsPage2[index] = value;
                              });
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: isPage2Completed
                            ? () => _submitAnswers(context)  // Submit all answers
                            : null,  // Disable button if not all options are selected
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),  // Slightly darkened background
              ),
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),  // Loading spinner
            ),
        ],
      ),
    );
  }
}
