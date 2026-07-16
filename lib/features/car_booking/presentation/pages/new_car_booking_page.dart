import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_form_controls.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/car_booking/presentation/providers/car_booking_provider.dart';

/// Form page for creating a new car rental booking.
class NewCarBookingPage extends ConsumerStatefulWidget {
  const NewCarBookingPage({super.key});

  @override
  ConsumerState<NewCarBookingPage> createState() => _NewCarBookingPageState();
}

class _NewCarBookingPageState extends ConsumerState<NewCarBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  String? _vehicleId;
  DateTime? _pickupDate;
  DateTime? _returnDate;
  bool _submitting = false;

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(carBookingProvider);
    return asyncState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('New booking')),
        body: Center(child: Text(error.toString())),
      ),
      data: _buildForm,
    );
  }

  Widget _buildForm(CarBookingState bookingState) {
    final vehicles = bookingState.vehicles;
    final availableVehicles =
        vehicles.where((vehicle) => vehicle.isAvailable).toList();
    if (_vehicleId == null ||
        !availableVehicles.any((vehicle) => vehicle.id == _vehicleId)) {
      _vehicleId = availableVehicles.isNotEmpty ? availableVehicles.first.id : null;
    }
    final selectedVehicle = _vehicleId == null
        ? null
        : availableVehicles.firstWhere((vehicle) => vehicle.id == _vehicleId);
    final days = _bookingDays;
    final amount = (selectedVehicle?.dailyRate ?? 0) * days;

    return Scaffold(
      appBar: AppBar(title: const Text('New booking')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AppFieldLabel(label: 'Customer name'),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _customerController,
                hintText: 'Enter customer name',
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppFieldLabel(label: 'Vehicle'),
              const SizedBox(height: AppSpacing.xs),
              AppDropdownField<String>(
                label: null,
                value: _vehicleId,
                items: availableVehicles.map((vehicle) => vehicle.id).toList(),
                itemLabel: (id) {
                  final vehicle = availableVehicles.firstWhere(
                    (vehicle) => vehicle.id == id,
                  );
                  return '${vehicle.model} - ${vehicle.registrationNumber} - '
                      'Rs. ${vehicle.dailyRate.toStringAsFixed(0)}/day';
                },
                decoration: AppFormDecorations.filled(),
                style: AppTextStyles.bodyLarge(context),
                hint: const Text('No available vehicles'),
                bottomSpacing: 0,
                onChanged: (value) => setState(() => _vehicleId = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppFieldLabel(label: 'Pickup date'),
              const SizedBox(height: AppSpacing.xs),
              AppDateDisplayTile(
                date: _pickupDate,
                onTap: () => _pickDate(isPickup: true),
                formatDate: _formatDate,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppFieldLabel(label: 'Return date'),
              const SizedBox(height: AppSpacing.xs),
              AppDateDisplayTile(
                date: _returnDate,
                onTap: () => _pickDate(isPickup: false),
                formatDate: _formatDate,
              ),
              const SizedBox(height: AppSpacing.lg),
              _AmountBanner(days: days, amount: amount),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: _submitting ? 'Creating booking...' : 'Confirm booking',
                icon: Icons.check_rounded,
                enabled: availableVehicles.isNotEmpty && !_submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _bookingDays {
    final pickup = _pickupDate;
    final returns = _returnDate;
    if (pickup == null || returns == null || returns.isBefore(pickup)) {
      return 0;
    }
    return returns.difference(pickup).inDays + 1;
  }

  Future<void> _pickDate({required bool isPickup}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isPickup ? (_pickupDate ?? now) : (_returnDate ?? _pickupDate ?? now),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(picked)) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final pickup = _pickupDate;
    final returns = _returnDate;
    final vehicleId = _vehicleId;
    if (pickup == null ||
        returns == null ||
        vehicleId == null ||
        _bookingDays == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select valid booking dates.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(carBookingProvider.notifier).createBooking(
            vehicleId: vehicleId,
            customerName: _customerController.text.trim(),
            startDate: pickup,
            endDate: returns,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required'
        : null;
  }
}

class _AmountBanner extends StatelessWidget {
  const _AmountBanner({required this.days, required this.amount});

  final int days;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$days days',
              style: AppTextStyles.titleMedium(context).copyWith(
                color: AppColors.success,
              ),
            ),
          ),
          Text(
            'Rs. ${amount.toStringAsFixed(0)}',
            style: AppTextStyles.titleLarge(context).copyWith(
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day-$month-${date.year}';
}

