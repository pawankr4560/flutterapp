import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/plot/presentation/widgets/plot_listing_card.dart';

typedef _PlotData = ({
  String id,
  String title,
  String location,
  String area,
  String price,
  String status,
  String propertyType,
  String roadWidth,
  String electricity,
  String water,
  String registration,
  String description,
  String sellerName,
  String sellerPhone,
  List<String> images,
  List<String> amenities,
});

typedef _VisitData = ({
  String propertyName,
  String date,
  String time,
  String status,
  String imageUrl,
});

class PlotDirectoryPage extends StatefulWidget {
  const PlotDirectoryPage({super.key});

  @override
  State<PlotDirectoryPage> createState() => _PlotDirectoryPageState();
}

class _PlotDirectoryPageState extends State<PlotDirectoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = 'Location';
  bool _isGrid = false;

  static final List<_PlotData> _plots = [
    (
      id: 'green-valley-a12',
      title: 'Green Valley Premium Plot',
      location: 'Indore Bypass, Madhya Pradesh',
      area: '1,500 sq.ft',
      price: 'Rs. 42.5L',
      status: 'Available',
      propertyType: 'Residential Plot',
      roadWidth: '30 ft',
      electricity: 'Available',
      water: 'Borewell + municipal line',
      registration: 'RERA verified',
      description:
          'A well-planned residential plot inside a gated community with wide internal roads, street lighting, and strong connectivity to schools, hospitals, and the city bypass.',
      sellerName: 'Amit Verma',
      sellerPhone: '+91 98765 43210',
      images: [
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Gated', 'Road', 'Water', 'Electricity'],
    ),
    (
      id: 'lakeview-c03',
      title: 'Lakeview Corner Plot',
      location: 'Rau Road, Indore',
      area: '1,800 sq.ft',
      price: 'Rs. 58L',
      status: 'Booked',
      propertyType: 'Corner Plot',
      roadWidth: '40 ft',
      electricity: 'Available',
      water: 'Municipal line',
      registration: 'Registry ready',
      description:
          'Corner-facing plot with lake approach road, premium frontage, and a peaceful residential neighborhood suited for a spacious family home.',
      sellerName: 'Neha Sharma',
      sellerPhone: '+91 91234 56780',
      images: [
        'https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Corner', 'Park', 'Water', 'Security'],
    ),
    (
      id: 'sunrise-b07',
      title: 'Sunrise Enclave Plot',
      location: 'Ujjain Road, Indore',
      area: '1,200 sq.ft',
      price: 'Rs. 31.8L',
      status: 'Available',
      propertyType: 'Residential Plot',
      roadWidth: '25 ft',
      electricity: 'Available',
      water: 'Borewell',
      registration: 'Clear title',
      description:
          'Budget-friendly plot in a fast-growing corridor with clean title, nearby public transport, and reliable access to basic civic amenities.',
      sellerName: 'Rohit Jain',
      sellerPhone: '+91 99887 76655',
      images: [
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Loan', 'Road', 'School', 'Drainage'],
    ),
    (
      id: 'royal-heights-d18',
      title: 'Royal Heights East Facing',
      location: 'Super Corridor, Indore',
      area: '2,400 sq.ft',
      price: 'Rs. 82L',
      status: 'Sold',
      propertyType: 'Villa Plot',
      roadWidth: '45 ft',
      electricity: 'Underground cabling',
      water: 'Dual water connection',
      registration: 'Registered',
      description:
          'Large east-facing plot in a premium address with wide roads, landscaped open spaces, and quick access to commercial hubs.',
      sellerName: 'Karan Malhotra',
      sellerPhone: '+91 90909 11223',
      images: [
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Premium', 'Club', 'Park', 'Security'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlots = _plots.where((plot) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return plot.title.toLowerCase().contains(query) ||
          plot.location.toLowerCase().contains(query) ||
          plot.area.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plot Purchase'),
        actions: [
          IconButton(
            tooltip: 'Saved plots',
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () => _push(context, _SavedPlotsScreen(plots: _plots)),
          ),
          IconButton(
            tooltip: 'My visits',
            icon: const Icon(Icons.event_note_rounded),
            onPressed: () => _push(context, const MyVisitsScreen()),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 720;
            final crossAxisCount = constraints.maxWidth >= 980 ? 3 : 2;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                PlotSearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: FilterChipRow(
                        filters: const [
                          'Location',
                          'Budget',
                          'Area',
                          'Property Type',
                        ],
                        selectedFilter: _selectedFilter,
                        onSelected: (value) {
                          setState(() => _selectedFilter = value);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SegmentedButton<bool>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: false,
                          icon: Icon(Icons.view_agenda_rounded),
                        ),
                        ButtonSegment(
                          value: true,
                          icon: Icon(Icons.grid_view_rounded),
                        ),
                      ],
                      selected: {_isGrid},
                      onSelectionChanged: (value) {
                        setState(() => _isGrid = value.first);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _ListingHeader(count: filteredPlots.length),
                const SizedBox(height: AppSpacing.md),
                if (filteredPlots.isEmpty)
                  const PlotEmptyStateWidget(
                    title: 'No plots found',
                    message: 'Try a different search or filter combination.',
                  )
                else if (_isGrid || isTablet)
                  GridView.builder(
                    itemCount: filteredPlots.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: constraints.maxWidth >= 980
                          ? 0.78
                          : 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final plot = filteredPlots[index];
                      return _PlotCardFromData(
                        plot: plot,
                        isCompact: true,
                        onViewDetails: () => _openDetails(plot),
                      );
                    },
                  )
                else
                  for (final plot in filteredPlots) ...[
                    _PlotCardFromData(
                      plot: plot,
                      onViewDetails: () => _openDetails(plot),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _openDetails(_PlotData plot) {
    _push(context, _PlotDetailsScreen(plot: plot));
  }
}

class _PlotDetailsScreen extends StatelessWidget {
  const _PlotDetailsScreen({required this.plot});

  final _PlotData plot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                PlotImageCarousel(
                  heroTag: plot.id,
                  images: plot.images,
                  height: 340,
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
                  left: AppSpacing.md,
                  child: _FloatingButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
                  right: AppSpacing.md,
                  child: Row(
                    children: [
                      _FloatingButton(
                        icon: Icons.favorite_border_rounded,
                        onPressed: () {},
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _FloatingButton(
                        icon: Icons.share_outlined,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.xxl,
            ),
            sliver: SliverList.list(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        plot.title,
                        style: AppTextStyles.headlineMedium(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    StatusBadge(label: plot.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    PriceTag(price: plot.price),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        plot.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Description', style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  plot.description,
                  style: AppTextStyles.bodyMedium(context),
                ),
                const SizedBox(height: AppSpacing.lg),
                _InfoGrid(plot: plot),
                const SizedBox(height: AppSpacing.lg),
                Text('Amenities', style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.md),
                _AmenitiesGrid(amenities: plot.amenities),
                const SizedBox(height: AppSpacing.lg),
                Text('Location Map', style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.md),
                const _MapPlaceholder(),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Seller Information',
                  style: AppTextStyles.titleMedium(context),
                ),
                const SizedBox(height: AppSpacing.md),
                SellerCard(
                  name: plot.sellerName,
                  phone: plot.sellerPhone,
                  onCall: () {},
                  onWhatsApp: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border_rounded),
                label: const Text('Save'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: PlotPrimaryButton(
                label: 'Book Site Visit',
                icon: Icons.calendar_month_rounded,
                onPressed: () => _push(context, _BookVisitScreen(plot: plot)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookVisitScreen extends StatefulWidget {
  const _BookVisitScreen({required this.plot});

  final _PlotData plot;

  @override
  State<_BookVisitScreen> createState() => _BookVisitScreenState();
}

class _BookVisitScreenState extends State<_BookVisitScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _remarksController = TextEditingController();
  DateTime? _visitDate;
  TimeOfDay? _visitTime;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Site Visit')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _VisitHero(plot: widget.plot),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.call_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                labelText: 'Visit Date',
                prefixIcon: const Icon(Icons.calendar_today_rounded),
                hintText: _visitDate == null ? null : _formatDate(_visitDate!),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              readOnly: true,
              onTap: _pickTime,
              decoration: InputDecoration(
                labelText: 'Visit Time',
                prefixIcon: const Icon(Icons.schedule_rounded),
                hintText: _visitTime?.format(context),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _remarksController,
              minLines: 4,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Remarks',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PlotPrimaryButton(
              label: 'Book Visit',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _showSuccessDialog,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 45)),
      initialDate: _visitDate ?? now,
    );
    if (picked != null) {
      setState(() => _visitDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _visitTime ?? const TimeOfDay(hour: 11, minute: 0),
    );
    if (picked != null) {
      setState(() => _visitTime = picked);
    }
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
          ),
          title: const Text('Visit Booked'),
          content: Text(
            'Your site visit for ${widget.plot.title} has been booked successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

class _SavedPlotsScreen extends StatelessWidget {
  const _SavedPlotsScreen({required this.plots});

  final List<_PlotData> plots;

  @override
  Widget build(BuildContext context) {
    final savedPlots = plots.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Plots')),
      body: SafeArea(
        child: savedPlots.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: PlotEmptyStateWidget(
                  title: 'No saved plots',
                  message: 'Saved properties will appear here.',
                  icon: Icons.favorite_border_rounded,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemBuilder: (context, index) {
                  final plot = savedPlots[index];
                  return _SavedPlotCard(plot: plot);
                },
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemCount: savedPlots.length,
              ),
      ),
    );
  }
}

class MyVisitsScreen extends StatelessWidget {
  const MyVisitsScreen({super.key});

  static final List<_VisitData> _visits = [
    (
      propertyName: 'Green Valley Premium Plot',
      date: '08 Jul 2026',
      time: '11:00 AM',
      status: 'Pending',
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=600&q=80',
    ),
    (
      propertyName: 'Lakeview Corner Plot',
      date: '09 Jul 2026',
      time: '04:30 PM',
      status: 'Confirmed',
      imageUrl:
          'https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=600&q=80',
    ),
    (
      propertyName: 'Sunrise Enclave Plot',
      date: '03 Jul 2026',
      time: '10:15 AM',
      status: 'Completed',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=600&q=80',
    ),
    (
      propertyName: 'Royal Heights East Facing',
      date: '02 Jul 2026',
      time: '02:00 PM',
      status: 'Cancelled',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=600&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Visits')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemBuilder: (context, index) {
            final visit = _visits[index];
            return VisitCard(
              imageUrl: visit.imageUrl,
              propertyName: visit.propertyName,
              date: visit.date,
              time: visit.time,
              status: visit.status,
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemCount: _visits.length,
        ),
      ),
    );
  }
}

class _PlotCardFromData extends StatelessWidget {
  const _PlotCardFromData({
    required this.plot,
    required this.onViewDetails,
    this.isCompact = false,
  });

  final _PlotData plot;
  final VoidCallback onViewDetails;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return PlotCard(
      heroTag: plot.id,
      imageUrl: plot.images.first,
      title: plot.title,
      location: plot.location,
      area: plot.area,
      price: plot.price,
      status: plot.status,
      amenities: plot.amenities,
      isCompact: isCompact,
      onFavorite: () {},
      onViewDetails: onViewDetails,
    );
  }
}

class _ListingHeader extends StatelessWidget {
  const _ListingHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended Plots',
                style: AppTextStyles.titleLarge(context),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '$count verified options near you',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            'SmartSathi',
            style: AppTextStyles.bodySmall(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.plot});

  final _PlotData plot;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.square_foot_rounded, 'Area', plot.area),
      (Icons.home_work_outlined, 'Property Type', plot.propertyType),
      (Icons.add_road_rounded, 'Road Width', plot.roadWidth),
      (Icons.electric_bolt_rounded, 'Electricity', plot.electricity),
      (Icons.water_drop_outlined, 'Water', plot.water),
      (Icons.verified_user_outlined, 'Registration', plot.registration),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 3 : 2;
        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return AmenityTile(
              icon: item.$1,
              title: item.$2,
              subtitle: item.$3,
            );
          },
        );
      },
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid({required this.amenities});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.security_rounded,
      Icons.add_road_rounded,
      Icons.water_drop_outlined,
      Icons.electric_bolt_rounded,
      Icons.park_outlined,
      Icons.school_outlined,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 4 : 2;
        return GridView.builder(
          itemCount: amenities.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.18,
          ),
          itemBuilder: (context, index) {
            return AmenityTile(
              icon: icons[index % icons.length],
              title: amenities[index],
              subtitle: 'Included with plot',
            );
          },
        );
      },
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapPatternPainter())),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.overlay,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Map Preview',
                    style: AppTextStyles.titleMedium(context),
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

class _SavedPlotCard extends StatelessWidget {
  const _SavedPlotCard({required this.plot});

  final _PlotData plot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.overlay,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Image.network(
                plot.images.first,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    width: 92,
                    height: 92,
                    color: AppColors.surfaceMuted,
                    child: const Icon(Icons.landscape_rounded),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plot.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium(context),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  PriceTag(price: plot.price),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    plot.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Remove favourite',
              onPressed: () {},
              icon: const Icon(Icons.favorite_rounded, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitHero extends StatelessWidget {
  const _VisitHero({required this.plot});

  final _PlotData plot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available_rounded, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plot.title, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(plot.location, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.16)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thinPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.18)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.72),
      Offset(size.width * 0.9, size.height * 0.28),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.12),
      Offset(size.width * 0.78, size.height * 0.88),
      thinPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.52, size.height * 0.48),
      10,
      Paint()..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _push(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      pageBuilder: (_, animation, _) {
        return FadeTransition(opacity: animation, child: page);
      },
      transitionDuration: const Duration(milliseconds: 220),
    ),
  );
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
