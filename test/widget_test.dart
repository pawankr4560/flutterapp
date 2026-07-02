import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loan_tracker_application/features/application/application_form_screen.dart';
import 'package:loan_tracker_application/features/calculator/emi_calculator_screen.dart';
import 'package:loan_tracker_application/features/documents/document_upload_screen.dart';
import 'package:loan_tracker_application/features/status/application_status_screen.dart';
import 'package:loan_tracker_application/main.dart';

void main() {
  testWidgets('Login screen renders expected controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LoanTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('Loan Tracker'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email or phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);
  });

  testWidgets('Signup screen renders expected controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LoanTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Create account'), findsWidgets);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Phone number'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.byIcon(Icons.person_add_alt_1_outlined), findsOneWidget);
  });

  testWidgets('Dashboard screen renders expected content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LoanTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Aarav'), findsOneWidget);
    expect(find.text('Pre-approved loan offer'), findsOneWidget);
    expect(find.text('Up to Rs. 8,00,000'), findsOneWidget);
    expect(find.text('Interest rate from 9.25% p.a.'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Auto'), findsOneWidget);
    expect(find.text('Personal'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Active application'), findsOneWidget);
    expect(find.text('Status: Under review'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('EMI calculator renders sliders and breakdown', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: EmiCalculatorScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('EMI Calculator'), findsOneWidget);
    expect(find.text('Loan amount'), findsOneWidget);
    expect(find.text('Rs. 5,00,000'), findsWidgets);
    expect(find.text('Tenure'), findsOneWidget);
    expect(find.text('60 months'), findsOneWidget);
    expect(find.text('Interest rate'), findsOneWidget);
    expect(find.text('9.5% p.a.'), findsOneWidget);
    expect(find.text('Monthly EMI'), findsOneWidget);
    expect(find.text('Principal'), findsOneWidget);
    expect(find.text('Total interest'), findsOneWidget);
    expect(find.text('Total payable'), findsOneWidget);
    expect(find.text('Apply for this loan'), findsOneWidget);
  });

  testWidgets('Application form starts with personal details validation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ApplicationFormScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(find.text('Personal details'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('DOB'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('PAN number'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
  });

  testWidgets('Document upload screen shows required documents', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: DocumentUploadScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('PAN card'), findsOneWidget);
    expect(find.text('Aadhaar card'), findsOneWidget);
    expect(find.text('Salary slips'), findsOneWidget);
    expect(find.text('Bank statement'), findsOneWidget);
    expect(find.text('Tap to upload PDF, JPG, or PNG'), findsNWidgets(4));
    expect(find.text('Submit application'), findsOneWidget);

    final submitButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Submit application'),
    );
    expect(submitButton.onPressed, isNull);
  });

  testWidgets('Application status screen shows timeline stages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ApplicationStatusScreen(applicationId: 'LN-2026-00482')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Application ID'), findsOneWidget);
    expect(find.text('LN-2026-00482'), findsOneWidget);
    expect(find.text('Application submitted'), findsOneWidget);
    expect(find.text('28 Jun 2026'), findsOneWidget);
    expect(find.text('Documents verified'), findsOneWidget);
    expect(find.text('29 Jun 2026'), findsOneWidget);
    expect(find.text('Credit assessment'), findsOneWidget);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Loan disbursed'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNWidgets(2));
  });
}
