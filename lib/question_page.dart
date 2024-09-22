import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  static const apiKey = String.fromEnvironment('API_KEY');
  late final GenerativeModel _model;
  late final ChatSession _chat;
  TextEditingController _questionController = TextEditingController();
  String? _geminiAnswer;
  bool _isLoading = false;  // Loading indicator

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
  }

  Future<void> _askGemini(String question) async {
    setState(() {
      _isLoading = true;  // Show loading spinner
    });

    final response = await _chat.sendMessage(
      Content.text(question),
    );
    
    setState(() {
      _geminiAnswer = response.text ?? 'Sorry, I couldn’t generate a response.';
      _isLoading = false;  // Hide loading spinner
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ask your question here',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_questionController.text.isNotEmpty) {
                  _askGemini(_questionController.text);
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            // Display loading spinner while fetching the response
            if (_isLoading)
              const CircularProgressIndicator(),
            if (_geminiAnswer != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _geminiAnswer!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
