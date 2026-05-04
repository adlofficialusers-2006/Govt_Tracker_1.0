import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../ui/widgets/glass_card.dart';

class TripDetailScreen extends StatelessWidget {
  final Map<String, dynamic> trip;

  const TripDetailScreen({super.key, required this.trip});

  Widget _buildSection(String title, List<Widget> children) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600))),
          Expanded(flex: 5, child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = trip['duration'] is int ? Duration(seconds: trip['duration'] as int) : const Duration();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Route Overview', [
              _buildRow('Start', trip['start'] ?? 'Unknown'),
              _buildRow('End', trip['end'] ?? 'Unknown'),
              _buildRow('Distance', '${(trip['distance'] ?? 0).toStringAsFixed(1)} m'),
              _buildRow('Duration', formatDuration(duration)),
            ]),
            const SizedBox(height: 16),
            _buildSection('Travel Details', [
              _buildRow('Mode', trip['mode'] ?? 'Unknown'),
              _buildRow('Purpose', trip['purpose'] ?? 'Unknown'),
              _buildRow('Cost', trip['cost'] ?? 'Unknown'),
              _buildRow('Companions', trip['companions'] ?? 'Unknown'),
              _buildRow('Frequency', trip['frequency'] ?? 'Unknown'),
            ]),
            const SizedBox(height: 16),
            _buildSection('Timeline', [
              _buildRow('Started', formatDateTime(trip['startTime'] ?? 'Unknown')),
              _buildRow('Ended', formatDateTime(trip['endTime'] ?? 'Unknown')),
            ]),
          ],
        ),
      ),
    );
  }
}
