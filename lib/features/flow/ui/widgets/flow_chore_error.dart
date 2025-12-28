part of '../flow_chore_screen.dart';

class _FlowChoreError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FlowChoreError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          KinlyFilledButton.text(
            fullWidth: true,
            onPressed: onRetry,
            label: s.flowChoreRetry,
          ),
        ],
      ),
    );
  }
}
