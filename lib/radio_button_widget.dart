import 'package:flutter/material.dart';

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
              style: const TextStyle(
                fontSize: 18.0,  // You can adjust this size as needed
              ),
            ),
            const SizedBox(height: 10),
            // Generate radio buttons for the given options
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: options.map((option) {
                return Card(
                  color: Colors.white,  // Set the background color to white
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),  // Rounded edges for each option
                  ),
                  elevation: 2.0,  // Add some elevation for the option cards
                  child: ListTile(
                    title: Center(
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 15.0,  // Increase font size slightly to show emojis fully
                          color: Colors.black,  // Set text color to black
                        ),
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
