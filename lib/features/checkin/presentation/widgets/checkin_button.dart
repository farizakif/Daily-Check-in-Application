import 'package:flutter/material.dart';

class CheckInButton extends StatelessWidget {
  final bool hasCheckedInToday;
  final VoidCallback onPressed;

  const CheckInButton({
    super.key,
    required this.hasCheckedInToday,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed: hasCheckedInToday ? null : onPressed,
      icon: const Icon(Icons.check_rounded),
      label: Text(
        hasCheckedInToday ? 'Already Checked In Today' : 'Check-In',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: hasCheckedInToday
            ? theme.disabledColor.withOpacity(0.12)
            : theme.colorScheme.primary,
        foregroundColor: hasCheckedInToday
            ? theme.disabledColor
            : theme.colorScheme.onPrimary,
      ),
    );
  }
}
