part of 'plot_directory_page.dart';

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

