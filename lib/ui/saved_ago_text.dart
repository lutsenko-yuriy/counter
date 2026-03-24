import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:counter/l10n/app_localizations.dart';

/// Displays a "Saved X ago" label that auto-updates every second.
///
/// Shows nothing if [lastSavedAt] is null.
class SavedAgoText extends StatefulWidget {
  final DateTime? lastSavedAt;
  final TextStyle? style;

  const SavedAgoText({super.key, required this.lastSavedAt, this.style});

  @override
  State<SavedAgoText> createState() => _SavedAgoTextState();
}

class _SavedAgoTextState extends State<SavedAgoText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(SavedAgoText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lastSavedAt != oldWidget.lastSavedAt) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.lastSavedAt != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lastSavedAt == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(widget.lastSavedAt!);
    final String timeText;

    if (diff.inSeconds < 5) {
      timeText = l10n.justNow;
    } else if (diff.inMinutes < 1) {
      timeText = l10n.savedAgo(l10n.secondsAgo(diff.inSeconds));
    } else {
      timeText = l10n.savedAgo(l10n.minutesAgo(diff.inMinutes));
    }

    return Text(
      timeText,
      style: widget.style,
      overflow: TextOverflow.ellipsis,
    );
  }
}
