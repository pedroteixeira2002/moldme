using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;

namespace moldme.Interface
{
    /// <summary>
    /// Interface for Review
    /// </summary>
    public interface IReview
    {
        /// <summary>
        /// Add a review
        /// </summary>
        /// <param name="reviewDto"> Data Transfer Object of a review</param>
        /// <param name="reviewerId"> The Unique Identification of an employee that will perform the review</param>
        /// <param name="reviewedId">The Unique Identification of an employee that will be reviewed</param>
        /// <returns>
        /// Returns:
        /// - 201 Created: If the review is created successfully.
        /// - 400 Bad Request: If the review data is invalid.
        /// - 404 Not Found: If the reviewer or reviewed employee is not found.
        /// </returns>
        Task<IActionResult> ReviewCreate([FromBody] ReviewDto reviewDto, string reviewerId, string reviewedId);
    }
}