using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;

namespace moldme.Interface
{
    /// <summary>
    /// Interface for Task
    /// </summary>
    public interface ITask
    {
        /// <summary>
        /// Create a task
        /// </summary>
        /// <param name="taskDto"> Data Transfer Object of Task</param>
        /// <param name="projectId">Identification of the project which the task belongs to</param>
        /// <param name="employeeId">Identification of the person responsible for this task</param>
    
        IActionResult TaskCreate(TaskDto taskDto, string projectId, string employeeId);

        /// <summary>
        /// Get all tasks from a project
        /// </summary>
        /// <param name="projectId">Identification of the project which we want the list from</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the task is updated successfully.
        /// - 400 Bad Request: If the task ID or task data is invalid.
        /// - 404 Not Found: If the specified task is not found.
        /// </returns>
        IActionResult TaskGetAll(string projectId);

        /// <summary>
        /// Get a task by its ID
        /// </summary>
        /// <param name="taskId">The Task Identification we search for</param>
        /// <returns> The Task </returns>
        IActionResult TaskGetById(string taskId);

        /// <summary>
        /// Get the file of a task
        /// </summary>
        /// <param name="taskId"></param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the file is found and returned successfully.
        /// - 400 Bad Request: If the task ID is invalid.
        /// - 404 Not Found: If the specified task is not found.
        /// - 500 Internal Server Error: If the file is not found.
        /// - 415 Unsupported Media Type: If the file type is not supported.
        /// </returns>
        IActionResult TaskGetFile(string taskId);
        
        /// <summary>
        /// Update a task
        /// </summary>
        /// <param name="taskId">The Task Identification we need to update</param>
        /// <param name="updatedTaskDto">The Data Transfer Object that contains the updated information</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the task is updated successfully.
        /// - 400 Bad Request: If the task ID or task data is invalid.
        /// - 404 Not Found: If the specified task is not found.
        /// </returns>
        IActionResult TaskUpdate(string taskId, TaskDto taskDto);

        /// <summary>
        /// Delete a task
        /// </summary>
        /// <param name="taskId">The Task Identification we need to delete</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the task is deleted successfully.
        /// - 400 Bad Request: If the task ID is invalid.
        /// - 404 Not Found: If the specified task is not found.
        /// </returns>
        IActionResult TaskDelete(string taskId);
    }
}