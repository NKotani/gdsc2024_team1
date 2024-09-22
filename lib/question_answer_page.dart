import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class QuestionAnswerPage extends StatefulWidget {
  final String routine;
  final String initialQuestion;

  const QuestionAnswerPage({super.key, required this.routine, required this.initialQuestion});

  @override
  _QuestionAnswerPageState createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
  static const apiKey = String.fromEnvironment('API_KEY');
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final TextEditingController _questionController = TextEditingController();
  List<Map<String, String>> _chatHistory = [];  // Store conversation as list of maps
  bool _isLoading = false;  // Loading indicator

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
    _askGemini(widget.routine, widget.initialQuestion);  // Ask Gemini the initial question
  }

  Future<void> _askGemini(String routine, String question) async {
    setState(() {
      _isLoading = true;  // Show loading spinner
      // Add the user's question to the chat history
      _chatHistory.add({'role': 'user', 'text': question});
    });

    // Send the user's question along with the routine to Gemini
    final response = await _chat.sendMessage(
      Content.text('Based on this routine: $routine, $question'),
    );

    setState(() {
      // Add Gemini's response to the chat history
      _chatHistory.add({'role': 'bot', 'text': response.text ?? 'Sorry, I couldn’t generate a response.'});
      _isLoading = false;  // Hide loading spinner
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: Text('Chat with your Personal trAIner')
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final chatItem = _chatHistory[index];
                return Align(
                  alignment: chatItem['role'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: chatItem['role'] == 'user' ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MarkdownBody(data: chatItem['text']!),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Type your question...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (_questionController.text.isNotEmpty) {
                      _askGemini(widget.routine, _questionController.text);
                      _questionController.clear();  // Clear the input after submission
                    }
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
