part of 'plot_directory_page.dart';

class _BookVisitScreen extends StatefulWidget {
  const _BookVisitScreen({required this.plot});

  final _PlotData plot;

  @override
  State<_BookVisitScreen> createState() => _BookVisitScreenState();
}

class _BookVisitScreenState extends State<_BookVisitScreen> {
  final _service = _PlotApiService();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _remarksController = TextEditingController();
  DateTime? _visitDate;
  TimeOfDay? _visitTime;
  bool _saving = false;

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
              label: _saving ? 'Booking...' : 'Book Visit',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _saving ? null : _bookVisit,
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

  Future<void> _bookVisit() async {
    if (_nameController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty ||
        _visitDate == null ||
        _visitTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await _service.bookVisit(
        plotId: widget.plot.id,
        name: _nameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        visitDate: _visitDate!,
        visitTime: _visitTime!,
        remarks: _remarksController.text.trim(),
      );
      if (!mounted) return;
      _showSuccessDialog();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
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

