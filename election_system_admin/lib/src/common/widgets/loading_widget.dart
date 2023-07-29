import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool? enableText;
  const LoadingWidget({this.enableText, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          if (enableText == true)
            const Text(
              'loading...',
              style: TextStyle(color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
