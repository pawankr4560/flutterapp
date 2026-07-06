import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finhub/app/router.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';
import 'package:finhub/features/loan/application/services/cloudinary_service.dart';
import 'package:finhub/features/profile/application/services/profile_service.dart';

/// Profile page that surfaces account details, loan shortcuts, and logout.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ProfileService _profileService = ProfileService();

  bool _isUploadingProfileImage = false;

  String get _displayName {
    final name = AuthSession.instance.userName.trim();
    return name.isEmpty ? 'SmartSathi user' : name;
  }

  String get _displayEmail {
    final email = AuthSession.instance.email.trim();
    return email.isEmpty ? 'Email not available' : email;
  }

  String get _displayPhone {
    final phone = AuthSession.instance.phone.trim();
    return phone.isEmpty ? 'Add phone number' : phone;
  }

  String get _displayAddress {
    final address = AuthSession.instance.address.trim();
    return address.isEmpty ? 'Add address' : address;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthSession.instance,
      builder: (context, _) {
        return Theme(
          data: _profileTheme(context),
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  Text('Profile', style: AppTextStyles.headlineLarge(context)),
                  const SizedBox(height: AppSpacing.xl),
                  _ProfileHeaderCard(
                    name: _displayName,
                    email: _displayEmail,
                    imageUrl: AuthSession.instance.profileImageUrl,
                    isUploading: _isUploadingProfileImage,
                    onCameraTap: _uploadProfilePicture,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _SectionHeader(
                    title: 'Personal details',
                    actionLabel: 'Edit',
                    actionIcon: Icons.edit_outlined,
                    onAction: _showEditProfileSheet,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ProfileDetailsPanel(
                    rows: [
                      _DetailRowData(
                        icon: Icons.person_outline_rounded,
                        label: 'Full name',
                        value: _displayName,
                      ),
                      _DetailRowData(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        value: _displayEmail,
                      ),
                      _DetailRowData(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: _displayPhone,
                      ),
                      _DetailRowData(
                        icon: Icons.home_outlined,
                        label: 'Address',
                        value: _displayAddress,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionHeader(title: 'Loan actions'),
                  const SizedBox(height: AppSpacing.md),
                  _ActionCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'My loans',
                    subtitle:
                        'View applications and upload documents from status',
                    onTap: () => context.push(AppRoutePaths.loans),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ActionCard(
                    icon: Icons.calculate_outlined,
                    title: 'EMI calculator',
                    subtitle: 'Estimate monthly repayments',
                    onTap: () => context.push(AppRoutePaths.calculator),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ActionCard(
                    icon: Icons.upload_file_outlined,
                    title: 'Upload documents',
                    subtitle:
                        'Open this from a loan status page to attach an application ID',
                    onTap: _showUploadDocumentHint,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionHeader(title: 'Account'),
                  const SizedBox(height: AppSpacing.md),
                  const _AccountPanel(),
                  const SizedBox(height: AppSpacing.xl),
                  _LogoutButton(onTap: _logout),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadProfilePicture() async {
    if (_isUploadingProfileImage) {
      return;
    }

    final userId = AuthSession.instance.userId;
    final token = AuthSession.instance.bearerToken;
    if (userId.isEmpty || token.isEmpty) {
      _showSnackBar('Please login again before updating your profile photo.');
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) {
      return;
    }

    setState(() => _isUploadingProfileImage = true);
    try {
      final imageUrl = await _cloudinaryService.uploadProfilePicture(
        file: file,
        userId: userId,
      );
      final response = await _profileService.updateProfile(
        userId: userId,
        bearerToken: token,
        profileImageUrl: imageUrl,
      );

      await AuthSession.instance.updateProfile(profileImageUrl: imageUrl);
      await AuthSession.instance.updateFromResponse(response);
      _showSnackBar('Profile photo updated.');
    } catch (error) {
      _showSnackBar(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isUploadingProfileImage = false);
      }
    }
  }

  Future<void> _showEditProfileSheet() async {
    final nameController = TextEditingController(text: _displayName);
    final phoneController = TextEditingController(
      text: AuthSession.instance.phone,
    );
    final addressController = TextEditingController(
      text: AuthSession.instance.address,
    );
    var isSaving = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return Theme(
          data: _profileTheme(sheetContext),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  top: AppSpacing.lg,
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit profile',
                      style: AppTextStyles.titleLarge(context),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: nameController,
                      labelText: 'Full name',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      controller: phoneController,
                      labelText: 'Phone',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      controller: addressController,
                      labelText: 'Address',
                      prefixIcon: Icons.home_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PrimaryButton(
                      text: 'Save changes',
                      loading: isSaving,
                      onPressed: () async {
                        setSheetState(() => isSaving = true);
                        await _saveProfile(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          address: addressController.text.trim(),
                        );
                        if (sheetContext.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  ThemeData _profileTheme(BuildContext context) {
    final base = Theme.of(context);
    final colorScheme = base.colorScheme;

    return base.copyWith(
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: colorScheme.surface,
        prefixIconColor: AppColors.primary,
        hintStyle: base.textTheme.bodyMedium,
        labelStyle: base.textTheme.bodyMedium,
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: colorScheme.surface,
        modalBackgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  Future<void> _saveProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      final userId = AuthSession.instance.userId;
      final token = AuthSession.instance.bearerToken;
      Map<String, dynamic>? response;

      if (userId.isNotEmpty && token.isNotEmpty) {
        response = await _profileService.updateProfile(
          userId: userId,
          bearerToken: token,
          userName: name,
          phone: phone,
          address: address,
        );
      }

      await AuthSession.instance.updateProfile(
        userName: name,
        phone: phone,
        address: address,
      );
      await AuthSession.instance.updateFromResponse(response);
      _showSnackBar('Profile updated.');
    } catch (error) {
      _showSnackBar(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showUploadDocumentHint() {
    _showSnackBar('Open a loan status page, then tap Upload documents.');
  }

  Future<void> _logout() async {
    await AuthSession.instance.logout();
    if (mounted) {
      context.go(AppRoutePaths.login);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isUploading,
    required this.onCameraTap,
  });

  final String name;
  final String email;
  final String imageUrl;
  final bool isUploading;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          _Avatar(
            name: name,
            imageUrl: imageUrl,
            isUploading: isUploading,
            onCameraTap: onCameraTap,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineMedium(context),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge(
                    context,
                  ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.sm),
                const _SecureAccountBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.imageUrl,
    required this.isUploading,
    required this.onCameraTap,
  });

  final String name;
  final String imageUrl;
  final bool isUploading;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? 'F' : name.trim()[0].toUpperCase();

    return SizedBox(
      height: 96,
      width: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: AppColors.primary,
            backgroundImage: imageUrl.isEmpty ? null : NetworkImage(imageUrl),
            child: imageUrl.isEmpty
                ? Text(
                    initial,
                    style: AppTextStyles.headlineLarge(
                      context,
                    ).copyWith(color: Theme.of(context).colorScheme.onPrimary),
                  )
                : null,
          ),
          Positioned(
            right: -2,
            bottom: 0,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              shape: CircleBorder(
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: isUploading ? null : onCameraTap,
                child: SizedBox.square(
                  dimension: 42,
                  child: isUploading
                      ? const Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.photo_camera_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecureAccountBadge extends StatelessWidget {
  const _SecureAccountBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Secure account',
            style: AppTextStyles.labelLarge(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppTextStyles.headlineMedium(context)),
        ),
        if (actionLabel != null && onAction != null)
          TextButton.icon(
            onPressed: onAction,
            icon: Icon(actionIcon, size: 22),
            label: Text(actionLabel!),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyles.titleMedium(context),
            ),
          ),
      ],
    );
  }
}

class _ProfileDetailsPanel extends StatelessWidget {
  const _ProfileDetailsPanel({required this.rows});

  final List<_DetailRowData> rows;

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            _DetailRow(data: rows[index]),
            if (index != rows.length - 1)
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline,
              ),
          ],
        ],
      ),
    );
  }
}

class _DetailRowData {
  const _DetailRowData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.data});

  final _DetailRowData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: AppColors.primary, size: 30),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: AppTextStyles.bodyLarge(
                    context,
                  ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(data.value, style: AppTextStyles.titleLarge(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 30),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleLarge(context)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyLarge(
                      context,
                    ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountPanel extends StatelessWidget {
  const _AccountPanel();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const _AccountRow(
            icon: Icons.verified_user_outlined,
            title: 'Session',
            value: 'Active',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const _AccountRow(
            icon: Icons.fact_check_outlined,
            title: 'Required KYC',
            value: 'PAN and Aadhaar',
          ),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(title, style: AppTextStyles.titleLarge(context)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodyLarge(
                context,
              ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Center(
          child: Text(
            'Logout',
            style: AppTextStyles.titleLarge(
              context,
            ).copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({required this.child, required this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
