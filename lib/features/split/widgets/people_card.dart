import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../viewmodel/split_viewmodel.dart';
import 'person_row.dart';

class PeopleCard extends ConsumerWidget {
  const PeopleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(splitViewmodelProvider);
    final people = state.people;
    final isByItem = state.mode == SplitMode.byItem;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Text(
                '${people.length} People',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(splitViewmodelProvider.notifier).addPerson();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreenBg,
                    borderRadius: AppRadius.pillBorder,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '+',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.accentGreen,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Add',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // People list
          if (people.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'Add people to split the bill',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.text3,
                ),
              ),
            )
          else
            ...List.generate(people.length, (index) {
              final person = people[index];
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 0 : AppSpacing.sm,
                ),
                child: PersonRow(
                  key: ValueKey(person.id),
                  person: person,
                  showAmount: isByItem,
                  canRemove: people.length > 1,
                ),
              );
            }),
        ],
      ),
    );
  }
}
