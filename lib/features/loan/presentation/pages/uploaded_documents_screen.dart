import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:finhub/features/auth/application/services/auth_session.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/core/widgets/app_button.dart';
import 'package:finhub/features/loan/data/models/uploaded_document.dart';
import 'package:finhub/features/loan/application/services/loan_service.dart';

class UploadedDocumentsScreen extends StatefulWidget {
  const UploadedDocumentsScreen({
    super.key,
    required this.applicationId,
  });

  final String? applicationId;

  @override
  State<UploadedDocumentsScreen> createState() => _UploadedDocumentsScreenState();
}

class _UploadedDocumentsScreenState extends State<UploadedDocumentsScreen> {
  final LoanService _loanService = LoanService();
  late final Future<List<UploadedDocument>> _documentsFuture;

  @override
  void initState() {
    super.initState();
    _documentsFuture = _loadDocuments();
  }

  Future<List<UploadedDocument>> _loadDocuments() {
    final applicationId = widget.applicationId;
    if (applicationId == null || applicationId.isEmpty) {
      return Future.error('Missing loan application ID');
    }

    return _loanService.fetchDocuments(
      applicationId,
      AuthSession.instance.bearerToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uploaded documents')),
      body: SafeArea(
        child: FutureBuilder<List<UploadedDocument>>(
          future: _documentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _CenteredMessage(
                title: 'Unable to load documents.',
                actionLabel: 'Back',
                onAction: () => Navigator.of(context).maybePop(),
              );
            }

            final documents = snapshot.requireData;
            if (documents.isEmpty) {
              return const _CenteredMessage(
                title: 'No documents uploaded yet.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: documents.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                return _DocumentCard(document: documents[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final UploadedDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (document.isImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                document.url,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _PreviewFallback(),
              ),
            )
          else
            const _PreviewFallback(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.type,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (document.fileName != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    document.fileName!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (document.uploadedAt != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Uploaded ${_formatDate(document.uploadedAt!)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Open document',
                  onPressed: () => _openDocument(context, document.url),
                  variant: AppButtonVariant.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDocument(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document URL is invalid.')),
      );
      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open document.')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const names = [
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
    return names[month - 1];
  }
}

class _PreviewFallback extends StatelessWidget {
  const _PreviewFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: AppColors.surfaceMuted,
      child: const Icon(
        Icons.description_outlined,
        color: AppColors.accent,
        size: 36,
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}


