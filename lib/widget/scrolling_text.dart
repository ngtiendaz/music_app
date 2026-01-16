import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ScrollingText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double width; // Chiều rộng tối đa cho phép (thường lấy từ context cha)

  const ScrollingText({
    Key? key,
    required this.text,
    required this.style,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. Tính toán chiều rộng của văn bản
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        // 2. So sánh: Nếu văn bản dài hơn khung chứa (constraints.maxWidth)
        if (textPainter.size.width > constraints.maxWidth) {
          return Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 30.0,
            velocity: 30.0,
            pauseAfterRound: const Duration(seconds: 2),
            startPadding: 0.0,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          );
        } else {
          // 3. Nếu ngắn hơn: Hiển thị Text tĩnh bình thường
          return Text(
            text,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}