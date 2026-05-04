import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../modules/trip/trip_detection_provider.dart';
import '../../ui/widgets/glass_card.dart';
import '../../ui/widgets/pulse_badge.dart';
import 'trip_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripDetectionProvider>().startTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripDetectionProvider>();
    final size = MediaQuery.of(context).size;
    final heroHeight = size.height * 0.45;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: heroHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.04),
                    duration: const Duration(seconds: 16),
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Image.asset(
                        'assets/images/home_banner.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.background.withOpacity(0.05),
                            AppColors.background.withOpacity(0.93),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('travel Tracker', style: TextStyle(color: AppColors.neonPurple, fontSize: 34, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildPulsingDot(provider.isTracking),
                            const SizedBox(width: 12),
                            Text(provider.statusLabel, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Distance: ${formatDistance(provider.currentDistance)}', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  children: [
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Trip Detection', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 14),
                          Text(provider.feedbackLabel, style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PulseBadge(label: 'Trip Started', active: provider.feedbackLabel == 'Trip Started'),
                              PulseBadge(label: 'Trip Ongoing', active: provider.feedbackLabel == 'Trip Ongoing'),
                              PulseBadge(label: 'Completed', active: provider.feedbackLabel == 'Trip Completed'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Location', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _buildLocationBlock('Latitude', provider.formattedLatitude),
                              const SizedBox(width: 18),
                              _buildLocationBlock('Longitude', provider.formattedLongitude),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatusChip('Tracking', provider.isTracking),
                              _buildStatusChip(provider.isTracking ? 'Active' : 'Idle', provider.isTracking),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const TripListScreen()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonPurple, foregroundColor: Colors.black),
                        child: const Text('View Trips', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: active ? AppColors.neonBlue.withOpacity(0.16) : AppColors.panel,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(label, style: TextStyle(color: active ? AppColors.neonBlue : AppColors.textSecondary, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildLocationBlock(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPulsingDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      width: active ? 16 : 12,
      height: active ? 16 : 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.neonBlue : AppColors.textSecondary,
        boxShadow: active ? [BoxShadow(color: AppColors.neonBlue.withOpacity(0.35), blurRadius: 18, spreadRadius: 2)] : null,
      ),
    );
  }
}
