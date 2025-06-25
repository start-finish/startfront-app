import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/editor.controller.dart';

class EditorScreen extends GetView<EditorController> {
  const EditorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditorScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditorScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
