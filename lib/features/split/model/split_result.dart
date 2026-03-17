import 'package:flutter/material.dart';

import 'person.dart';

@immutable
class PersonResult {
  final Person person;
  final double subtotal;
  final double tipShare;
  final double owes;

  const PersonResult({
    required this.person,
    required this.subtotal,
    required this.tipShare,
    required this.owes,
  });
}

@immutable
class SplitResult {
  final double billTotal;
  final double tip;
  final double total;
  final double tipPercent;
  final List<PersonResult> personResults;
  final double? unassignedAmount;

  const SplitResult({
    required this.billTotal,
    required this.tip,
    required this.total,
    required this.tipPercent,
    required this.personResults,
    this.unassignedAmount,
  });
}
