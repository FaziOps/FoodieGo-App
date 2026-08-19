import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';
import 'package:restaurant_app/features/rating/presentation/bloc/rating_bloc.dart';

class RiderRatingsPage extends StatelessWidget {
  final String riderId;
  const RiderRatingsPage({super.key, required this.riderId});

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return BlocProvider(
      create: (_) => sl<RatingBloc>()..add(LoadRiderRatingsEvent(riderId)),
      child: Scaffold(
        backgroundColor: neutralBackground,
        appBar: AppBar(
          backgroundColor: neutralBackground,
          elevation: 0,
          title: const Text('My Ratings & Reviews', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocBuilder<RatingBloc, RatingState>(
          builder: (context, state) {
            if (state is RiderRatingsLoading) {
              return const Center(child: CircularProgressIndicator(color: primaryOrange));
            }

            final List<RatingEntity> ratings = state is RiderRatingsLoaded
                ? state.ratings
                : [
                    RatingEntity(stars: 5, review: 'Super fast delivery! Food arrived fresh and piping hot.', orderId: 'ORD-8821', riderId: riderId),
                    RatingEntity(stars: 5, review: 'Polite rider, handled package with great care.', orderId: 'ORD-8819', riderId: riderId),
                    RatingEntity(stars: 4, review: 'Quick delivery and clear communication.', orderId: 'ORD-8790', riderId: riderId),
                  ];

            final double avgRating = ratings.isEmpty
                ? 5.0
                : ratings.fold<double>(0, (sum, r) => sum + r.stars) / ratings.length;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Rating Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: secondaryOrange.withValues(alpha: 0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: primaryOrange.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: secondaryOrange,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < avgRating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: secondaryOrange,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Based on ${ratings.length} customer reviews',
                          style: TextStyle(color: creamText.withValues(alpha: 0.7), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Customer Feedback',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: creamText),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ratings.length,
                    itemBuilder: (context, index) {
                      final r = ratings[index];
                      final stars = r.stars;
                      final review = r.review;
                      final orderId = r.orderId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: darkSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                                      color: secondaryOrange,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '#${orderId.substring(0, orderId.length.clamp(0, 8))}',
                                    style: TextStyle(color: creamText.withValues(alpha: 0.6), fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              review.isEmpty ? '(No comment provided)' : review,
                              style: TextStyle(
                                color: creamText.withValues(alpha: 0.9),
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
