import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

class PlotCard extends StatelessWidget {
  const PlotCard({
    super.key,
    required this.heroTag,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.area,
    required this.price,
    required this.status,
    required this.amenities,
    required this.onViewDetails,
    this.isCompact = false,
    this.onFavorite,
  });

  final String heroTag;
  final String imageUrl;
  final String title;
  final String location;
  final String area;
  final String price;
  final String status;
  final List<String> amenities;
  final VoidCallback onViewDetails;
  final VoidCallback? onFavorite;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 3,
      shadowColor: AppColors.overlay,
      borderRadius: BorderRadius.circular(AppRadius.large),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: heroTag,
                  child: _NetworkImageFrame(
                    imageUrl: imageUrl,
                    height: isCompact ? 136 : 184,
                    width: double.infinity,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: StatusBadge(label: status),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: _CircleIconButton(
                    icon: Icons.favorite_border_rounded,
                    onPressed: onFavorite,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium(context),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      PriceTag(price: price),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _IconText(
                    icon: Icons.location_on_outlined,
                    text: location,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _IconText(icon: Icons.square_foot_rounded, text: area),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final amenity in amenities.take(3))
                        _AmenityPill(label: amenity),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      child: const Text('View Details'),
                    ),
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

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = switch (label.toLowerCase()) {
      'available' || 'confirmed' || 'completed' => AppColors.success,
      'booked' || 'pending' => AppColors.warning,
      'sold' || 'cancelled' => AppColors.error,
      _ => AppColors.primary,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall(context).copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      textAlign: TextAlign.end,
      style: AppTextStyles.titleMedium(context).copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class SellerCard extends StatelessWidget {
  const SellerCard({
    super.key,
    required this.name,
    required this.phone,
    required this.onCall,
    required this.onWhatsApp,
  });

  final String name;
  final String phone;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    return _PremiumPanel(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              name.characters.first,
              style: AppTextStyles.titleLarge(context).copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(phone, style: AppTextStyles.bodyMedium(context)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _CircleIconButton(icon: Icons.call_rounded, onPressed: onCall),
          const SizedBox(width: AppSpacing.xs),
          _CircleIconButton(
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: onWhatsApp,
          ),
        ],
      ),
    );
  }
}

class AmenityTile extends StatelessWidget {
  const AmenityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _PremiumPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium(context),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}

class PlotImageCarousel extends StatefulWidget {
  const PlotImageCarousel({
    super.key,
    required this.heroTag,
    required this.images,
    this.height = 320,
  });

  final String heroTag;
  final List<String> images;
  final double height;

  @override
  State<PlotImageCarousel> createState() => _PlotImageCarouselState();
}

class _PlotImageCarouselState extends State<PlotImageCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (value) => setState(() => _index = value),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final child = _NetworkImageFrame(
                imageUrl: image,
                height: widget.height,
                width: double.infinity,
                borderRadius: BorderRadius.zero,
              );

              if (index == 0) {
                return Hero(tag: widget.heroTag, child: child);
              }
              return child;
            },
          ),
          Positioned(
            bottom: AppSpacing.md,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.images.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _index ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? AppColors.surface
                          : AppColors.surface.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VisitCard extends StatelessWidget {
  const VisitCard({
    super.key,
    required this.imageUrl,
    required this.propertyName,
    required this.date,
    required this.time,
    required this.status,
  });

  final String imageUrl;
  final String propertyName;
  final String date;
  final String time;
  final String status;

  @override
  Widget build(BuildContext context) {
    return _PremiumPanel(
      child: Row(
        children: [
          _NetworkImageFrame(
            imageUrl: imageUrl,
            height: 82,
            width: 88,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium(context),
                ),
                const SizedBox(height: AppSpacing.xs),
                _IconText(icon: Icons.calendar_month_rounded, text: date),
                const SizedBox(height: AppSpacing.xxs),
                _IconText(icon: Icons.schedule_rounded, text: time),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusBadge(label: status),
        ],
      ),
    );
  }
}

class PlotSearchBar extends StatelessWidget {
  const PlotSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Search by location, project, or area',
        prefixIcon: Icon(Icons.search_rounded),
      ),
    );
  }
}

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters) ...[
            ChoiceChip(
              label: Text(filter),
              selected: selectedFilter == filter,
              onSelected: (_) => onSelected(filter),
              selectedColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                side: BorderSide(
                  color: selectedFilter == filter
                      ? AppColors.primary.withValues(alpha: 0.35)
                      : AppColors.border,
                ),
              ),
              labelStyle: AppTextStyles.bodyMedium(context).copyWith(
                color: selectedFilter == filter
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class PlotPrimaryButton extends StatelessWidget {
  const PlotPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward_rounded),
      label: Text(label),
    );
  }
}

class PlotEmptyStateWidget extends StatelessWidget {
  const PlotEmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.real_estate_agent_outlined,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _PremiumPanel(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(context),
          ),
        ],
      ),
    );
  }
}

class LoadingSkeletonWidget extends StatefulWidget {
  const LoadingSkeletonWidget({super.key});

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: _PremiumPanel(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _SkeletonBlock(height: 180, radius: AppRadius.large),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: const [
                  _SkeletonBlock(height: 18, widthFactor: 0.82),
                  SizedBox(height: AppSpacing.sm),
                  _SkeletonBlock(height: 14, widthFactor: 0.58),
                  SizedBox(height: AppSpacing.sm),
                  _SkeletonBlock(height: 44),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumPanel extends StatelessWidget {
  const _PremiumPanel({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.overlay,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _NetworkImageFrame extends StatelessWidget {
  const _NetworkImageFrame({
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: AppColors.primary.withValues(alpha: 0.08),
            child: const Icon(
              Icons.landscape_rounded,
              color: AppColors.primary,
              size: 42,
            ),
          );
        },
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xxs),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmenityPill extends StatelessWidget {
  const _AmenityPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall(context).copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: AppColors.primary, size: 21),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.height,
    this.widthFactor = 1,
    this.radius = AppRadius.medium,
  });

  final double height;
  final double widthFactor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
