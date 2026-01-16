import 'package:flutter/material.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player Module")),
      body: const Center(child: Text("Nội dung màn hình Player")),
    );
  }
}