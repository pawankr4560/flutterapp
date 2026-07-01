import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _userProfile = _UserProfile(
    name: 'Pawan Kumar',
    email: 'pawan@gmail.com',
    phone: '+91 4723927928',
    address: '15 Green Park, New Delhi',
    branch: 'Gurgaon branch',
    status: 'Verified',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Personal details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ProfileDetail(title: 'Name', value: _userProfile.name),
            const SizedBox(height: AppSpacing.sm),
            _ProfileDetail(title: 'Email', value: _userProfile.email),
            const SizedBox(height: AppSpacing.sm),
            _ProfileDetail(title: 'Phone', value: _userProfile.phone),
            const SizedBox(height: AppSpacing.sm),
            _ProfileDetail(title: 'Address', value: _userProfile.address),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Account status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branch',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _userProfile.branch,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'KYC status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _userProfile.status,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'KYC documents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._kycDocuments.map(
              (document) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _KycDocumentCard(document: document),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileSettingTile(
              label: 'Notifications',
              value: 'Enabled',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileSettingTile(
              label: 'Security',
              value: 'Password set',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileSettingTile(
              label: 'KYC documents',
              value: '3 uploaded',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Edit profile',
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Logout',
              onPressed: () {},
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  const _ProfileDetail({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _KycDocumentCard extends StatelessWidget {
  const _KycDocumentCard({required this.document});

  final _KycDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  document.status,
                  style: TextStyle(
                    color: document.status == 'Uploaded' ? AppColors.accent : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: document.actionLabel,
            onPressed: () {},
            variant: AppButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}

class _ProfileSettingTile extends StatelessWidget {
  const _ProfileSettingTile({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      tileColor: AppColors.surface,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(value, style: const TextStyle(color: AppColors.textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
    );
  }
}

class _UserProfile {
  const _UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.branch,
    required this.status,
  });

  final String name;
  final String email;
  final String phone;
  final String address;
  final String branch;
  final String status;
}

const _kycDocuments = [
  _KycDocument(name: 'PAN card', status: 'Uploaded', actionLabel: 'View'),
  _KycDocument(name: 'Aadhaar card', status: 'Uploaded', actionLabel: 'View'),
  _KycDocument(name: 'Salary slips', status: 'Pending', actionLabel: 'Upload'),
];

class _KycDocument {
  const _KycDocument({
    required this.name,
    required this.status,
    required this.actionLabel,
  });

  final String name;
  final String status;
  final String actionLabel;
}
