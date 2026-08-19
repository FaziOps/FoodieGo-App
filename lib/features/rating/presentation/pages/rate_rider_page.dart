import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/di/injection_container.dart';
import 'package:restaurant_app/features/rating/domain/entities/rating_entity.dart';
import 'package:restaurant_app/features/rating/presentation/bloc/rating_bloc.dart';
import 'package:restaurant_app/features/rating/presentation/widgets/star_rating_widget.dart';

class RateRiderPage extends StatefulWidget {
  final String orderId;
  final String riderId;
  const RateRiderPage({super.key, required this.orderId, required this.riderId});

  @override
  State<RateRiderPage> createState() => _RateRiderPageState();
}

class _RateRiderPageState extends State<RateRiderPage> {
  int _stars = 5;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const neutralBackground = Color(0xFF1A1614);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return BlocProvider(
      create: (_) => sl<RatingBloc>(),
      child: Scaffold(
        backgroundColor: neutralBackground,
        appBar: AppBar(
          backgroundColor: neutralBackground,
          elevation: 0,
          title: const Text('Rate Your Delivery Rider', style: TextStyle(color: creamText, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: BlocConsumer<RatingBloc, RatingState>(
          listener: (context, state) {
            if (state is RatingSubmitted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Thank you! Your rating has been submitted.'),
                  backgroundColor: Color(0xFF2ECC71),
                ),
              );
            } else if (state is RatingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
              );
            }
          },
          builder: (context, state) {
            final submitting = state is RatingSubmitting;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: secondaryOrange.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delivery_dining_rounded, color: secondaryOrange, size: 48),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'How was your delivery?',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: creamText),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rate your rider to help improve delivery quality.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: creamText.withValues(alpha: 0.7), fontSize: 13),
                        ),
                        const SizedBox(height: 24),

                        // Interactive Star Rating Widget
                        StarRatingWidget(
                          stars: _stars,
                          onChanged: (v) => setState(() => _stars = v),
                        ),
                        const SizedBox(height: 20),

                        // Review Comment Text Box
                        TextField(
                          controller: _reviewController,
                          style: const TextStyle(color: creamText),
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Write a review (optional)',
                            labelStyle: TextStyle(color: creamText.withValues(alpha: 0.7)),
                            hintText: 'Great communication, fast delivery...',
                            hintStyle: TextStyle(color: creamText.withValues(alpha: 0.4)),
                            filled: true,
                            fillColor: neutralBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: secondaryOrange, width: 1.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Submit Button
                        submitting
                            ? const CircularProgressIndicator(color: primaryOrange)
                            : Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [primaryOrange, secondaryOrange],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryOrange.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: creamText,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(Icons.send_rounded, size: 18),
                                  label: const Text(
                                    'Submit Rating',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => context.read<RatingBloc>().add(
                                        SubmitRatingEvent(
                                          RatingEntity(
                                            orderId: widget.orderId,
                                            riderId: widget.riderId,
                                            stars: _stars,
                                            review: _reviewController.text.trim(),
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                      ],
                    ),
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
