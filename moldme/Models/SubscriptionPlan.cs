namespace moldme.Models;

/// <summary>
/// Represents the subscription plans available.
/// </summary>
public enum SubscriptionPlan
{
    /// <summary>
    /// Basic subscription plan.
    /// </summary>
    Basic,

    /// <summary>
    /// Pro subscription plan.
    /// </summary>
    Pro,

    /// <summary>
    /// Premium subscription plan.
    /// </summary>
    Premium,

    /// <summary>
    /// No subscription plan.
    /// </summary>
    None
}

/// <summary>
/// Provides helper methods for subscription plans.
/// </summary>
public static class SubscriptionPlanHelper
{
    /// <summary>
    /// Gets the price of the specified subscription plan.
    /// </summary>
    /// <param name="plan">The subscription plan.</param>
    /// <returns>The price of the subscription plan.</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown when the subscription plan is unknown.</exception>
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