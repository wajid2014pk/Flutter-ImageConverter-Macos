import 'package:flutter/material.dart';

class TextToolPreviewPage extends StatefulWidget {
  String text;
  String imagePath;
  TextToolPreviewPage({super.key, required this.text, required this.imagePath});

  @override
  State<TextToolPreviewPage> createState() => _TextToolPreviewPageState();
}

class _TextToolPreviewPageState extends State<TextToolPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.text),
          Text(widget.imagePath),
        ],
      ),
    );
  }
}
