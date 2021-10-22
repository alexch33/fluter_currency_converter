// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:currency_converter/di/components/app_component.dart';
import 'package:currency_converter/di/modules/local_module.dart';
import 'package:currency_converter/di/modules/netwok_module.dart';
import 'package:currency_converter/di/modules/preference_module.dart';
import 'package:currency_converter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('First Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(AppComponent.getReposInstance(
      NetworkModule(),
      LocalModule(),
      PreferenceModule(),
    )!));
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(find.byType(TextField), '0');
    await tester.pump(Duration(seconds: 1));
    final textFinder = find.byKey(const Key("result_text"));
    await tester.pump(Duration(seconds: 1));
    var text = textFinder.evaluate().first.widget as Text;

    expect(text.data, '0.0 \$');
  });
}
