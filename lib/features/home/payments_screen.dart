import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../models/payment_record.dart';
import 'payment_service.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final PaymentService _paymentService = PaymentService();
  late Future<PaymentOverview> _paymentsFuture;
  bool _isStartingPayment = false;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _loadPayments();
  }

  Future<PaymentOverview> _loadPayments() {
    return _paymentService.fetchPayments(
      userId: AuthSession.instance.userId,
      bearerToken: AuthSession.instance.bearerToken,
    );
  }

  void _retryLoadPayments() {
    setState(() {
      _paymentsFuture = _loadPayments();
    });
  }

  Future<void> _payNextEmi(PaymentRecord payment) async {
    setState(() {
      _isStartingPayment = true;
    });

    try {
      final session = await _paymentService.initiateRazorpayPayment(
        userId: AuthSession.instance.userId,
        bearerToken: AuthSession.instance.bearerToken,
        payment: payment,
      );
      final uri = Uri.parse(session.checkoutUrl);
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open Razorpay checkout.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isStartingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: SafeArea(
        child: FutureBuilder<PaymentOverview>(
          future: _paymentsFuture,
          builder: (context, snapshot) {
            return RefreshIndicator(
              onRefresh: () async {
                _retryLoadPayments();
                await _paymentsFuture;
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Payment overview',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Refresh',
                        onPressed: _retryLoadPayments,
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
                    _PaymentsError(onRetry: _retryLoadPayments)
                  else
                    _PaymentsContent(
                      overview: snapshot.requireData,
                      isStartingPayment: _isStartingPayment,
                      onPayNextEmi: _payNextEmi,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PaymentsContent extends StatelessWidget {
  const _PaymentsContent({
    required this.overview,
    required this.isStartingPayment,
    required this.onPayNextEmi,
  });

  final PaymentOverview overview;
  final bool isStartingPayment;
  final void Function(PaymentRecord payment) onPayNextEmi;

  @override
  Widget build(BuildContext context) {
    final nextDuePayment = overview.nextDuePayment;
    final canPay = nextDuePayment != null && nextDuePayment.canInitiatePayment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NextDuePaymentCard(payment: nextDuePayment),
        const SizedBox(height: AppSpacing.xl),
        const Text(
          'Recent payments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        if (overview.payments.isEmpty)
          const _NoPayments()
        else
          ...overview.payments.map(
            (payment) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _PaymentCard(payment: payment),
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: isStartingPayment ? 'Opening Razorpay...' : 'Pay next EMI',
          onPressed: !canPay
              ? null
              : isStartingPayment
                  ? null
                  : () => onPayNextEmi(nextDuePayment),
        ),
      ],
    );
  }
}

class _NextDuePaymentCard extends StatelessWidget {
  const _NextDuePaymentCard({required this.payment});

  final PaymentRecord? payment;

  @override
  Widget build(BuildContext context) {
    final dueDate = payment?.dueDate ?? payment?.date;
    final dueLabel = dueDate == null ? 'No due date available' : 'Due ${_formatDate(dueDate)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Next due payment',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            payment == null ? 'No pending payment' : _formatAmount(payment!.amount),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            payment == null ? 'You are all caught up.' : dueLabel,
            style: const TextStyle(fontSize: 14, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final PaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: payment.isCompleted ? _successSurface : AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              payment.isCompleted ? Icons.check : Icons.schedule,
              color: payment.isCompleted ? _successGreen : AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  payment.displayDate == null
                      ? 'Date not available'
                      : _formatDate(payment.displayDate!),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                if (payment.applicationId != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Application ID: ${payment.applicationId}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
                if (payment.loanId != null && payment.scheduleId != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Loan ${payment.loanId} | Schedule ${payment.scheduleId}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(payment.amount),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                payment.status.isEmpty ? 'Unknown' : payment.status,
                style: TextStyle(
                  color: payment.isCompleted ? _successGreen : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentsError extends StatelessWidget {
  const _PaymentsError({required this.onRetry});

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
            'Unable to load payments.',
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

class _NoPayments extends StatelessWidget {
  const _NoPayments();

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
          const Icon(Icons.payment_outlined, color: AppColors.accent, size: 40),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No payments yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your payment history will appear here once repayments begin.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

String _formatAmount(double amount) {
  return 'Rs. ${amount.toStringAsFixed(0)}';
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')} '
      '${_monthName(date.month)} ${date.year}';
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

const Color _successGreen = Color(0xFF16A34A);
const Color _successSurface = Color(0xFFEFFAF3);
