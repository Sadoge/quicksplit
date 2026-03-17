import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../viewmodel/currency_viewmodel.dart';
import '../viewmodel/split_viewmodel.dart';

class ShareButton extends ConsumerWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasResult = ref.watch(
      splitViewmodelProvider.select((s) {
        final bill = double.tryParse(s.billInput) ?? 0;
        return bill > 0 && s.people.isNotEmpty;
      }),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background,
          ],
          stops: const [0.0, 0.35],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: hasResult
              ? () {
                  HapticFeedback.mediumImpact();
                  final sym = ref.read(currencyProvider).value?.symbol ?? '\$';
                  final text = ref
                      .read(splitViewmodelProvider.notifier)
                      .buildShareText(sym);
                  SharePlus.instance.share(ShareParams(text: text));
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.cardBorder,
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.share_rounded,
                size: 18,
                color: hasResult
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.5),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Share Breakdown',
                style: AppTypography.labelLarge.copyWith(
                  color: hasResult
                      ? AppColors.white
                      : AppColors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
