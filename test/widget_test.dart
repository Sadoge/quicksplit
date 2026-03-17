import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quicksplit/main.dart';

void main() {
  testWidgets('App renders QuickSplit header', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: QuickSplitApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Split'), findsOneWidget);
  });
}
