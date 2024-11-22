using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Interface
{
/// <summary>
/// Interface for Company
/// </summary>
    public interface ICompany
    {
        
        /// <summary>
        /// Creates a new company.
        /// </summary>
        /// <param name="companyDto">The Data Transfer Object of the Company.</param>
        /// <returns>
        /// Returns:
        /// - 201 Created: If the company is created successfully.
        /// - 400 Bad Request: If the company data is invalid.
        /// </returns>
        IActionResult CompanyCreate([FromBody] CompanyDto companyDto);
        
        /// <summary>
        /// Lists the payment history for a specified company.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the payment history is found.
        /// - 404 Not Found: If the specified company is not found.
        /// </returns>
        IActionResult ListPaymentHistory(string companyId);
        
        /// <summary>
        /// Upgrades the subscription plan for a specified company.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company.</param>
        /// <param name="subscriptionPlan">The new subscription plan.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the subscription plan is upgraded successfully.
        /// - 400 Bad Request: If the company ID or subscription plan is invalid.
        /// - 404 Not Found: If the specified company is not found.
        /// </returns>
        IActionResult UpgradePlan(string companyId, SubscriptionPlan subscriptionPlan);
        
        /// <summary>
        /// Subscribes a specified company to a new plan.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company.</param>
        /// <param name="subscriptionPlan">The new subscription plan.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the subscription is successful.
        /// - 400 Bad Request: If the company ID or subscription plan is invalid.
        /// - 404 Not Found: If the specified company is not found.
        /// </returns>
        IActionResult SubscribePlan(string companyId, SubscriptionPlan subscriptionPlan);
        
        /// <summary>
        /// Cancels the subscription for a specified company.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the subscription is canceled successfully.
        /// - 400 Bad Request: If the company ID is invalid.
        /// - 404 Not Found: If the specified company is not found.
        /// </returns>
        IActionResult CancelSubscription(string companyId);
    }
}