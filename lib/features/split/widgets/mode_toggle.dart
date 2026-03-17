import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../viewmodel/split_viewmodel.dart';

class ModeToggle extends ConsumerWidget {
  const ModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(splitViewmodelProvider.select((s) => s.mode));

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: 'Equal',
              isActive: mode == SplitMode.equal,
              onTap: () {
                HapticFeedback.lightImpact();
                ref
                    .read(splitViewmodelProvider.notifier)
                    .setMode(SplitMode.equal);
              },
            ),
          ),
          Expanded(
            child: _ToggleButton(
              label: 'By Item',
              isActive: mode == SplitMode.byItem,
              onTap: () {
                HapticFeedback.lightImpact();
                ref
                    .read(splitViewmodelProvider.notifier)
                    .setMode(SplitMode.byItem);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.card - 4),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: isActive ? AppColors.white : AppColors.text3,
            ),
          ),
        ),
      ),
    );
  }
}
