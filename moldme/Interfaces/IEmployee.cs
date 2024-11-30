using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace moldme.Interfaces;

public interface IEmployee
{
    public IActionResult ListAllEmployees();
    public IActionResult GetEmployeeById(string employeeId);
    public Task<IActionResult> GetEmployeeProjects(string employeeId);
}