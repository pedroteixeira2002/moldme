enum SubscriptionPlan {
  Basic,  // 0
  Pro,    // 1
  Premium,// 2
  Free,   // 3
  none,  
}

extension SubscriptionPlanExtension on SubscriptionPlan {
  String get name {
    switch (this) {
      case SubscriptionPlan.Free:
        return 'Free';
      case SubscriptionPlan.Basic:
        return 'Basic';
      case SubscriptionPlan.Pro:
        return 'Pro';
      case SubscriptionPlan.Premium:
        return 'Premium';
      default:
        return 'none';
    }
  }
}