import 'package:flutter/material.dart';

class PlayingIndicator extends StatefulWidget {
  final bool isPlaying;
  const PlayingIndicator({Key? key, required this.isPlaying}) : super(key: key);

  @override
  State<PlayingIndicator> createState() => _PlayingIndicatorState();
}

class _PlayingIndicatorState extends State<PlayingIndicator> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying) {
      _controller.stop(); 
      // Khi pause thì hiện icon tĩnh
      return const Icon(Icons.bar_chart_rounded, color: Color(0xFF1ED760), size: 24);
    } else {
      _controller.repeat(reverse: true);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Tạo độ lệch pha cho các thanh để nó nhảy không đều nhau
            double height = 4 + 10 * (index % 2 == 0 
                ? _controller.value 
                : 1 - _controller.value); 
            return Container(
              width: 3,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: const Color(0xFF1ED760), // Màu xanh Spotify
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}