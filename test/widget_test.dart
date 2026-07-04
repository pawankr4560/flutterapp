import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppTextField clears validation error after valid input', (
    WidgetTester tester,
  ) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextField(
              labelText: 'Email',
              hintText: 'Email',
              validator: (value) {
                final email = value?.trim() ?? '';
                final isValid =
                    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
                return isValid ? null : 'Enter a valid email address';
              },
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'admin@gmail.com');
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsNothing);
  });
}
