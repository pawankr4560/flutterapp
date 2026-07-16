import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/car_booking/domain/entities/car_booking.dart';
import 'package:finhub/features/car_booking/presentation/pages/new_car_booking_page.dart';
import 'package:finhub/features/car_booking/presentation/providers/car_booking_provider.dart';
import 'package:finhub/features/car_booking/presentation/widgets/car_booking_card.dart';

/// Directory page for car rental fleet and bookings.
class CarBookingDirectoryPage extends ConsumerStatefulWidget {
  const CarBookingDirectoryPage({super.key});

  @override
  ConsumerState<CarBookingDirectoryPage> createState() =>
      _CarBookingDirectoryPageState();
}

class _CarBookingDirectoryPageState
    extends ConsumerState<CarBookingDirectoryPage> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(carBookingProvider);
    return asyncState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Car Booking Directory')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge(context),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () =>
                      ref.read(carBookingProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(CarBookingState state) {
    final vehicles = _selectedStatus == 'All'
        ? state.vehicles
        : state.vehicles
            .where((vehicle) => vehicle.status == _selectedStatus)
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Car Booking Directory')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Vehicle fleet', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.md),
            _FleetFilters(
              selectedStatus: _selectedStatus,
              onChanged: (status) => setState(() => _selectedStatus = status),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'New booking',
                    icon: Icons.add_rounded,
                    isPrimary: true,
                    onTap: _openNewBooking,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ActionButton(
                    label: 'Active bookings',
                    icon: Icons.event_note_rounded,
                    onTap: () => _openActiveBookings(state.bookings),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (vehicles.isEmpty)
              _EmptyFleet(status: _selectedStatus)
            else
              for (final vehicle in vehicles) ...[
                CarBookingCard(vehicle: vehicle),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }

  void _openNewBooking() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NewCarBookingPage()),
    );
  }

  void _openActiveBookings(List<CarBooking> bookings) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActiveBookingsPage(bookings: bookings),
      ),
    );
  }
}

/// Active booking list for car rentals.
class ActiveBookingsPage extends StatelessWidget {
  const ActiveBookingsPage({super.key, required this.bookings});

  final List<CarBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active bookings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Active bookings', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.lg),
            for (final booking in bookings) ...[
              _BookingTile(booking: booking),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _FleetFilters extends StatelessWidget {
  const _FleetFilters({required this.selectedStatus, required this.onChanged});

  final String selectedStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final status in const [
            'All',
            'Available',
            'Booked',
            'Maintenance',
          ]) ...[
            ChoiceChip(
              label: Text(status),
              selected: selectedStatus == status,
              onSelected: (_) => onChanged(status),
              labelStyle: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              selectedColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.xxl,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.surface,
          foregroundColor: isPrimary ? AppColors.surface : AppColors.primary,
          side: BorderSide(
            color: isPrimary ? AppColors.primary : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: AppTextStyles.labelLarge(context),
        ),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking});

  final CarBooking booking;

  @override
  Widget build(BuildContext context) {
    final color = switch (booking.status) {
      'Ongoing' => AppColors.primary,
      'Upcoming' => AppColors.warning,
      'Completed' => AppColors.textSecondary,
      _ => AppColors.success,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${booking.carModel} - ${booking.customerName}',
                  style: AppTextStyles.titleMedium(context),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${_formatDate(booking.startDate)} - '
                  '${_formatDate(booking.endDate)} - '
                  'Rs. ${booking.totalAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _StatusBadge(label: booking.status, color: color),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: label == 'Completed' ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(context).copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyFleet extends StatelessWidget {
  const _EmptyFleet({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'No $status vehicles found.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLarge(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day} ${_monthName(date.month)}';
}

String _monthName(int month) {
  const months = [
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
  return months[month - 1];
}
