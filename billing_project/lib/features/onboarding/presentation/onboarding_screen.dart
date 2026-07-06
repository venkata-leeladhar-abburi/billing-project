import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/primary_button.dart';

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

const _slides = [
  _OnboardingSlide(
    icon: Icons.receipt_long_outlined,
    title: 'Send bills in seconds',
    body: 'Create a bill and deliver it straight to your customer\'s WhatsApp — no printer needed.',
  ),
  _OnboardingSlide(
    icon: Icons.campaign_outlined,
    title: 'Reach every customer',
    body: 'Send festival offers and reminders to your whole customer list with one tap.',
  ),
  _OnboardingSlide(
    icon: Icons.trending_up,
    title: 'Track credits & grow',
    body: 'Keep an eye on your bill credits, revenue, and top customers — all from one dashboard.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish() => context.go('/login');

  void _next() {
    if (_page == _slides.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.kBgCard,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.kGradientOnboarding),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.s16),
                  child: GestureDetector(
                    onTap: _finish,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.kSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, index) => _buildSlide(_slides[index]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _slides.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                      width: i == _page ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? AppColors.kOrange
                            : AppColors.kBorderGray,
                        borderRadius: AppSpacing.rPill,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.s24),
                child: PrimaryButton(
                  label: isLast ? 'Get Started' : 'Next',
                  onTap: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(_OnboardingSlide slide) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [AppColors.kShadowFloat],
            ),
            alignment: Alignment.center,
            child: Icon(slide.icon, size: 72, color: AppColors.kOrange),
          ),
          SizedBox(height: AppSpacing.s32),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTypography.h1Serif.copyWith(fontSize: 28),
          ),
          SizedBox(height: AppSpacing.s16),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              fontSize: 15,
              height: 1.6,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
