import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/emi_summary.dart';
import '../../models/loan_application.dart';
import '../application/loan_service.dart';
import 'active_applications_section.dart';
import 'emi_summary_card.dart';
import 'empty_loan_state.dart';
import 'loan_offer_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const bool _hasPreApprovedOffer = true;
  static const String _userId = 'd853e508-a345-46aa-8aee-552a3329afaa';
  static const String _bearerToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InBhd2FuQGdtYWlsLmNvbSIsIkVtYWlsIjoicGF3YW5AZ21haWwuY29tIiwiSWQiOiJkODUzZTUwOC1hMzQ1LTQ2YWEtOGFlZS01NTJhMzMyOWFmYWEiLCJQaG9uZSI6IjQ3MjM5Mjc5Mjc4MzkyMzgiLCJGaXJzdE5hbWUiOiJQYXdhbiIsIkxhc3ROYW1lIjoiS3VtYWFIciIsIkh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJleHAiOjE3ODI5MzYwNjksImlzcyI6ImxvY2FsaG9zdCIsImF1ZCI6ImxvY2FsaG9zdCJ9.xuazIu5sXyatxU6pTelDaJqNcfTix55PHd4G8EdbUbU';

  static final EmiSummary _emiSummary = EmiSummary(
    amount: 15400,
    dueDate: DateTime.now().add(const Duration(days: 8)),
  );

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LoanService _loanService = LoanService();
  late final Future<List<LoanApplication>> _applicationsFuture;

  @override
  void initState() {
    super.initState();
    _applicationsFuture = _loanService.fetchApplications(
      DashboardScreen._userId,
      DashboardScreen._bearerToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 18),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<LoanApplication>>(
          future: _applicationsFuture,
          builder: (context, snapshot) {
            final applications = snapshot.data ?? const [];
            final hasApplications = applications.isNotEmpty;
            final hasOffers = DashboardScreen._hasPreApprovedOffer || hasApplications;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const _GreetingHeader(userName: 'Aarav'),
                const SizedBox(height: AppSpacing.lg),
                if (hasOffers) ...[
                  LoanOfferCard(
                    amountLabel: 'Up to ₹8,00,000',
                    interestRateLabel: 'Interest rate from 9.25% p.a.',
                    onApply: () => context.push(AppRoutePaths.apply),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  EmiSummaryCard(summary: DashboardScreen._emiSummary),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionTitle(title: 'Choose loan type'),
                  const SizedBox(height: AppSpacing.md),
                  const _LoanTypeGrid(),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionTitle(title: 'Active applications'),
                  const SizedBox(height: AppSpacing.md),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(child: CircularProgressIndicator())
                  else if (hasApplications)
                    ActiveApplicationsSection(
                      applications: applications,
                      onViewAll: () {},
                      onApplicationTap: (applicationId) => context.push(
                        '${AppRoutePaths.status}?applicationId=$applicationId',
                      ),
                    )
                  else
                    const Text('No active applications yet.'),
                ] else ...[
                  const EmptyLoanState(onBrowseTypes: _browseLoanTypes),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  static void _browseLoanTypes() {}
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.userName});

  final String userName;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          userName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _LoanTypeGrid extends StatelessWidget {
  const _LoanTypeGrid();

  static const List<_LoanType> _loanTypes = [
    _LoanType('Home', Icons.home_outlined),
    _LoanType('Auto', Icons.directions_car_outlined),
    _LoanType('Personal', Icons.person_outline),
    _LoanType('Education', Icons.school_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _loanTypes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final loanType = _loanTypes[index];

        return _LoanTypeCard(loanType: loanType);
      },
    );
  }
}

class _LoanTypeCard extends StatelessWidget {
  const _LoanTypeCard({required this.loanType});

  final _LoanType loanType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => context.push('/apply'),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(loanType.icon, color: AppColors.accent),
              ),
              Text(
                loanType.label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoanType {
  const _LoanType(this.label, this.icon);

  final String label;
  final IconData icon;
}
