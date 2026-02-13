import 'package:confetti/confetti.dart';
import 'package:flutter/widgets.dart';

class KinlyConfettiOverlay extends StatelessWidget {
  const KinlyConfettiOverlay({
    super.key,
    required this.confettiController,
    required this.colors,
    this.alignment = Alignment.topCenter,
  });

  final ConfettiController confettiController;
  final List<Color> colors;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return IgnorePointer(
      child: SizedBox.expand(
        child: Align(
          alignment: alignment,
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.01,
              maxBlastForce: 4,
              minBlastForce: 2,
              numberOfParticles: 6,
              gravity: 0.12,
              colors: colors,
              canvas: screenSize,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}
