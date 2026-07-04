import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/car_booking/domain/entities/car_booking.dart';
import 'package:finhub/features/car_booking/domain/entities/vehicle.dart';
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

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(carBookingProvider).vehicles;
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
              _FieldLabel(label: 'Customer name'),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _customerController,
                hintText: 'Enter customer name',
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel(label: 'Vehicle'),
              const SizedBox(height: AppSpacing.xs),
              _VehicleDropdown(
                value: _vehicleId,
                vehicles: availableVehicles,
                onChanged: (value) => setState(() => _vehicleId = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel(label: 'Pickup date'),
              const SizedBox(height: AppSpacing.xs),
              _DatePickerTile(
                date: _pickupDate,
                onTap: () => _pickDate(isPickup: true),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel(label: 'Return date'),
              const SizedBox(height: AppSpacing.xs),
              _DatePickerTile(
                date: _returnDate,
                onTap: () => _pickDate(isPickup: false),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AmountBanner(days: days, amount: amount),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Confirm booking',
                icon: Icons.check_rounded,
                enabled: availableVehicles.isNotEmpty,
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

  void _submit() {
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

    final vehicle = ref
        .read(carBookingProvider)
        .vehicles
        .firstWhere((item) => item.id == vehicleId);
    final booking = CarBooking(
      id: 'booking-${DateTime.now().microsecondsSinceEpoch}',
      customerName: _customerController.text.trim(),
      carModel: vehicle.model,
      registrationNumber: vehicle.registrationNumber,
      startDate: pickup,
      endDate: returns,
      dailyRate: vehicle.dailyRate,
      status: 'Upcoming',
    );
    ref.read(carBookingProvider.notifier).addBooking(booking);
    Navigator.of(context).pop();
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required'
        : null;
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodyLarge(context).copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _VehicleDropdown extends StatelessWidget {
  const _VehicleDropdown({
    required this.value,
    required this.vehicles,
    required this.onChanged,
  });

  final String? value;
  final List<Vehicle> vehicles;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _inputDecoration(),
      style: AppTextStyles.bodyLarge(context),
      hint: const Text('No available vehicles'),
      items: [
        for (final vehicle in vehicles)
          DropdownMenuItem(
            value: vehicle.id,
            child: Text(
              '${vehicle.model} - ${vehicle.registrationNumber} - '
              'Rs. ${vehicle.dailyRate.toStringAsFixed(0)}/day',
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.large),
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecoration(
          suffixIcon: const Icon(Icons.calendar_month_rounded),
        ),
        child: Text(
          date == null ? 'dd-mm-yyyy' : _formatDate(date!),
          style: AppTextStyles.bodyLarge(context).copyWith(
            color: date == null ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
      ),
    );
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

InputDecoration _inputDecoration({Widget? suffixIcon}) {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    suffixIcon: suffixIcon,
    border: _border(AppColors.border),
    enabledBorder: _border(AppColors.border),
    focusedBorder: _border(AppColors.primary),
  );
}

OutlineInputBorder _border(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.large),
    borderSide: BorderSide(color: color),
  );
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day-$month-${date.year}';
}
