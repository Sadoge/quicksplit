import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../model/split_result.dart';
import '../viewmodel/currency_viewmodel.dart';
import '../viewmodel/split_viewmodel.dart';

class ResultsCard extends ConsumerWidget {
  const ResultsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(splitViewmodelProvider.select((s) => s.result));
    final sym = ref.watch(currencyProvider).value?.symbol ?? '\$';
    if (result == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Unassigned warning
        if (result.unassignedAmount != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.card),
                topRight: Radius.circular(AppRadius.card),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  result.unassignedAmount! > 0
                      ? '$sym${result.unassignedAmount!.toStringAsFixed(2)} unassigned'
                      : '$sym${result.unassignedAmount!.abs().toStringAsFixed(2)} over-assigned',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.accentOrange,
                  ),
                ),
              ],
            ),
          ),
        // Main card
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(color: AppColors.border, width: 1.5),
            borderRadius: result.unassignedAmount != null
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(AppRadius.card),
                    bottomRight: Radius.circular(AppRadius.card),
                  )
                : AppRadius.cardBorder,
          ),
          child: Column(
            children: [
              // Green header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                color: AppColors.accentGreen,
                child: Row(
                  children: [
                    Text(
                      'BREAKDOWN',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$sym${result.total.toStringAsFixed(2)}',
                      style: AppTypography.mono.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Person results
              ...List.generate(result.personResults.length, (index) {
                final pr = result.personResults[index];
                return Column(
                  children: [
                    if (index > 0)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.border,
                      ),
                    _ResultRow(personResult: pr, currencySymbol: sym),
                  ],
                );
              }),
              // Summary strip
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    _SummaryCell(
                      label: 'Subtotal',
                      value: '$sym${result.billTotal.toStringAsFixed(2)}',
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: AppColors.border,
                    ),
                    _SummaryCell(
                      label: 'Tip ${result.tipPercent.toStringAsFixed(0)}%',
                      value: '$sym${result.tip.toStringAsFixed(2)}',
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: AppColors.border,
                    ),
                    _SummaryCell(
                      label: 'Total',
                      value: '$sym${result.total.toStringAsFixed(2)}',
                      bold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final PersonResult personResult;
  final String currencySymbol;
  const _ResultRow({required this.personResult, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final person = personResult.person;
    final initial =
        person.name.isNotEmpty ? person.name[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: person.avatarBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: AppTypography.titleMedium.copyWith(
                  color: person.avatarFg,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
                Text(
                  '$currencySymbol${personResult.subtotal.toStringAsFixed(2)} + $currencySymbol${personResult.tipShare.toStringAsFixed(2)} tip',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.text3,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$currencySymbol${personResult.owes.toStringAsFixed(2)}',
            style: AppTypography.monoLarge.copyWith(
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryCell({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.text3,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.mono.copyWith(
                color: bold ? AppColors.text : AppColors.text2,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
