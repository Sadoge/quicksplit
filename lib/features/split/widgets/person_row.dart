import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/app_typography.dart';
import '../model/person.dart';
import '../viewmodel/currency_viewmodel.dart';
import '../viewmodel/split_viewmodel.dart';

class PersonRow extends ConsumerStatefulWidget {
  final Person person;
  final bool showAmount;
  final bool canRemove;

  const PersonRow({
    super.key,
    required this.person,
    required this.showAmount,
    required this.canRemove,
  });

  @override
  ConsumerState<PersonRow> createState() => _PersonRowState();
}

class _PersonRowState extends ConsumerState<PersonRow>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.person.name);
    _amountController = TextEditingController(text: widget.person.rawAmount);

    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant PersonRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.person.name != widget.person.name &&
        _nameController.text != widget.person.name) {
      _nameController.text = widget.person.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider).value ?? Currency.usd;
    final initial =
        widget.person.name.isNotEmpty ? widget.person.name[0].toUpperCase() : '?';

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.innerBorder,
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.person.avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTypography.titleMedium.copyWith(
                      color: widget.person.avatarFg,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Name
              Expanded(
                child: TextField(
                  controller: _nameController,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.text,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    ref
                        .read(splitViewmodelProvider.notifier)
                        .updatePersonName(widget.person.id, value);
                  },
                ),
              ),
              // Amount (byItem mode)
              if (widget.showAmount) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 90,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppRadius.innerBorder,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currency.symbol,
                        style: AppTypography.mono.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          style: AppTypography.mono.copyWith(
                            color: AppColors.text,
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            ref
                                .read(splitViewmodelProvider.notifier)
                                .updatePersonAmount(
                                    widget.person.id, value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Remove button
              const SizedBox(width: AppSpacing.xs),
              GestureDetector(
                onTap: widget.canRemove
                    ? () {
                        HapticFeedback.lightImpact();
                        ref
                            .read(splitViewmodelProvider.notifier)
                            .removePerson(widget.person.id);
                      }
                    : null,
                child: Opacity(
                  opacity: widget.canRemove ? 1.0 : 0.3,
                  child: Text(
                    '×',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
