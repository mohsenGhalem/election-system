import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String? message;
  const ErrorWidget({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.error,
            size: 100,
            color: Colors.red,
          ),
          Text(
            message ?? 'An error occured !',
            style: const TextStyle(fontSize: 20, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
