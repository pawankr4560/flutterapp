import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/loan_application.dart';

class ApplicationStatusScreen extends StatelessWidget {
  const ApplicationStatusScreen({super.key});

  static const LoanApplication _application = LoanApplication(
    id: 'LN-2026-00482',
    type: 'Personal Loan',
    amount: 800000,
    status: 'Under review',
    stepsCompleted: 2,
  );

  static const List<_TimelineStage> _stages = [
    _TimelineStage(
      title: 'Application submitted',
      status: _TimelineStatus.done,
      date: '28 Jun 2026',
    ),
    _TimelineStage(
      title: 'Documents verified',
      status: _TimelineStatus.done,
      date: '29 Jun 2026',
    ),
    _TimelineStage(
      title: 'Credit assessment',
      status: _TimelineStatus.inProgress,
    ),
    _TimelineStage(
      title: 'Loan disbursed',
      status: _TimelineStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application status')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application ID',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _application.id,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${_application.type} - ${_application.status}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Progress timeline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  for (var index = 0; index < _stages.length; index++)
                    _TimelineRow(
                      stage: _stages[index],
                      isLast: index == _stages.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.stage,
    required this.isLast,
  });

  final _TimelineStage stage;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _TimelineIndicator(status: stage.status),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: stage.status == _TimelineStatus.pending
                        ? AppColors.surfaceMuted
                        : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.title,
                    style: TextStyle(
                      color: stage.status == _TimelineStatus.pending
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    stage.subtitle,
                    style: TextStyle(
                      color: stage.status == _TimelineStatus.pending
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  const _TimelineIndicator({required this.status});

  final _TimelineStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _TimelineStatus.done:
        return Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: _successGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        );
      case _TimelineStatus.inProgress:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case _TimelineStatus.pending:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
        );
    }
  }
}

class _TimelineStage {
  const _TimelineStage({
    required this.title,
    required this.status,
    this.date,
  });

  final String title;
  final _TimelineStatus status;
  final String? date;

  String get subtitle {
    switch (status) {
      case _TimelineStatus.done:
        return date ?? 'Completed';
      case _TimelineStatus.inProgress:
        return 'In progress';
      case _TimelineStatus.pending:
        return 'Pending';
    }
  }
}

enum _TimelineStatus {
  done,
  inProgress,
  pending,
}

const Color _successGreen = Color(0xFF16A34A);
