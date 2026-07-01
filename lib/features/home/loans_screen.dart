import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../features/home/loan_offer_card.dart';
import '../../features/home/active_applications_section.dart';
import '../../models/loan_application.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  static const List<_LoanOffer> _offers = [
    _LoanOffer(
      title: 'Pre-approved personal loan',
      amountLabel: 'Up to ₹5,00,000',
      interestRateLabel: 'Interest rate from 9.75% p.a.',
      description: 'Fast approval with flexible repayment options.',
    ),
    _LoanOffer(
      title: 'Home renovation loan',
      amountLabel: 'Up to ₹10,00,000',
      interestRateLabel: 'Interest rate from 8.95% p.a.',
      description: 'Low EMI plans for home improvement.',
    ),
  ];

  static const List<LoanApplication> _applications = [
    LoanApplication(
      id: 'LN-2026-00211',
      type: 'Personal',
      amount: 245000,
      status: 'Under review',
      stepsCompleted: 2,
      submittedDate: null,
    ),
    LoanApplication(
      id: 'LN-2026-00174',
      type: 'Home',
      amount: 680000,
      status: 'Documents verified',
      stepsCompleted: 3,
      submittedDate: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Loan offers',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.lg),
            ..._offers.map(
              (offer) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: LoanOfferCard(
                  amountLabel: offer.amountLabel,
                  interestRateLabel: offer.interestRateLabel,
                  onApply: () => context.push('/apply'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Your applications',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.lg),
            ActiveApplicationsSection(
              applications: _applications,
              onViewAll: () {},
              onApplicationTap: (applicationId) => context.push(
                '/status?applicationId=$applicationId',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'View all applications',
              onPressed: () => _showAllApplications(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllApplications(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All applications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              for (var application in _applications)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    title: Text(application.type),
                    subtitle: Text('ID: ${application.id} • ${application.status}'),
                    trailing: Text('₹${application.amount.toStringAsFixed(0)}'),
                    onTap: () => context.push(
                      '/status?applicationId=${application.id}',
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoanOffer {
  const _LoanOffer({
    required this.title,
    required this.amountLabel,
    required this.interestRateLabel,
    required this.description,
  });

  final String title;
  final String amountLabel;
  final String interestRateLabel;
  final String description;
}
