import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_fixtures.dart';

part 'credits_notifier.g.dart';

class TopupPack {
  const TopupPack({
    required this.id,
    required this.name,
    required this.credits,
    required this.creditType,
    required this.price,
    required this.perUnitCost,
  });

  final String id;
  final String name;
  final int credits;
  final String creditType; // 'bill' | 'msg'
  final double price;
  final double perUnitCost;
}

class RecentPayment {
  const RecentPayment({
    required this.planName,
    required this.date,
    required this.amount,
  });

  final String planName;
  final DateTime date;
  final double amount;
}

class CreditsState {
  const CreditsState({
    required this.planName,
    required this.renewalDate,
    required this.billCredits,
    required this.billCreditsLimit,
    required this.msgCredits,
    required this.msgCreditsLimit,
    required this.packs,
    required this.recentPayments,
  });

  final String planName;
  final DateTime renewalDate;
  final int billCredits;
  final int billCreditsLimit;
  final int msgCredits;
  final int msgCreditsLimit;
  final List<TopupPack> packs;
  final List<RecentPayment> recentPayments;
}

@riverpod
class CreditsNotifier extends _$CreditsNotifier {
  @override
  AsyncValue<CreditsState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real creditsRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    state = AsyncValue.data(
      CreditsState(
        planName: 'PRO PLAN',
        renewalDate: DateTime(now.year, now.month + 1, 1),
        billCredits: MockFixtures.billCredits,
        billCreditsLimit: MockFixtures.billCreditsMax,
        msgCredits: MockFixtures.msgCredits,
        msgCreditsLimit: MockFixtures.msgCreditsMax,
        packs: const [
          TopupPack(
            id: 'msg_starter',
            name: 'Starter Pack',
            credits: 100,
            creditType: 'msg',
            price: 120,
            perUnitCost: 1.20,
          ),
          TopupPack(
            id: 'msg_standard',
            name: 'Standard Pack',
            credits: 500,
            creditType: 'msg',
            price: 500,
            perUnitCost: 1.00,
          ),
          TopupPack(
            id: 'bill_booster',
            name: 'Bill Booster',
            credits: 100,
            creditType: 'bill',
            price: 150,
            perUnitCost: 1.50,
          ),
        ],
        recentPayments: [
          RecentPayment(planName: 'Pro Plan', date: now.subtract(const Duration(days: 5)), amount: 599),
          RecentPayment(planName: 'Pro Plan', date: now.subtract(const Duration(days: 35)), amount: 599),
          RecentPayment(planName: 'Pro Plan', date: now.subtract(const Duration(days: 65)), amount: 599),
        ],
      ),
    );
  }
}
