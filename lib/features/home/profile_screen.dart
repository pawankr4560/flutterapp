import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_session.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../documents/cloudinary_service.dart';
import 'profile_service.dart';

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
    return AuthSession.instance.userName.isNotEmpty
        ? AuthSession.instance.userName
        : 'Loan Tracker user';
  }

  String get _displayEmail {
    return AuthSession.instance.email.isNotEmpty
        ? AuthSession.instance.email
        : 'Email not available';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthSession.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _ProfileHeader(
                  name: _displayName,
                  email: _displayEmail,
                  imageUrl: AuthSession.instance.profileImageUrl,
                  isUploading: _isUploadingProfileImage,
                  onUploadImage: _uploadProfilePicture,
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle(
                  title: 'Personal details',
                  actionLabel: 'Edit',
                  onAction: _showEditProfileSheet,
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoPanel(
                  children: [
                    _ProfileDetail(
                      icon: Icons.person_outline,
                      title: 'Full name',
                      value: _displayName,
                    ),
                    _ProfileDetail(
                      icon: Icons.mail_outline,
                      title: 'Email',
                      value: _displayEmail,
                    ),
                    _ProfileDetail(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: AuthSession.instance.phone.isNotEmpty
                          ? AuthSession.instance.phone
                          : 'Add phone number',
                    ),
                    _ProfileDetail(
                      icon: Icons.home_outlined,
                      title: 'Address',
                      value: AuthSession.instance.address.isNotEmpty
                          ? AuthSession.instance.address
                          : 'Add address',
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const _SectionTitle(title: 'Loan actions'),
                const SizedBox(height: AppSpacing.sm),
                _ActionTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'My loans',
                  subtitle:
                      'View applications and upload documents from status',
                  onTap: () => context.push(AppRoutePaths.loans),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ActionTile(
                  icon: Icons.calculate_outlined,
                  title: 'EMI calculator',
                  subtitle: 'Estimate monthly repayments',
                  onTap: () => context.push(AppRoutePaths.calculator),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ActionTile(
                  icon: Icons.upload_file_outlined,
                  title: 'Upload documents',
                  subtitle:
                      'Open this from a loan status page to attach an application ID',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Open a loan status page, then tap Upload documents.',
                        ),
                      ),
                    );
                    context.push(AppRoutePaths.loans);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                const _SectionTitle(title: 'Account'),
                const SizedBox(height: AppSpacing.sm),
                _StatusPanel(
                  items: [
                    _StatusItem(
                      label: 'Session',
                      value: AuthSession.instance.isAuthenticated
                          ? 'Active'
                          : 'Signed out',
                      icon: Icons.verified_user_outlined,
                    ),
                    const _StatusItem(
                      label: 'Required KYC',
                      value: 'PAN and Aadhaar',
                      icon: Icons.assignment_turned_in_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Logout',
                  onPressed: _logout,
                  variant: AppButtonVariant.secondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    final router = GoRouter.of(context);
    await AuthSession.instance.logout();
    if (!mounted) {
      return;
    }

    router.go(AppRoutePaths.login);
  }

  Future<void> _uploadProfilePicture() async {
    final userId = AuthSession.instance.userId;
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID is missing. Please login again.'),
        ),
      );
      return;
    }

    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      setState(() => _isUploadingProfileImage = true);

      final imageUrl = await _cloudinaryService.uploadProfilePicture(
        file: result.files.single,
        userId: userId,
      );
      final responseBody = await _profileService.updateProfile(
        userId: userId,
        bearerToken: AuthSession.instance.bearerToken,
        userName: AuthSession.instance.userName,
        phone: AuthSession.instance.phone,
        address: AuthSession.instance.address,
        profileImageUrl: imageUrl,
      );
      await AuthSession.instance.updateFromResponse(responseBody);
      await AuthSession.instance.updateProfile(profileImageUrl: imageUrl);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile picture updated.')));
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() => _isUploadingProfileImage = false);
      }
    }
  }

  Future<void> _showEditProfileSheet() async {
    final nameController = TextEditingController(
      text: AuthSession.instance.userName,
    );
    final emailController = TextEditingController(
      text: AuthSession.instance.email,
    );
    final phoneController = TextEditingController(
      text: AuthSession.instance.phone,
    );
    final addressController = TextEditingController(
      text: AuthSession.instance.address,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: nameController,
                  label: 'Full name',
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: phoneController,
                  label: 'Phone',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: addressController,
                  label: 'Address',
                  hintText: 'Enter your address',
                  prefixIcon: Icons.home_outlined,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Save',
                  onPressed: () async {
                    final userName = nameController.text.trim();
                    final email = emailController.text.trim();
                    final phone = phoneController.text.trim();
                    final address = addressController.text.trim();

                    try {
                      final responseBody = await _profileService.updateProfile(
                        userId: AuthSession.instance.userId,
                        bearerToken: AuthSession.instance.bearerToken,
                        userName: userName,
                        phone: phone,
                        address: address,
                        profileImageUrl: AuthSession.instance.profileImageUrl,
                      );
                      await AuthSession.instance.updateFromResponse(
                        responseBody,
                      );
                      await AuthSession.instance.updateProfile(
                        userName: userName,
                        email: email,
                        phone: phone,
                        address: address,
                      );
                    } catch (error) {
                      if (!context.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error.toString())));
                      return;
                    }

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isUploading,
    required this.onUploadImage,
  });

  final String name;
  final String email;
  final String imageUrl;
  final bool isUploading;
  final VoidCallback onUploadImage;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            height: 76,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: isUploading ? null : onUploadImage,
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.accent,
                        backgroundImage: hasImage
                            ? NetworkImage(imageUrl)
                            : null,
                        child: hasImage
                            ? null
                            : Text(
                                _initials(name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                if (isUploading)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.32),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Tooltip(
                    message: 'Upload profile picture',
                    child: Material(
                      color: AppColors.surface,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: isUploading ? null : onUploadImage,
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.accent,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(email, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                const _InlineBadge(
                  icon: Icons.lock_outline,
                  label: 'Secure account',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    final initials = words.take(2).map((word) => word[0].toUpperCase()).join();
    return initials.isEmpty ? 'LT' : initials;
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (actionLabel != null && onAction != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  const _ProfileDetail({
    required this.icon,
    required this.title,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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

class _ActionTile extends StatelessWidget {
  const _ActionTile({
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
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.accent),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.items});

  final List<_StatusItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            items[index],
            if (index != items.length - 1) const Divider(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _InlineBadge extends StatelessWidget {
  const _InlineBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
