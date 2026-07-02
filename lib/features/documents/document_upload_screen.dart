import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_session.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../models/document_item.dart';
import '../application/document_requests.dart';
import '../application/loan_service.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final LoanService _loanService = LoanService();
  bool _isSubmitting = false;

  List<DocumentItem> _documents = const [
    DocumentItem(
      name: 'PAN card',
      status: DocumentUploadStatus.notUploaded,
    ),
    DocumentItem(
      name: 'Aadhaar card',
      status: DocumentUploadStatus.notUploaded,
    ),
    DocumentItem(
      name: 'Salary slips',
      status: DocumentUploadStatus.notUploaded,
    ),
    DocumentItem(
      name: 'Bank statement',
      status: DocumentUploadStatus.notUploaded,
    ),
  ];

  bool get _canSubmit {
    return _documents.every(
      (document) => document.status == DocumentUploadStatus.uploaded,
    );
  }

  Future<void> _pickDocument(DocumentItem document) async {
    _updateDocument(
      document.name,
      status: DocumentUploadStatus.uploading,
      filePath: document.filePath,
    );

    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (!mounted) {
        return;
      }

      if (result == null || result.files.isEmpty) {
        _updateDocument(
          document.name,
          status: document.filePath == null
              ? DocumentUploadStatus.notUploaded
              : DocumentUploadStatus.uploaded,
          filePath: document.filePath,
        );
        return;
      }

      final selectedFile = result.files.single;
      _updateDocument(
        document.name,
        status: DocumentUploadStatus.uploaded,
        filePath: selectedFile.path ?? selectedFile.name,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _updateDocument(
        document.name,
        status: DocumentUploadStatus.failed,
        filePath: document.filePath,
      );
    }
  }

  void _updateDocument(
    String name, {
    required DocumentUploadStatus status,
    String? filePath,
  }) {
    setState(() {
      _documents = _documents.map((document) {
        if (document.name != name) {
          return document;
        }

        return document.copyWith(status: status, filePath: filePath);
      }).toList();
    });
  }

  Future<void> _submitApplication() async {
    setState(() {
      _isSubmitting = true;
    });

    final request = DocumentUploadRequest(
      applicationId: '2026-GKFIN-00003',
      documents: _documents
          .map(
            (document) => LoanDocument(
              type: document.name,
              url: document.filePath ?? document.name,
            ),
          )
          .toList(),
    );

    try {
      final response = await _loanService.uploadDocuments(
        request,
        AuthSession.instance.bearerToken,
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>?;
      final success = responseBody?['success'] == true;
      final message = responseBody?['message'] as String?;

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Documents uploaded successfully')),
        );
        context.push('${AppRoutePaths.status}?applicationId=2026-GKFIN-00003');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Document upload failed.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document upload')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Upload documents',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add all required files to complete your loan application.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ..._documents.map(
              (document) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _DocumentUploadCard(
                  document: document,
                  onTap: () => _pickDocument(document),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: _isSubmitting ? 'Submitting...' : 'Submit application',
              onPressed: !_canSubmit || _isSubmitting ? null : _submitApplication,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  const _DocumentUploadCard({
    required this.document,
    required this.onTap,
  });

  final DocumentItem document;
  final VoidCallback onTap;

  bool get _isUploaded => document.status == DocumentUploadStatus.uploaded;

  bool get _isUploading => document.status == DocumentUploadStatus.uploading;

  bool get _isFailed => document.status == DocumentUploadStatus.failed;

  @override
  Widget build(BuildContext context) {
    final borderColor = _isUploaded ? _successGreen : AppColors.border;
    final backgroundColor = _isUploaded ? _successSurface : AppColors.surface;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: _isUploading ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: _DashedBorder(
          isDashed: !_isUploaded,
          color: borderColor,
          borderRadius: 8,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                _StatusIcon(document: document),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _supportingText,
                        style: TextStyle(
                          color: _isUploaded
                              ? _successGreen
                              : _isFailed
                                  ? Colors.redAccent
                                  : AppColors.textSecondary,
                          fontWeight: _isUploaded
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(
                  _isUploaded ? Icons.check_circle : Icons.upload_file,
                  color: _isUploaded ? _successGreen : AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _supportingText {
    switch (document.status) {
      case DocumentUploadStatus.notUploaded:
        return 'Tap to upload PDF, JPG, or PNG';
      case DocumentUploadStatus.uploading:
        return 'Uploading...';
      case DocumentUploadStatus.uploaded:
        return document.filePath == null
            ? 'Uploaded'
            : 'Uploaded - ${_fileNameFromPath(document.filePath!)}';
      case DocumentUploadStatus.failed:
        return 'Upload failed. Tap to retry';
    }
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.document});

  final DocumentItem document;

  @override
  Widget build(BuildContext context) {
    if (document.status == DocumentUploadStatus.uploading) {
      return const SizedBox(
        width: 42,
        height: 42,
        child: Padding(
          padding: EdgeInsets.all(9),
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    final isUploaded = document.status == DocumentUploadStatus.uploaded;
    final isFailed = document.status == DocumentUploadStatus.failed;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isUploaded
            ? _successGreen
            : isFailed
                ? Colors.redAccent.withValues(alpha: 0.1)
                : AppColors.surfaceMuted,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUploaded
            ? Icons.check
            : isFailed
                ? Icons.error_outline
                : Icons.upload_outlined,
        color: isUploaded
            ? Colors.white
            : isFailed
                ? Colors.redAccent
                : AppColors.accent,
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  const _DashedBorder({
    required this.child,
    required this.isDashed,
    required this.color,
    required this.borderRadius,
  });

  final Widget child;
  final bool isDashed;
  final Color color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!isDashed) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: color),
        ),
        child: child,
      );
    }

    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.5),
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashWidth = 7.0;
      const dashSpace = 5.0;

      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, nextDistance),
          paint,
        );
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}

const Color _successGreen = Color(0xFF16A34A);
const Color _successSurface = Color(0xFFEFFAF3);

String _fileNameFromPath(String filePath) {
  return filePath.split(RegExp(r'[\\/]')).last;
}
