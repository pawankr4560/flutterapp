import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/domain/entities/recent_activity.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_activity_tile.dart';

/// Recent activity stream section for the dashboard page.
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key, required this.activities});

  final List<RecentActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activities', style: AppTextStyles.titleLarge(context)),
        const SizedBox(height: AppSpacing.md),
        ListView.builder(
          itemCount: activities.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == activities.length - 1 ? 0 : AppSpacing.md,
              ),
              child: RecentActivityTile(activity: activities[index]),
            );
          },
        ),
      ],
    );
  }
}
