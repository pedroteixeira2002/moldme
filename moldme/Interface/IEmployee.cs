using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;

namespace moldme.Interface{
    /// <summary>
    /// Interface for Employee
    /// </summary>
public interface IEmployee
{
    /// <summary>
    /// Creates a new employee for a specified company.
    /// </summary>
    /// <param name="companyId">The Unique Identification of the company to which the employee belongs.</param>
    /// <param name="employeeDto">The Data Transfer Object of the Employee.</param>
    /// <returns>
    /// Returns:
    /// - 201 Created: If the employee is created successfully.
    /// - 400 Bad Request: If the company ID is invalid.
    /// - 404 Not Found: If the specified company is not found.
    /// </returns>
    IActionResult EmployeeCreate(string companyId, [FromBody] EmployeeDto employeeDto);
   
    /// <summary>
    /// Updates an existing employee for a specified company.
    /// </summary>
    /// <param name="companyId">The Unique Identification of the company to which the employee belongs.</param>
    /// <param name="employeeId">The Unique Identification of the employee to be updated.</param>
    /// <param name="updatedEmployeeDto">The Data Transfer Object of the updated Employee.</param>
    /// <returns>
    /// Returns:
    /// - 200 OK: If the employee is updated successfully.
    /// - 400 Bad Request: If the company ID or employee ID is invalid.
    /// - 404 Not Found: If the specified company or employee is not found.
    /// </returns>
    IActionResult EmployeeUpdate(string companyId, string employeeId, [FromBody] EmployeeDto updatedEmployeeDto);
    
    /// <summary>
    /// Removes an existing employee from a specified company.
    /// </summary>
    /// <param name="companyId">The Unique Identification of the company to which the employee belongs.</param>
    /// <param name="employeeId">The Unique Identification of the employee to be removed.</param>
    /// <returns>
    /// Returns:
    /// - 200 OK: If the employee is removed successfully.
    /// - 400 Bad Request: If the company ID or employee ID is invalid.
    /// - 404 Not Found: If the specified company or employee is not found.
    /// </returns>
    IActionResult EmployeeRemove(string companyId, string employeeId);
    
    /// <summary>
    /// Retrieves an employee by their unique ID.
    /// </summary>
    /// <param name="employeeId">The Unique Identification of the employee to be retrieved.</param>
    /// <returns>
    /// Returns:
    /// - 200 OK: If the employee is found.
    /// - 404 Not Found: If the specified employee is not found.
    /// </returns>
    IActionResult GetEmployeeById(string employeeId);
    
    /// <summary>
    /// Retrieves all projects assigned to a specific employee.
    /// </summary>
    /// <param name="employeeId">The Unique Identification of the employee whose projects are to be retrieved.</param>
    /// <returns>
    /// Returns:
    /// - 200 OK: If the projects are found.
    /// - 404 Not Found: If the specified employee is not found.
    /// </returns>
    Task<IActionResult> GetEmployeeProjects(string employeeId);
    
    /// <summary>
    /// Lists all employees for a specified company.
    /// </summary>
    /// <param name="companyId">The Unique Identification of the company whose employees are to be listed.</param>
    /// <returns>
    /// Returns:
    /// - 200 OK: If the employees are found.
    /// - 404 Not Found: If the specified company is not found.
    /// </returns>
    IActionResult EmployeeListAll(string companyId);
}
}