import 'dart:math' as math;
import 'package:flutter/material.dart';

const defaultBarColors = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange,
];

class BarChart extends StatefulWidget {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final List<String> graphNames;

  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;

  const BarChart({
    Key? key,
    required this.ticks,
    required this.features,
    required this.data,
    required this.graphNames,
    this.reverseAxis = false,
    this.ticksTextStyle = const TextStyle(color: Colors.grey, fontSize: 12),
    this.featuresTextStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.outlineColor = Colors.black,
    this.axisColor = Colors.grey,
    this.graphColors = defaultBarColors,
  }) : super(key: key);

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with SingleTickerProviderStateMixin {
  double fraction = 0;
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    ))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });

    animationController.forward();
  }

  @override
  void didUpdateWidget(BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 400), // Fixed size for the bar chart
      painter: BarChartPainter(
        widget.ticks,
        widget.features,
        widget.data,
        widget.graphNames,
        widget.reverseAxis,
        widget.ticksTextStyle,
        widget.featuresTextStyle,
        widget.outlineColor,
        widget.axisColor,
        widget.graphColors,
        this.fraction,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class BarChartPainter extends CustomPainter {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final List<String>? graphNames;

  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final double fraction;

  BarChartPainter(
    this.ticks,
    this.features,
    this.data,
    this.graphNames,
    this.reverseAxis,
    this.ticksTextStyle,
    this.featuresTextStyle,
    this.outlineColor,
    this.axisColor,
    this.graphColors,
    this.fraction,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final axisHeight = size.height - 40;
    final axisWidth = size.width - 40;
    final barWidth = axisWidth / features.length * 0.8;
    final barPadding = axisWidth / features.length * 0.2;
    final scale = axisHeight / ticks.last;

    var axisPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    // Draw the horizontal axis
    canvas.drawLine(Offset(20, axisHeight), Offset(axisWidth + 20, axisHeight), axisPaint);

    // Draw the ticks
    var ticksPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    ticks.asMap().forEach((index, tick) {
      final tickPosition = axisHeight - (scale * tick);
      canvas.drawLine(
        Offset(20, tickPosition),
        Offset(axisWidth + 20, tickPosition),
        ticksPaint,
      );

      TextPainter(
        text: TextSpan(text: tick.toString(), style: ticksTextStyle),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(canvas, Offset(10, tickPosition - ticksTextStyle.fontSize! / 2));
    });

    // Draw the bars
    var barPaint = Paint()..style = PaintingStyle.fill;

    features.asMap().forEach((index, feature) {
      var barHeight = scale * data[0][index] * fraction;
      var xOffset = 20 + barWidth * index + barPadding * index;
      var yOffset = axisHeight - barHeight;

      barPaint.color = graphColors[index % graphColors.length];

      canvas.drawRect(
        Rect.fromLTWH(xOffset, yOffset, barWidth, barHeight),
        barPaint,
      );

      final featureText = TextSpan(text: feature, style: featuresTextStyle);
      final textPainter = TextPainter(
        text: featureText,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);

      canvas.save();
      canvas.translate(xOffset + barWidth / 6, axisHeight + 80); 
      canvas.rotate(-math.pi / 2); 
      textPainter.paint(canvas, Offset(0, 0));
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
