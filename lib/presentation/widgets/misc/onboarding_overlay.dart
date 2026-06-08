import 'package:flutter/material.dart';
import '/utilities/constants.dart';

const _kRippleDuration = Duration(milliseconds: 1400);

enum _Phase { phase1Ripple, phase1Continue, phase2LongPress }

class OnboardingOverlay extends StatefulWidget {
  const OnboardingOverlay({
    super.key,
    required this.cardRect,
    required this.onDismiss,
    this.onCardLongPress,
  });

  final Rect cardRect;
  final VoidCallback onDismiss;
  final VoidCallback? onCardLongPress;

  @override
  State<OnboardingOverlay> createState() => _OnboardingOverlayState();
}

class _OnboardingOverlayState extends State<OnboardingOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _tapRippleController;
  late final AnimationController _badgeDismissController;
  late final AnimationController _longPressController;

  late final Animation<double> _badgeScale;
  late final Animation<double> _badgeOpacity;

  _Phase _phase = _Phase.phase1Ripple;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tapRippleController = AnimationController(
      vsync: this,
      duration: _kRippleDuration,
    );
    _badgeDismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _longPressController = AnimationController(
      vsync: this,
      duration: _kRippleDuration,
    );

    _badgeScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 75,
      ),
    ]).animate(_badgeDismissController);

    _badgeOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 75),
    ]).animate(_badgeDismissController);

    _fadeController.forward().then((_) {
      if (mounted) _tapRippleController.repeat();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _tapRippleController.dispose();
    _badgeDismissController.dispose();
    _longPressController.dispose();
    super.dispose();
  }

  void _onBadgeTap() {
    if (_phase != _Phase.phase1Ripple) return;
    _tapRippleController.stop();
    _badgeDismissController.forward().then((_) {
      if (mounted) setState(() => _phase = _Phase.phase1Continue);
    });
  }

  void _onContinueTap() {
    setState(() => _phase = _Phase.phase2LongPress);
    _longPressController.repeat();
  }

  void _handleAdvance() {
    if (_phase == _Phase.phase1Ripple) {
      _tapRippleController.stop();
      setState(() => _phase = _Phase.phase2LongPress);
      _longPressController.repeat();
    } else if (_phase == _Phase.phase1Continue) {
      _onContinueTap();
    } else if (_phase == _Phase.phase2LongPress) {
      _onGotIt();
    }
  }

  void _onGotIt() {
    if (_isDismissing) return;
    _isDismissing = true;
    _fadeController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardRect = widget.cardRect;
    final badgeCenter = Offset(
      cardRect.right - 10 - 7,
      cardRect.top + 10 + 7,
    );
    final screenHeight = MediaQuery.of(context).size.height;
    final belowCard = cardRect.bottom + 16;
    final aboveCard = cardRect.top - 16;
    // Prefer below, fall back above if card is too low on screen.
    final tooltipTop = (belowCard + 120 < screenHeight - 100)
        ? belowCard
        : (aboveCard - 120 > 80 ? aboveCard - 120 : belowCard);

    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleAdvance,
        onLongPressStart: (LongPressStartDetails details) {
          if (_phase == _Phase.phase2LongPress &&
              widget.cardRect.contains(details.globalPosition)) {
            widget.onCardLongPress?.call();
          }
          _handleAdvance();
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _SpotlightPainter(cardRect: cardRect),
                ),
              ),

              if (_phase == _Phase.phase1Ripple)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _tapRippleController,
                    builder: (_, __) => CustomPaint(
                      painter: _RipplePainter(
                        center: badgeCenter,
                        progress: _tapRippleController.value,
                        maxRadius: 22,
                      ),
                    ),
                  ),
                ),

              if (_phase == _Phase.phase1Ripple || _phase == _Phase.phase1Continue)
                Positioned(
                  left: badgeCenter.dx - 7,
                  top: badgeCenter.dy - 7,
                  child: GestureDetector(
                    onTap: _phase == _Phase.phase1Ripple ? _onBadgeTap : null,
                    child: ScaleTransition(
                      scale: _badgeScale,
                      child: FadeTransition(
                        opacity: _badgeOpacity,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: GameColors.danger,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 1.35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              if (_phase == _Phase.phase2LongPress)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _longPressController,
                    builder: (_, __) => CustomPaint(
                      painter: _RipplePainter(
                        center: cardRect.center,
                        progress: _longPressController.value,
                        maxRadius: cardRect.shortestSide * 0.55,
                      ),
                    ),
                  ),
                ),

              Positioned(
                top: tooltipTop,
                left: 24,
                right: 24,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _phase == _Phase.phase2LongPress
                              ? 'Long press any card to add or remove it from favorites.'
                              : 'Red dot indicate a change or a new entry.\nTap it to dismiss.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _phase == _Phase.phase2LongPress
                              ? 'Tap anywhere to dismiss'
                              : 'Tap anywhere to skip',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter({required this.cardRect});
  final Rect cardRect;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        cardRect.inflate(8),
        const Radius.circular(16),
      ));
    canvas.drawPath(path, Paint()..color = const Color(0xCC000000));
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.cardRect != cardRect;
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter({
    required this.center,
    required this.progress,
    required this.maxRadius,
  });

  final Offset center;
  final double progress;
  final double maxRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = maxRadius * progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.center != center ||
      oldDelegate.maxRadius != maxRadius;
}
