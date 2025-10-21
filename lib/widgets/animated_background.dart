import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// AnimatedBackground: gradient + floating particles that respond to pointer (on web/desktop)
class AnimatedBackground extends StatefulWidget {
  final Widget? child;
  const AnimatedBackground({super.key, this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  Offset _pointer = Offset.zero;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // create some particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle.random(_rnd));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePointer(PointerEvent event) {
    setState(() {
      _pointer = event.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover:
          kIsWeb ||
              Theme.of(context).platform != TargetPlatform.android &&
                  Theme.of(context).platform != TargetPlatform.iOS
          ? _updatePointer
          : null,
      onPointerMove:
          kIsWeb ||
              Theme.of(context).platform != TargetPlatform.android &&
                  Theme.of(context).platform != TargetPlatform.iOS
          ? _updatePointer
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _BackgroundPainter(
              animationValue: _controller.value,
              particles: _particles,
              pointer: _pointer,
            ),
            child: Container(
              // ensure it fills
              constraints: const BoxConstraints.expand(),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;

  _Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
  });

  factory _Particle.random(Random rnd) {
    return _Particle(
      position: Offset(rnd.nextDouble(), rnd.nextDouble()),
      velocity: Offset(
        (rnd.nextDouble() - 0.5) * 0.0008,
        (rnd.nextDouble() - 0.5) * 0.0008,
      ),
      size: 2.0 + rnd.nextDouble() * 4.0,
      color: Colors.white.withAlpha(
        ((0.6 + rnd.nextDouble() * 0.4) * 255).round(),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double animationValue;
  final List<_Particle> particles;
  final Offset pointer;

  _BackgroundPainter({
    required this.animationValue,
    required this.particles,
    required this.pointer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // moving gradient
    final rect = Offset.zero & size;
    final centerShift = animationValue * 2 * pi;
    final colorA = Color.lerp(
      Colors.indigo,
      Colors.cyan,
      (sin(centerShift) + 1) / 2,
    )!;
    final colorB = Color.lerp(
      Colors.deepPurple,
      Colors.teal,
      (cos(centerShift) + 1) / 2,
    )!;

    final gradient = RadialGradient(
      center: Alignment(0.1 * sin(centerShift), 0.1 * cos(centerShift)),
      radius: 0.9,
      colors: [colorA, colorB],
      stops: [0.0, 1.0],
    ).createShader(rect);

    final paint = Paint()..shader = gradient;
    canvas.drawRect(rect, paint);

    // particle layer
    final particlePaint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      // update position based on animationValue
      final dx =
          (p.position.dx + p.velocity.dx * (animationValue * 1000)) % 1.0;
      final dy =
          (p.position.dy + p.velocity.dy * (animationValue * 1000)) % 1.0;
      final px = dx * size.width;
      final py = dy * size.height;

      // pointer interaction: repel or attract a bit
      final dist = (pointer - Offset(px, py)).distance;
      double offsetFactor = 0.0;
      if (pointer != Offset.zero && dist < 150) {
        // repel
        offsetFactor = (150 - dist) / 150;
      }

      final drawX = px + (px - pointer.dx) * 0.02 * offsetFactor;
      final drawY = py + (py - pointer.dy) * 0.02 * offsetFactor;

      particlePaint.color = p.color;
      canvas.drawCircle(Offset(drawX, drawY), p.size, particlePaint);
    }

    // subtle vignette
    final vignette = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.black.withAlpha((0.12 * 255).round()),
        ],
        stops: [0.6, 1.0],
      ).createShader(rect)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(rect, vignette);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) => true;
}
