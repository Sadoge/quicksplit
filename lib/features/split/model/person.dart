import 'package:flutter/material.dart';

@immutable
class Person {
  final String id;
  final String name;
  final String rawAmount;
  final Color avatarBg;
  final Color avatarFg;

  const Person({
    required this.id,
    required this.name,
    this.rawAmount = '',
    required this.avatarBg,
    required this.avatarFg,
  });

  Person copyWith({
    String? name,
    String? rawAmount,
    Color? avatarBg,
    Color? avatarFg,
  }) {
    return Person(
      id: id,
      name: name ?? this.name,
      rawAmount: rawAmount ?? this.rawAmount,
      avatarBg: avatarBg ?? this.avatarBg,
      avatarFg: avatarFg ?? this.avatarFg,
    );
  }
}
