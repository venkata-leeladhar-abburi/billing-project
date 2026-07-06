import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/icon_container.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/notifications_notifier.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  (IconData, Color, Color) _style(NotificationType type) {
    switch (type) {
      case NotificationType.creditLow:
        return (Icons.warning_amber_outlined, AppColors.kWarning, const Color(0xFFFFFBEB));
      case NotificationType.paymentSuccess:
        return (Icons.check_circle_outline, AppColors.kGreen, AppColors.kGreenLight);
      case NotificationType.paymentFailed:
        return (Icons.error_outline, AppColors.kError, const Color(0xFFFEF2F2));
      case NotificationType.billDelivered:
        return (Icons.check_circle_outline, AppColors.kGreen, AppColors.kGreenLight);
      case NotificationType.bulkSent:
        return (Icons.campaign_outlined, AppColors.kBlue, AppColors.kBlueLight);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text('Notifications', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
            child: Text('Mark all read', style: AppTypography.body.copyWith(color: AppColors.kOrange, fontSize: 13)),
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => data.notifications.isEmpty
            ? const EmptyState(
                type: EmptyStateType.notifications,
                title: 'No notifications yet',
              )
            : ListView.separated(
                padding: EdgeInsets.all(AppSpacing.s16),
                itemCount: data.notifications.length,
                separatorBuilder: (context, index) => SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  final n = data.notifications[index];
                  final (icon, color, bg) = _style(n.type);
                  return AppCard(
                    leftBorderColor: n.isRead ? null : AppColors.kOrange,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconContainer(icon: icon, iconColor: color, backgroundColor: bg, size: 40, iconSize: 20),
                        SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                              SizedBox(height: AppSpacing.s4),
                              Text(n.body, style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary)),
                            ],
                          ),
                        ),
                        Text(Formatters.formatRelativeTime(n.timestamp), style: AppTypography.caption),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
