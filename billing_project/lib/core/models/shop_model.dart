import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'plan_type.dart';

enum ShopStatus { active, pendingSetup, suspended }

extension ShopStatusColor on ShopStatus {
  Color get dotColor {
    switch (this) {
      case ShopStatus.active:
        return AppColors.kGreen;
      case ShopStatus.pendingSetup:
        return AppColors.kWarning;
      case ShopStatus.suspended:
        return AppColors.kError;
    }
  }
}

enum AutoPayStatus { active, pending, failed }

class ShopModel {
  const ShopModel({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.businessType,
    required this.plan,
    required this.status,
    this.salespersonName,
    this.phone = '',
    this.whatsappNumber = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.pinCode = '',
    this.gstNumber,
    this.addedDate,
    this.templateName = '',
    this.monthlyAmount = 0,
    this.autopayStatus = AutoPayStatus.active,
    this.nextBillingDate,
    this.billCreditsUsed = 0,
    this.billCreditsLimit = 0,
    this.msgCreditsUsed = 0,
    this.msgCreditsLimit = 0,
    this.customerCount = 0,
    this.customerLimit,
    this.billsSentThisMonth = 0,
    this.lastActiveAt,
  });

  final String id;
  final String shopName;
  final String ownerName;
  final String businessType;
  final SubscriptionPlan plan;
  final ShopStatus status;
  final String? salespersonName;
  final String phone;
  final String whatsappNumber;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String? gstNumber;
  final DateTime? addedDate;
  final String templateName;
  final double monthlyAmount;
  final AutoPayStatus autopayStatus;
  final DateTime? nextBillingDate;
  final int billCreditsUsed;
  final int billCreditsLimit;
  final int msgCreditsUsed;
  final int msgCreditsLimit;
  final int customerCount;
  final int? customerLimit; // null = unlimited
  final int billsSentThisMonth;
  final DateTime? lastActiveAt;

  ShopModel copyWith({
    String? shopName,
    String? ownerName,
    String? businessType,
    SubscriptionPlan? plan,
    ShopStatus? status,
    String? salespersonName,
    String? phone,
    String? whatsappNumber,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? gstNumber,
    String? templateName,
    double? monthlyAmount,
    int? billCreditsUsed,
    int? billCreditsLimit,
    int? msgCreditsUsed,
    int? msgCreditsLimit,
  }) {
    return ShopModel(
      id: id,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      businessType: businessType ?? this.businessType,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      salespersonName: salespersonName ?? this.salespersonName,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      gstNumber: gstNumber ?? this.gstNumber,
      addedDate: addedDate,
      templateName: templateName ?? this.templateName,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      autopayStatus: autopayStatus,
      nextBillingDate: nextBillingDate,
      billCreditsUsed: billCreditsUsed ?? this.billCreditsUsed,
      billCreditsLimit: billCreditsLimit ?? this.billCreditsLimit,
      msgCreditsUsed: msgCreditsUsed ?? this.msgCreditsUsed,
      msgCreditsLimit: msgCreditsLimit ?? this.msgCreditsLimit,
      customerCount: customerCount,
      customerLimit: customerLimit,
      billsSentThisMonth: billsSentThisMonth,
      lastActiveAt: lastActiveAt,
    );
  }
}
