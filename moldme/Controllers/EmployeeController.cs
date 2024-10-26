using Microsoft.AspNetCore.Mvc;

namespace DefaultNamespace
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : Controller
    {
        private readonly InMemoryRepositoryEmployee _repositoryEmployee;

        public EmployeeController(InMemoryRepositoryEmployee repositoryEmployee)
        {
            _repositoryEmployee = repositoryEmployee;
        }

        [HttpPost]
        public IActionResult AddEmployee(Employee employee)
        {
            if (employee == null)
            {
                return BadRequest("Employee data is required");
            }

            _repositoryEmployee.AddEmployee(employee); // Adiciona o funcionário
            return Ok(employee); // Retorna o funcionário adicionado
        }

        [HttpPut("EditEmployee/{employeeId}")]
        public IActionResult EditEmployee(int employeeId, Employee updatedEmployee)
        {
            var existingEmployee = _repositoryEmployee.GetEmployeeById(employeeId);

            if (existingEmployee == null)
            {
                return NotFound("Employee not found");
            }

            _repositoryEmployee.EditEmployee(employeeId, updatedEmployee); // Atualiza o funcionário
            return Ok(existingEmployee); // Retorna o funcionário atualizado
        }

        [HttpDelete("RemoveEmployee/{employeeId}")]
        public IActionResult RemoveEmployee(int employeeId)
        {
            var existingEmployee = _repositoryEmployee.GetEmployeeById(employeeId);

            if (existingEmployee == null)
            {
                return NotFound("Employee not found");
            }

            _repositoryEmployee.RemoveEmployee(employeeId); // Remove o funcionário
            return Ok($"Employee with ID {employeeId} removed successfully");
        }

        [HttpGet("ListAllEmployees")]
        public IActionResult ListAllEmployees()
        {
            var employees = _repositoryEmployee.ListAllEmployees(); // Lista todos os funcionários
            return Ok(employees);
        }
    }
}