import 'package:clickcut_mobile/core/dtos/business_statement_count.dart';
import 'package:clickcut_mobile/features/auth/domain/entities/user.dart';

class BusinessStatement {
  final String name;
  final double revenue;
  final double revenueGoal;
  final User userSession;
  final String? logoUrl;
  final String? bannerUrl;
  final Counts count;

  BusinessStatement({
    required this.name,
    required this.revenue,
    required this.revenueGoal,
    required this.userSession,
    this.logoUrl,
    this.bannerUrl,
    required this.count,
  });

  factory BusinessStatement.fromJson(Map<String, dynamic> json) {
    return BusinessStatement(
      name: json['name'] ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
      revenueGoal: (json['revenueGoal'] ?? 0).toDouble(),
      userSession: User.fromJson(json['userSession'] ?? {}),
      logoUrl: json['logoUrl'],
      bannerUrl: json['bannerUrl'],
      count: Counts.fromJson(json['count'] ?? {}),
    );
  }

  double get progressPercentage {
    if (revenueGoal == 0) return 0;
    return (revenue / revenueGoal) * 100;
  }
}