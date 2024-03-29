import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:sun_be_gone/utils/result_animation_util.dart';
import 'package:sun_business/sun_business.dart'
    show SittingInfo, SittingPosition;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnimatedCurvedProgressBar extends StatefulWidget {
  final SittingInfo sittingInfo;

  const AnimatedCurvedProgressBar({super.key, required this.sittingInfo});
  @override
  _AnimatedCurvedProgressBarState createState() =>
      _AnimatedCurvedProgressBarState();
}

class _AnimatedCurvedProgressBarState extends State<AnimatedCurvedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Adjust the duration as needed
    );

    _animationController.forward(); // Start the first animation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => StaggeredAnimation(
                controller: _animationController,
                sittingInfo: widget.sittingInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class StaggeredAnimation extends StatelessWidget {
  final AnimationController controller;

  final Animation<double> firstPhaseAnimation;
  final Animation<double> secondPhaseAnimation;
  final Animation<double> thirdPhaseAnimation;
  final SittingInfo sittingInfo;
  late final String _sittingPosition;

  StaggeredAnimation(
      {super.key, required this.controller, required this.sittingInfo})
      : firstPhaseAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.4,
              curve: Curves.ease,
            ),
          ),
        ),
        secondPhaseAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.4,
              0.8,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        thirdPhaseAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.8,
              1.0,
              curve: Curves.easeInOutQuart,
            ),
          ),
        )
  /*
        _sittingPosition = switch (sittingInfo.position) {
          SittingPosition.left => 'Left',
          SittingPosition.right => 'Right',
          SittingPosition.both => ' both',
          () => 'both'
        };
        */
  ;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    _sittingPosition = switch (sittingInfo.position) {
      SittingPosition.left => locale.sittingLeft,
      SittingPosition.right => locale.sittingRight,
      SittingPosition.both => locale.sittingBoth,
      () => locale.sittingBoth
    };
    final String sittingWith = locale.sittingWith;
    final String sittingProtection = locale.sittingProtection;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return controller.value < 0.4
            ? Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200), // Adjust the size as needed
                    painter: CurvedProgressBarPainter(
                      progress: firstPhaseAnimation.value,
                      segmentLengths: sittingInfo.segments!,
                    ),
                  ),
                  Text(
                    '${(firstPhaseAnimation.value * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200), // Adjust the size as needed
                    painter: CurvedProgressBarPainter(
                      progress: 1,
                      segmentLengths: sittingInfo.segments!,
                    ),
                  ),
                  ClipOval(
                    child: Container(
                      width: 230,
                      height: 230,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0,
                                40 - (40 * thirdPhaseAnimation.value),
                                0,
                                40 - (40 * thirdPhaseAnimation.value)),
                            child: Text(
                              _sittingPosition,
                              style: TextStyle(
                                fontSize: 40 * secondPhaseAnimation.value,
                                color: ResultAnimationUtil.determinColor(
                                    sittingInfo.position),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                5, 5, 5, (30 * thirdPhaseAnimation.value)),
                            child: Text(
                              '$sittingWith ${sittingInfo.protectionPercentage}% $sittingProtection!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: thirdPhaseAnimation.value * 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class CurvedProgressBarPainter extends CustomPainter {
  final List<(double, SittingPosition)> segmentLengths;
  final double progress;

  CurvedProgressBarPainter({
    required this.segmentLengths,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const startAngle = pi * (2 / 3); // Start from the bottom
    final sweepAngle = pi * (5 / 3) * progress;
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: 120);

    double currentSegmentStartAngle = startAngle;
    if(segmentLengths.length == 1){
        final paint = Paint()
            ..style = PaintingStyle.stroke
            ..color = ResultAnimationUtil.determinColor(segmentLengths[0].$2)
            ..strokeWidth = 10;
        canvas.drawArc(
            rect,
            currentSegmentStartAngle,
            sweepAngle,
            false,
            paint,
        );
        return;
    }
    for (int i = 1; i < segmentLengths.length; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = ResultAnimationUtil.determinColor(segmentLengths[i].$2)
        ..strokeWidth = 10;
      // Skip the first angle
      final currentSegmentSweepAngle =
          (pi * 2) * (segmentLengths[i].$1 - segmentLengths[i - 1].$1);
      if (sweepAngle >=
          currentSegmentSweepAngle + currentSegmentStartAngle - startAngle) {
        canvas.drawArc(
          rect,
          currentSegmentStartAngle,
          currentSegmentSweepAngle,
          false,
          paint,
        );
        currentSegmentStartAngle += currentSegmentSweepAngle;
      } else {
        // This is the last segment to draw
        final remainingAngle =
            sweepAngle - currentSegmentStartAngle + startAngle;
        canvas.drawArc(
          rect,
          currentSegmentStartAngle,
          remainingAngle,
          false,
          paint,
        );
        break;
      }
    }
  }

  @override
  bool shouldRepaint(CurvedProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
