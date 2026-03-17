import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/design_system/app_theme.dart';
import 'features/split/view/split_screen.dart';

void main() {
  runApp(const ProviderScope(child: QuickSplitApp()));
}

class QuickSplitApp extends StatelessWidget {
  const QuickSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickSplit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplitScreen(),
    );
  }
}
