import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/design_system/app_colors.dart';
import '../model/person.dart';
import '../model/split_result.dart';

enum SplitMode { equal, byItem }

@immutable
class SplitState {
  final String billInput;
  final double tipPercent;
  final SplitMode mode;
  final List<Person> people;
  final SplitResult? result;

  const SplitState({
    this.billInput = '',
    this.tipPercent = 15.0,
    this.mode = SplitMode.equal,
    this.people = const [],
    this.result,
  });

  SplitState copyWith({
    String? billInput,
    double? tipPercent,
    SplitMode? mode,
    List<Person>? people,
    SplitResult? result,
  }) {
    return SplitState(
      billInput: billInput ?? this.billInput,
      tipPercent: tipPercent ?? this.tipPercent,
      mode: mode ?? this.mode,
      people: people ?? this.people,
      result: result ?? this.result,
    );
  }
}

const _defaultNames = [
  'Alex',
  'Jordan',
  'Sam',
  'Riley',
  'Morgan',
  'Casey',
  'Drew',
  'Avery',
];

const _uuid = Uuid();

class SplitViewmodel extends Notifier<SplitState> {
  @override
  SplitState build() {
    final palette = AppColors.avatarPalette;
    final initialPeople = [
      Person(
        id: _uuid.v4(),
        name: _defaultNames[0],
        avatarBg: palette[0].bg,
        avatarFg: palette[0].fg,
      ),
      Person(
        id: _uuid.v4(),
        name: _defaultNames[1],
        avatarBg: palette[1].bg,
        avatarFg: palette[1].fg,
      ),
    ];
    final initialState = SplitState(people: initialPeople);
    return _calculateState(initialState);
  }

  void setBillInput(String value) {
    state = state.copyWith(billInput: value);
    _calculate();
  }

  void setTipPercent(double value) {
    state = state.copyWith(tipPercent: value);
    _calculate();
  }

  void setCustomTip(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null && parsed >= 0) {
      state = state.copyWith(tipPercent: parsed);
      _calculate();
    }
  }

  void setMode(SplitMode mode) {
    state = state.copyWith(mode: mode);
    _calculate();
  }

  void addPerson() {
    final usedNames = state.people.map((p) => p.name).toSet();
    var name = 'Person ${state.people.length + 1}';
    for (final defaultName in _defaultNames) {
      if (!usedNames.contains(defaultName)) {
        name = defaultName;
        break;
      }
    }

    final colorIndex = state.people.length % AppColors.avatarPalette.length;
    final palette = AppColors.avatarPalette[colorIndex];

    final newPerson = Person(
      id: _uuid.v4(),
      name: name,
      avatarBg: palette.bg,
      avatarFg: palette.fg,
    );

    state = state.copyWith(people: [...state.people, newPerson]);
    _calculate();
  }

  void removePerson(String id) {
    if (state.people.length <= 1) return;
    state = state.copyWith(
      people: state.people.where((p) => p.id != id).toList(),
    );
    _calculate();
  }

  void updatePersonName(String id, String name) {
    state = state.copyWith(
      people: state.people.map((p) {
        if (p.id == id) return p.copyWith(name: name);
        return p;
      }).toList(),
    );
  }

  void updatePersonAmount(String id, String amount) {
    state = state.copyWith(
      people: state.people.map((p) {
        if (p.id == id) return p.copyWith(rawAmount: amount);
        return p;
      }).toList(),
    );
    _calculate();
  }

  void reset() {
    state = build();
  }

  String buildShareText() {
    final r = state.result;
    if (r == null) return '';

    final buffer = StringBuffer();
    buffer.writeln('✂️ QuickSplit');
    buffer.writeln();
    buffer.writeln(
      'Bill \$${r.billTotal.toStringAsFixed(2)} + '
      '${r.tipPercent.toStringAsFixed(0)}% tip = '
      '\$${r.total.toStringAsFixed(2)}',
    );
    buffer.writeln();

    for (final pr in r.personResults) {
      buffer.writeln('${pr.person.name} → \$${pr.owes.toStringAsFixed(2)}');
    }

    return buffer.toString();
  }

  void _calculate() {
    state = _calculateState(state);
  }

  SplitState _calculateState(SplitState s) {
    final bill = double.tryParse(s.billInput) ?? 0.0;
    final tip = bill * s.tipPercent / 100.0;
    final total = bill + tip;

    if (s.people.isEmpty || bill == 0) {
      return s.copyWith(
        result: SplitResult(
          billTotal: bill,
          tip: tip,
          total: total,
          tipPercent: s.tipPercent,
          personResults: s.people
              .map((p) => PersonResult(
                    person: p,
                    subtotal: 0,
                    tipShare: 0,
                    owes: 0,
                  ))
              .toList(),
        ),
      );
    }

    if (s.mode == SplitMode.equal) {
      final perPerson = total / s.people.length;
      final tipPerPerson = tip / s.people.length;
      final subtotalPerPerson = bill / s.people.length;

      return s.copyWith(
        result: SplitResult(
          billTotal: bill,
          tip: tip,
          total: total,
          tipPercent: s.tipPercent,
          personResults: s.people
              .map((p) => PersonResult(
                    person: p,
                    subtotal: subtotalPerPerson,
                    tipShare: tipPerPerson,
                    owes: perPerson,
                  ))
              .toList(),
        ),
      );
    }

    // By item mode
    final sumAmounts = s.people.fold<double>(
      0.0,
      (sum, p) => sum + (double.tryParse(p.rawAmount) ?? 0.0),
    );
    final unassigned = bill - sumAmounts;

    final personResults = s.people.map((p) {
      final amount = double.tryParse(p.rawAmount) ?? 0.0;
      final ratio = sumAmounts > 0 ? amount / sumAmounts : 1.0 / s.people.length;
      final tipShare = tip * ratio;
      return PersonResult(
        person: p,
        subtotal: amount,
        tipShare: tipShare,
        owes: amount + tipShare,
      );
    }).toList();

    return s.copyWith(
      result: SplitResult(
        billTotal: bill,
        tip: tip,
        total: total,
        tipPercent: s.tipPercent,
        personResults: personResults,
        unassignedAmount: unassigned.abs() < 0.01 ? null : unassigned,
      ),
    );
  }
}

final splitViewmodelProvider =
    NotifierProvider<SplitViewmodel, SplitState>(SplitViewmodel.new);
