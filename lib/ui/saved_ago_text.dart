import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:counter/l10n/app_localizations.dart';

/// Displays a save-status label in the title bar.
///
/// States:
/// - [isSaving] is true → "Saving..."
/// - [lastSavedAt] < 1 minute ago → "Saved less than a minute ago"
/// - [lastSavedAt] 1–10 minutes ago → "Saved X minutes ago"
/// - [lastSavedAt] > 10 minutes ago or null → hidden
class SavedAgoText extends StatefulWidget {
  final DateTime? lastSavedAt;
  final bool isSaving;
  final TextStyle? style;

  const SavedAgoText({
    super.key,
    required this.lastSavedAt,
    this.isSaving = false,
    this.style,
  });

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
    if (widget.lastSavedAt != oldWidget.lastSavedAt ||
        widget.isSaving != oldWidget.isSaving) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.lastSavedAt != null || widget.isSaving) {
      _timer = Timer.periodic(const Duration(seconds: 10), (_) {
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
    if (widget.isSaving) {
      final l10n = AppLocalizations.of(context)!;
      return Text(
        l10n.saving,
        style: widget.style,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (widget.lastSavedAt == null) return const SizedBox.shrink();

    final diff = DateTime.now().difference(widget.lastSavedAt!);

    // Hide after 10 minutes
    if (diff.inMinutes > 10) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final String text;

    if (diff.inMinutes < 1) {
      text = l10n.savedLessThanMinute;
    } else {
      text = l10n.savedMinutesAgo(diff.inMinutes);
    }

    return Text(
      text,
      style: widget.style,
      overflow: TextOverflow.ellipsis,
    );
  }
}
