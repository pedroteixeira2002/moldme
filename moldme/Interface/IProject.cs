using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;

namespace moldme.Interface
{
    /// <summary>
    /// Interface for Project
    /// </summary>
    public interface IProject
    {
        /// <summary>
        /// Creates a new project for a specified company.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company which the project belongs to.</param>
        /// <param name="projectDto">The Data Transfer Object of the Project.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the project is created successfully.
        /// - 404 Not Found: If the specified company is not found.
        /// </returns>
        IActionResult ProjectCreate(string companyId, [FromBody] ProjectDto projectDto);

        /// <summary>
        /// Updates an existing project.
        /// </summary>
        /// <param name="projectId">The Unique Identification of the project to be updated.</param>
        /// <param name="updatedProjectDto">The Data Transfer Object containing updated project details.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the project is updated successfully.
        /// - 404 Not Found: If the specified project is not found.
        /// </returns>
        IActionResult ProjectUpdate(string projectId, [FromBody] ProjectDto updatedProjectDto);

        /// <summary>
        /// Removes a specific project.
        /// </summary>
        /// <param name="projectId">The Unique Identification of the project to be removed.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the project is removed successfully.
        /// - 404 Not Found: If the specified project is not found.
        /// </returns>
        IActionResult ProjectRemove(string projectId);

        /// <summary>
        /// Retrieves the details of a specific project.
        /// </summary>
        /// <param name="projectId">The Unique Identification of the project to be viewed.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the project is found.
        /// - 404 Not Found: If the specified project is not found.
        /// </returns>
        IActionResult ProjectView(string projectId);

        /// <summary>
        /// Assigns an employee to a specific project.
        /// </summary>
        /// <param name="employeeId">The Unique Identification of the employee to be assigned.</param>
        /// <param name="projectId">The Unique Identification of the project to which the employee will be assigned.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the employee is assigned to the project successfully.
        /// - 400 Bad Request: If the employee ID or project ID is invalid.
        /// - 404 Not Found: If the specified employee or project is not found.
        /// - 409 Conflict: If the employee is already assigned to the project.
        /// </returns>
        IActionResult ProjectAssignEmployee(string employeeId, string projectId);

        /// <summary>
        /// Removes an employee from a specific project.
        /// </summary>
        /// <param name="employeeId">The Unique Identification of the employee to be removed.</param>
        /// <param name="projectId">The Unique Identification of the project from which the employee will be removed.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the employee is removed from the project successfully.
        /// - 400 Bad Request: If the employee ID or project ID is invalid.
        /// - 404 Not Found: If the specified employee or project is not found, or if the employee is not assigned to the project.
        /// </returns>
        IActionResult ProjectRemoveEmployee(string employeeId, string projectId);

        /// <summary>
        /// Lists all projects for a specific company.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company whose projects are to be listed.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the projects are found.
        /// - 404 Not Found: If the specified company is not found.
        /// </returns>
        Task<IActionResult> ListAllProjectsFromCompany(string companyId);

        /// <summary>
        /// Retrieves the details of a specific project by its ID and company ID.
        /// </summary>
        /// <param name="companyId">The Unique Identification of the company which the project belongs to.</param>
        /// <param name="projectId">The Unique Identification of the project to be viewed.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the project is found.
        /// - 404 Not Found: If the specified company or project is not found, or if the project does not belong to the specified company.
        /// </returns>
        Task<IActionResult> GetProjectById(string companyId, string projectId);
    }
}