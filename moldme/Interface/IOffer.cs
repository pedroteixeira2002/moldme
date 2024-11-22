using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;

namespace moldme.Interface
{
    /// <summary>
    /// Interface for Offer
    /// </summary>
    public interface IOffer
    {
        /// <summary>
        /// Sends an offer for a specified company and project.
        /// </summary>
        /// <param name="offerDto">The Data Transfer Object of the Offer.</param>
        /// <param name="companyId">The Unique Identification of the company which the offer belongs to.</param>
        /// <param name="projectId">The Unique Identification of the project which the offer is for.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the offer is sent successfully.
        /// - 404 Not Found: If the specified company or project is not found.
        /// </returns>
        IActionResult OfferSend([FromBody] OfferDto offerDto, string companyId, string projectId);

        /// <summary>
        /// Accepts an offer for a specified company and project.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company which the offer belongs to.</param>
        /// <param name="projectId">The Unique Identification of the project which the offer is for.</param>
        /// <param name="offerId">The Unique Identification of the offer to be accepted.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the offer is accepted successfully.
        /// - 404 Not Found: If the specified company, project, or offer is not found.
        /// </returns>
        Task<IActionResult> OfferAccept(string companyId, string projectId, string offerId);

        /// <summary>
        /// Rejects an offer for a specified company and project.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company which the offer belongs to.</param>
        /// <param name="projectId">The Unique Identification of the project which the offer is for.</param>
        /// <param name="offerId">The Unique Identification of the offer to be rejected.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the offer is rejected successfully.
        /// - 404 Not Found: If the specified company, project, or offer is not found.
        /// </returns>
        Task<IActionResult> OfferReject(string companyId, string projectId, string offerId);
    }
}