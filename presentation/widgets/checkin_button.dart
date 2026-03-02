import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../bloc/checkin_bloc.dart';
import '../bloc/checkin_event.dart';
import '../bloc/checkin_state.dart';

class CheckInButton extends StatefulWidget {
  const CheckInButton({super.key});

  @override
  State<CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends State<CheckInButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 12.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckInBloc, CheckInState>(
      listener: (context, state) {
        if (state is CheckInSuccess) {
          setState(() {
            _showConfetti = true;
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _showConfetti = false;
              });
            }
          });
        } else if (state is CheckInAlreadyDone) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You\'ve already checked in today')),
          );
        } else if (state is CheckInError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        bool hasCheckedIn = false;
        DateTime? checkInTime;
        int streak = 0;

        if (state is CheckInLoaded) {
          hasCheckedIn = state.hasCheckedInToday;
          checkInTime = state.todayCheckInTime;
          streak = state.streakCount;
        } else if (state is CheckInSuccess) {
          hasCheckedIn = true;
          checkInTime = state.checkInTime;
          streak = state.streakCount;
        } else if (state is CheckInAlreadyDone) {
          hasCheckedIn = true;
          checkInTime = state.checkInTime;
          streak = state.streakCount;
        }

        final buttonColor = hasCheckedIn ? Colors.green : AppTheme.primaryColor;
        final icon = hasCheckedIn ? Icons.check_rounded : Icons.fingerprint;
        final label = hasCheckedIn ? 'Checked In ✓' : 'Tap to Check In';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (!hasCheckedIn)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 220 + _pulseAnimation.value,
                        height: 220 + _pulseAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: buttonColor.withValues(alpha: 0.15),
                        ),
                      );
                    },
                  ),
                GestureDetector(
                  onTap: () {
                    context.read<CheckInBloc>().add(
                      const PerformCheckInEvent(),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasCheckedIn
                          ? LinearGradient(
                              colors: [
                                Colors.green.shade500,
                                Colors.green.shade700,
                              ],
                            )
                          : LinearGradient(
                              colors: [buttonColor, AppTheme.accentColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 54, color: Colors.white),
                          const SizedBox(height: 12),
                          Text(
                            label,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_showConfetti)
                  IgnorePointer(
                    ignoring: true,
                    child: CustomPaint(
                      size: const Size(260, 260),
                      painter: _ConfettiPainter(),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (checkInTime != null)
              Text(
                'Checked in at ${DateUtilsHelper.formatTime(checkInTime)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 24),
            _StreakCard(streakCount: streak),
          ],
        );
      },
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streakCount;

  const _StreakCard({required this.streakCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current streak',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$streakCount days',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.local_fire_department_rounded,
              color: streakCount > 0 ? Colors.orange : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      paint.color = Colors.primaries[i % Colors.primaries.length].withValues(
        alpha: 0.7,
      );
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = 2 + random.nextDouble() * 3;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
