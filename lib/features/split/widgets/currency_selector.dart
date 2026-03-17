import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../viewmodel/currency_viewmodel.dart';

class CurrencySelector extends ConsumerWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(currencyProvider).value ?? Currency.usd;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showCurrencyPicker(context, ref, selected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.accentGreenBg,
          borderRadius: AppRadius.pillBorder,
          border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.symbol,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              selected.code,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.accentGreen,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.accentGreen,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    Currency selected,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.card),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Text(
                      'CURRENCY',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Currency.values.length,
                  itemBuilder: (context, index) {
                    final currency = Currency.values[index];
                    final isSelected = currency == selected;
                    return _CurrencyTile(
                      currency: currency,
                      isSelected: isSelected,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        ref
                            .read(currencyProvider.notifier)
                            .setCurrency(currency);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyTile({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        color: isSelected ? AppColors.accentGreenBg : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentGreen
                    : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  currency.symbol,
                  style: AppTypography.titleMedium.copyWith(
                    color: isSelected ? AppColors.white : AppColors.text2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              currency.code,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.text,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: 20,
                color: AppColors.accentGreen,
              ),
          ],
        ),
      ),
    );
  }
}
