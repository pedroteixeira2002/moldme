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

        /// <summary>
        /// Get all reviews from an employee
        /// </summary>
        /// <param name="employeeId"> The Unique Identification of an employee</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the reviews are found and returned successfully.
        /// - 400 Bad Request: If the employee ID is invalid.
        /// - 404 Not Found: If the specified employee is not found.
        /// </returns>
        Task<IActionResult> ReviewGetAll(string employeeId);

    }
}