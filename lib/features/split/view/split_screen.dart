import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../viewmodel/split_viewmodel.dart';
import '../widgets/bill_hero_card.dart';
import '../widgets/currency_selector.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/tip_selector_card.dart';
import '../widgets/people_card.dart';
import '../widgets/results_card.dart';
import '../widgets/share_button.dart';

class SplitScreen extends ConsumerWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(splitViewmodelProvider.select((s) => s.result));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: AppSpacing.md),
                  const BillHeroCard(),
                  const SizedBox(height: AppSpacing.md),
                  const CurrencySelector(),
                  const SizedBox(height: AppSpacing.md),
                  const ModeToggle(),
                  const SizedBox(height: AppSpacing.md),
                  _SectionLabel(label: 'TIP'),
                  const SizedBox(height: AppSpacing.sm),
                  const TipSelectorCard(),
                  const SizedBox(height: AppSpacing.md),
                  _SectionLabel(label: 'PEOPLE'),
                  const SizedBox(height: AppSpacing.sm),
                  const PeopleCard(),
                  const SizedBox(height: AppSpacing.md),
                  if (result != null)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: ResultsCard(
                        key: ValueKey(result.personResults.length),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ShareButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Logo icon
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(
              Icons.content_cut_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // App name
        RichText(
          text: TextSpan(
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.text,
            ),
            children: [
              const TextSpan(text: 'Quick'),
              TextSpan(
                text: 'Split',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.accentGreen,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // New Split button
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            ref.read(splitViewmodelProvider.notifier).reset();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: AppRadius.pillBorder,
            ),
            child: Text(
              'New Split',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.text3,
        ),
      ),
    );
  }
}
