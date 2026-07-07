import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/core/widgets/app_button.dart';
import 'package:finhub/features/loan/data/models/loan_status.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';
import 'package:finhub/features/loan/application/services/loan_service.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key, required this.applicationId});

  final String? applicationId;

  @override
  State<ApplicationStatusScreen> createState() =>
      _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  final LoanService _loanService = LoanService();
  late final Future<LoanStatus> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = _loadStatus();
  }

  Future<LoanStatus> _loadStatus() {
    final applicationId = widget.applicationId;
    if (applicationId == null || applicationId.isEmpty) {
      return Future.error('Missing loan application ID');
    }

    return _loanService.fetchApplicationStatus(
      AuthSession.instance.userId,
      applicationId,
      AuthSession.instance.bearerToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application status')),
      body: SafeArea(
        child: FutureBuilder<LoanStatus>(
          future: _statusFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'Unable to load application status.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }

            final status = snapshot.requireData;
            return ListView(
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
                        status.id,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${status.type} - ${status.status}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Upload documents',
                        onPressed: () => context.push(
                          Uri(
                            path: AppRoutes.documents,
                            queryParameters: {'applicationId': status.id},
                          ).toString(),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppButton(
                        label: 'View documents',
                        onPressed: () => context.push(
                          Uri(
                            path: AppRoutes.uploadedDocuments,
                            queryParameters: {'applicationId': status.id},
                          ).toString(),
                        ),
                        variant: AppButtonVariant.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Go to dashboard',
                  onPressed: () => context.go(AppRoutes.dashboard),
                  variant: AppButtonVariant.secondary,
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
                      for (var index = 0; index < status.stages.length; index++)
                        _TimelineRow(
                          stage: status.stages[index],
                          isLast: index == status.stages.length - 1,
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.stage, required this.isLast});

  final LoanStatusStage stage;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final status = _timelineStatusFromString(stage.status);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _TimelineIndicator(status: status),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: status == _TimelineStatus.pending
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
                      color: status == _TimelineStatus.pending
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _stageSubtitle(stage, status),
                    style: TextStyle(
                      color: status == _TimelineStatus.pending
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

String _stageSubtitle(LoanStatusStage stage, _TimelineStatus status) {
  if (stage.date != null) {
    final date = stage.date!;
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} ${date.year}';
  }

  switch (status) {
    case _TimelineStatus.done:
      return 'Completed';
    case _TimelineStatus.inProgress:
      return 'In progress';
    case _TimelineStatus.pending:
      return 'Pending';
  }
}

_TimelineStatus _timelineStatusFromString(String value) {
  switch (value.toLowerCase()) {
    case 'done':
      return _TimelineStatus.done;
    case 'inprogress':
    case 'in_progress':
    case 'in progress':
      return _TimelineStatus.inProgress;
    default:
      return _TimelineStatus.pending;
  }
}

String _monthName(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[month - 1];
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
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.surface, size: 18),
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

enum _TimelineStatus { done, inProgress, pending }
