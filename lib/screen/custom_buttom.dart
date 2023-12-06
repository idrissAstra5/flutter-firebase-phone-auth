import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const CustomButtom({super.key,
    required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
        ),
        child: Text(text, style: TextStyle(fontSize: 16),)
    );
  }
}
