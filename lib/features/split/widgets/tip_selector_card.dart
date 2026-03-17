import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../viewmodel/split_viewmodel.dart';

class TipSelectorCard extends ConsumerStatefulWidget {
  const TipSelectorCard({super.key});

  @override
  ConsumerState<TipSelectorCard> createState() => _TipSelectorCardState();
}

class _TipSelectorCardState extends ConsumerState<TipSelectorCard> {
  late final TextEditingController _customController;
  bool _isCustom = false;

  static const _presets = [10.0, 15.0, 18.0, 20.0];

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tipPercent =
        ref.watch(splitViewmodelProvider.select((s) => s.tipPercent));

    final isPreset = _presets.contains(tipPercent) && !_isCustom;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        children: [
          Row(
            children: [
              for (final preset in _presets) ...[
                if (preset != _presets.first) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _TipButton(
                    label: '${preset.toStringAsFixed(0)}%',
                    isActive: isPreset && tipPercent == preset,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _isCustom = false);
                      _customController.clear();
                      ref
                          .read(splitViewmodelProvider.notifier)
                          .setTipPercent(preset);
                    },
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.innerBorder,
            ),
            child: Row(
              children: [
                Text(
                  'Custom %',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.text3,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _customController,
                    textAlign: TextAlign.right,
                    style: AppTypography.mono.copyWith(color: AppColors.text),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,1}'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '—',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      setState(() => _isCustom = value.isNotEmpty);
                      if (value.isNotEmpty) {
                        ref
                            .read(splitViewmodelProvider.notifier)
                            .setCustomTip(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TipButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: AppRadius.innerBorder,
          border: isActive
              ? null
              : Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: isActive ? AppColors.white : AppColors.text2,
            ),
          ),
        ),
      ),
    );
  }
}
