import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_tab_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/loading_overlay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_badge.dart';
import '../domain/dashboard_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _DashboardBody(data: data),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.data});

  final DashboardState data;

  Color get _creditColor {
    final pct = data.billCredits / data.billCreditsLimit;
    if (pct > 0.5) return AppColors.kGreen;
    if (pct > 0.2) return AppColors.kWarning;
    return AppColors.kError;
  }

  @override
  Widget build(BuildContext context) {
    final isLowCredit = data.billCredits / data.billCreditsLimit < 0.2;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _CustomDashboardHeader(
          data: data,
          bottomOverlap: AppCard(
            borderRadius: 16,
            padding: const EdgeInsets.all(12), // Reduced from 16 to reduce card height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today's Revenue", style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500)), // Scaled down text
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Scaled down padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Text("Today", style: GoogleFonts.inter(fontSize: 9, color: Colors.black)), // Scaled down text
                          const SizedBox(width: 2),
                          const Icon(Icons.keyboard_arrow_down, size: 12, color: Colors.grey), // Scaled down icon
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Reduced from 12
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatters.formatINR(data.todayRevenue),
                            style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1F2937), letterSpacing: -0.5), // Reduced from 32
                          ),
                          const SizedBox(height: 4), // Reduced from 8
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Scaled down
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0E6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_upward, size: 10, color: Color(0xFFFF7A45)), // Scaled down
                                    const SizedBox(width: 2),
                                    Text(
                                      "18.6%",
                                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFFFF7A45)), // Scaled down
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text("vs yesterday", style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500)), // Scaled down
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Chart placeholder
                    SizedBox(
                      width: 80, // Scaled down
                      height: 40, // Scaled down
                      child: CustomPaint(
                        painter: _SparklinePainter(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Reduced from 12
                // Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Reduced padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F3), // very light orange
                    borderRadius: BorderRadius.circular(10), // Scaled down
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6), // Scaled down
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEDD5),
                          borderRadius: BorderRadius.circular(6), // Scaled down
                        ),
                        child: const Icon(Icons.trending_up, color: Color(0xFFF97316), size: 14), // Scaled down
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Excellent Growth! 🚀", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))), // Scaled down
                            const SizedBox(height: 2),
                            Text("You're doing great! Keep it up.", style: GoogleFonts.inter(fontSize: 9, color: Colors.grey.shade600)), // Scaled down
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text("View Report", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFFF97316))), // Scaled down
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 10, color: Color(0xFFF97316)), // Scaled down
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), // Aligned with revenue card's 16px inset
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLowCredit) ...[
                InfoBanner(
                  type: InfoBannerType.warning,
                  message:
                      'Only ${data.billCredits} bill credits left. Top up to keep sending.',
                  actionLabel: 'Buy Credits →',
                  onAction: () => context.go('/credits/topup'),
                ),
                SizedBox(height: AppSpacing.s16),
              ],
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      label: 'New Bill',
                      subLabel: 'Create & Send',
                      imageAsset: 'assets/images/icon_new_bill_rupee.png', // Replaced with new Rupee icon
                      onTap: () => context.go('/new-bill'),
                    ),
                  ),
                  const SizedBox(width: 6), // Reduced gap
                  Expanded(
                    child: _QuickActionCard(
                      label: 'Bill History',
                      subLabel: 'View Past',
                      imageAsset: 'assets/images/icon_bill_history_3d.png',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 6), // Reduced gap
                  Expanded(
                    child: _QuickActionCard(
                      label: 'Add Customer',
                      subLabel: 'Grow Database',
                      imageAsset: 'assets/images/icon_customers_3d.png', // Replaced with new 3D customer icon
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 6), // Reduced gap
                  Expanded(
                    child: _QuickActionCard(
                      label: 'Bulk Message',
                      subLabel: 'Send Campaigns',
                      imageAsset: 'assets/images/icon_bulk_message_3d.png',
                      onTap: () => context.go('/bulk-message'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _PromoCampaignCard(),
              const SizedBox(height: 12), // Reduced spacing to move Recent Bills upwards
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                      child: SectionHeader(
                        title: 'Recent Activity',
                        actionLabel: 'View All',
                        onAction: () => context.go('/bill-history'),
                      ),
                    ),
                    if (data.recentBills.isEmpty)
                      SizedBox(
                        height: 280,
                        child: EmptyState(
                          type: EmptyStateType.bills,
                          title: 'No bills sent today',
                          subtitle: 'Tap New Bill to get started',
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.recentBills.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade100,
                        ),
                        itemBuilder: (context, index) {
                          final bill = data.recentBills[index];
                          final initials = bill.customerName.isNotEmpty 
                              ? bill.customerName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase()
                              : 'C';

                          return InkWell(
                            onTap: () => context.push('/bill/${bill.billId}'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: const Color(0xFFF3E8FF), // Light purple
                                    child: Text(
                                      initials,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF6B21A8), // Dark purple
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bill sent to ${bill.customerName}',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${bill.billNumber} • ${bill.sentAgo}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (bill.status == 'sent') ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFF7ED), // Light orange
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  'Sent on WhatsApp',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 9,
                                                    color: const Color(0xFFEA580C), // Dark orange
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    Formatters.formatINR(bill.total),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        SizedBox(height: AppSpacing.s4),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.label,
    required this.subLabel,
    required this.imageAsset,
    required this.onTap,
  });

  final String label;
  final String subLabel;
  final String imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2), // Increased vertical padding to make cards larger
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: label == 'Add Customer' 
                  ? const Offset(-2, 6) // Shifts slightly left and down
                  : label == 'Bill History'
                      ? const Offset(0, 2) // Shifted upwards compared to others
                      : const Offset(0, 6), // All other 3D icons get shifted down
              child: Transform.scale(
                scale: label == 'Add Customer' 
                    ? 1.7 
                    : label == 'Bulk Message'
                        ? 1.55 // Slightly larger than default
                        : label == 'Bill History'
                            ? 1.52 // Adjusted scale for Bill History
                            : 1.45, // Default scale
                child: Image.asset(imageAsset, height: 52, fit: BoxFit.contain), 
              ),
            ),
            const SizedBox(height: 8), // Increased gap
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11, // Reduced font size slightly
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4), // Increased gap
            Text(
              subLabel,
              style: GoogleFonts.inter(
                fontSize: 8, // Reduced font size slightly
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomDashboardHeader extends StatelessWidget {
  const _CustomDashboardHeader({required this.data, required this.bottomOverlap});

  final DashboardState data;
  final Widget bottomOverlap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 95), // Adjusted bottom padding to fine-tune spacing
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Image
          Container(
            height: 280, // Further reduced height
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/header_bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight, // Aligned to top to move content up
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top, // Exact safe area top padding
              20,
              16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Menu & Notifications
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIconButton(
                      icon: Icons.menu,
                      onTap: () {},
                    ),
                    _CircleIconButton(
                      icon: Icons.notifications_none,
                      badgeCount: 3,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Reduced from 28 to pull text upwards
                // Wrap text content to prevent overlapping with image too much
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65, // Tighter constraint
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Text(
                        'Good morning, Ravi 👋',
                        style: AppTypography.body.copyWith(
                          color: AppColors.kSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12, // Further reduced
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Store Name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end, // Align to bottom line (Store)
                        children: [
                          Flexible(
                            child: Text(
                              'Shree Ganesh\nGeneral Store',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24, // Sized appropriately for Playfair Display
                                height: 1.15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Dark black text
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2), // Reduced to move downwards
                            child: Container(
                              padding: const EdgeInsets.all(2), // Reduced from 4
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.keyboard_arrow_down, size: 14), // Reduced from 16
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12), // Reduced from 20 to move PRO PLAN upwards
                      // Pro Plan & Renewal
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Further reduced padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12), // Slightly smaller radius
                              border: Border.all(color: const Color(0xFFF0EBFF), width: 1.0), // Finer border
                            ),
                            child: Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.crown, size: 8, color: Color(0xFF6B4EFF)), // Smaller crown
                                const SizedBox(width: 4),
                                Text(
                                  'PRO PLAN',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: const Color(0xFF6B4EFF),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 8, // Smaller text
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6), // Reduced from 12 to pull text left
                          Expanded(
                            child: Text(
                              '• Renews on 12 Aug 2026',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.kSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 9, // Reduced font size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70), // Ample space for bottom overlap card
              ],
            ),
          ),
          
          // Bottom Overlap Card
          Positioned(
            left: 16,
            right: 16,
            bottom: -110, // Moved upwards
            child: bottomOverlap,
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    this.badgeCount = 0,
    required this.onTap,
  });

  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10), // Reduced from 12
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.kDark, size: 20), // Reduced from 24
          ),
          if (badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.kError,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF97316)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.8, size.width * 0.15, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.35, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.5, size.width * 0.55, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.1, size.width * 0.75, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.4, size.width, 0);

    canvas.drawPath(path, paint);

    // Gradient fill
    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [
          const Color(0xFFF97316).withValues(alpha: 0.2),
          const Color(0xFFF97316).withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);

    // Dot at the end
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width, 0), 4, dotPaint);

    final dotBorderPaint = Paint()
      ..color = const Color(0xFFF97316)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width, 0), 4, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PromoCampaignCard extends StatelessWidget {
  const _PromoCampaignCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFFFF2E8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15, // Shifts image downwards
            bottom: -15, // Allows bleeding off the bottom edge
            left: 40, // Increased to move right
            right: -40, // Increased bleed to move right
            child: Transform.scale(
              scale: 1.25, // Increased zoom
              alignment: Alignment.centerRight, // Anchors the zoom to the right side where the phone is
              child: Image.asset(
                'assets/images/promo_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Reduced vertical padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reach more customers',
                  style: GoogleFonts.inter(
                    fontSize: 9, // Reduced font size
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 0), // Removed gap to move text upwards
                Text(
                  'Send WhatsApp Campaign',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16, // Increased font size
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4), // Increased gap
                SizedBox(
                  width: 200, // Increased width constraint
                  child: Text(
                    'Promote offers and increase sales effortlessly.',
                    style: GoogleFonts.inter(
                      fontSize: 9, // Reduced font size
                      color: Colors.grey.shade700,
                      height: 1.2, // Increased line height
                    ),
                  ),
                ),
                const SizedBox(height: 12), // Reduced gap before button
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () => context.go('/bulk-message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A45),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Increased padding
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create Campaign',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12), // Increased text size
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 16, color: Colors.white), // Increased icon size
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
