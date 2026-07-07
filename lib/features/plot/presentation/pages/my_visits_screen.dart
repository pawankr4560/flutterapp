part of 'plot_directory_page.dart';

class MyVisitsScreen extends StatelessWidget {
  const MyVisitsScreen({super.key});

  static final List<_VisitData> _visits = [
    (
      propertyName: 'Green Valley Premium Plot',
      date: '08 Jul 2026',
      time: '11:00 AM',
      status: 'Pending',
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=600&q=80',
    ),
    (
      propertyName: 'Lakeview Corner Plot',
      date: '09 Jul 2026',
      time: '04:30 PM',
      status: 'Confirmed',
      imageUrl:
          'https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=600&q=80',
    ),
    (
      propertyName: 'Sunrise Enclave Plot',
      date: '03 Jul 2026',
      time: '10:15 AM',
      status: 'Completed',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=600&q=80',
    ),
    (
      propertyName: 'Royal Heights East Facing',
      date: '02 Jul 2026',
      time: '02:00 PM',
      status: 'Cancelled',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=600&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Visits')),
      body: SafeArea(
        child: ListView.separated(
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
}

