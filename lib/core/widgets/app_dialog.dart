import 'package:flutter/material.dart';

import 'primary_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        primaryActionLabel: primaryActionLabel,
        onPrimaryAction: onPrimaryAction,
        secondaryActionLabel: secondaryActionLabel,
        onSecondaryAction: onSecondaryAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = <Widget>[
      if (title != null) ...[
        Text(
          title!,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
      ],
      content,
    ];
    if (actions != null && actions!.isNotEmpty) {
      list.add(const SizedBox(height: 24));
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!,
      ));
    } else if (primaryActionLabel != null || secondaryActionLabel != null) {
      list.add(const SizedBox(height: 24));
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (secondaryActionLabel != null)
            TextButton(
              onPressed: onSecondaryAction ?? () => Navigator.of(context).pop(),
              child: Text(secondaryActionLabel!),
            ),
          if (secondaryActionLabel != null && primaryActionLabel != null)
            const SizedBox(width: 8),
          if (primaryActionLabel != null)
            PrimaryButton(
              label: primaryActionLabel!,
              isExpanded: false,
              onPressed: onPrimaryAction,
            ),
        ],
      ));
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: list,
        ),
      ),
    );
  }

  static Future<double?> showAmount(
    BuildContext context, {
    String title = 'Amount',
    String label = 'Amount',
    String hint = 'Enter amount',
  }) async {
    final controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: label, hintText: hint),
          autofocus: true,
        ),
        primaryActionLabel: 'Confirm',
        onPrimaryAction: () {
          final a = double.tryParse(controller.text.trim());
          if (a != null && a > 0) Navigator.of(ctx).pop(a);
        },
        secondaryActionLabel: 'Cancel',
      ),
    );
  }
}
