part of 'plot_directory_page.dart';

class MyVisitsScreen extends StatefulWidget {
  const MyVisitsScreen({super.key});

  @override
  State<MyVisitsScreen> createState() => _MyVisitsScreenState();
}

class _MyVisitsScreenState extends State<MyVisitsScreen> {
  final _service = _PlotApiService();
  List<_VisitData> _visits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Visits')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _visits.isEmpty
            ? const Center(child: Text('No site visits found.'))
            : ListView.separated(
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

  Future<void> _load() async {
    try {
      final visits = await _service.fetchVisits();
      if (mounted) setState(() { _visits = visits; _loading = false; });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

