import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/features/auth/application/services/auth_session.dart';
import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/core/widgets/app_button.dart';
import 'package:finhub/features/loan/data/models/loan_application.dart';
import 'package:finhub/features/dashboard/presentation/widgets/active_applications_section.dart';
import 'package:finhub/features/dashboard/presentation/widgets/loan_offer_card.dart';
import 'package:finhub/features/loan/application/services/loan_service.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  final LoanService _loanService = LoanService();
  late Future<List<LoanApplication>> _applicationsFuture;

  static const List<_LoanOffer> _offers = [
    _LoanOffer(
      title: 'Pre-approved personal loan',
      amountLabel: 'Up to Rs. 5,00,000',
      interestRateLabel: 'Interest rate from 9.75% p.a.',
    ),
    _LoanOffer(
      title: 'Home renovation loan',
      amountLabel: 'Up to Rs. 10,00,000',
      interestRateLabel: 'Interest rate from 8.95% p.a.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _applicationsFuture = _loadApplications();
  }

  Future<List<LoanApplication>> _loadApplications() {
    return _loanService.fetchApplications(
      AuthSession.instance.userId,
      AuthSession.instance.bearerToken,
    );
  }

  void _retryLoadApplications() {
    setState(() {
      _applicationsFuture = _loadApplications();
    });
  }

  void _openStatus(String applicationId) {
    context.push(
      Uri(
        path: AppRoutes.status,
        queryParameters: {'applicationId': applicationId},
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      body: SafeArea(
        child: FutureBuilder<List<LoanApplication>>(
          future: _applicationsFuture,
          builder: (context, snapshot) {
            final applications = snapshot.data ?? const <LoanApplication>[];

            return RefreshIndicator(
              onRefresh: () async {
                _retryLoadApplications();
                await _applicationsFuture;
              },
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
                        onApply: () => context.push(AppRoutes.apply),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Your applications',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Refresh',
                        onPressed: _retryLoadApplications,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (snapshot.hasError)
                    _ApplicationsError(onRetry: _retryLoadApplications)
                  else if (applications.isEmpty)
                    const _NoApplications()
                  else ...[
                    ActiveApplicationsSection(
                      applications: applications,
                      onViewAll: () => _showAllApplications(applications),
                      onApplicationTap: _openStatus,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'View all applications',
                      onPressed: () => _showAllApplications(applications),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAllApplications(List<LoanApplication> applications) {
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
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: applications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      title: Text(application.type),
                      subtitle: Text('ID: ${application.id} | ${application.status}'),
                      trailing: Text('Rs. ${application.amount.toStringAsFixed(0)}'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _openStatus(application.id);
                      },
                    );
                  },
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

class _ApplicationsError extends StatelessWidget {
  const _ApplicationsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Unable to load applications.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: 'Retry', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _NoApplications extends StatelessWidget {
  const _NoApplications();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.assignment_outlined,
            color: AppColors.accent,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No applications yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Apply for a loan to track its status here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Apply now',
            onPressed: () => context.push(AppRoutes.apply),
          ),
        ],
      ),
    );
  }
}

class _LoanOffer {
  const _LoanOffer({
    required this.title,
    required this.amountLabel,
    required this.interestRateLabel,
  });

  final String title;
  final String amountLabel;
  final String interestRateLabel;
}



