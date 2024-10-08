import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'question_answer_page.dart';  // Import the QuestionAnswerPage

class RoutinePage extends StatelessWidget {
  final String routine;

  const RoutinePage({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    TextEditingController _questionController = TextEditingController();

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
              child: Text('Your Routine')
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: MarkdownBody(data: routine),
              ),
            ),
            const SizedBox(height: 20),
            // Row for the TextField and Send IconButton
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ask a question about the routine...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),  // Icon for the send button
                  color: Colors.grey[600],
                  onPressed: () {
                    if (_questionController.text.isNotEmpty) {
                      // Navigate to the QuestionAnswerPage with the user's question
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionAnswerPage(
                            routine: routine,
                            initialQuestion: _questionController.text,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
