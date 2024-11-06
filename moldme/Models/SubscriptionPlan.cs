namespace moldme.Models;

public enum SubscriptionPlan
{
    Basic,
    Pro,
    Premium,
    None
}
public static class SubscriptionPlanHelper
{
    public static float GetPlanPrice(SubscriptionPlan plan)
    {
        return plan switch
        {
            SubscriptionPlan.None => 0,
            SubscriptionPlan.Basic => 9.99f,
            SubscriptionPlan.Pro => 19.99f,
            SubscriptionPlan.Premium => 29.99f,
            _ => throw new ArgumentOutOfRangeException(nameof(plan), "Unknown plan type")
        };
    }
}