using Microsoft.AspNetCore.Mvc;
using moldme.data;

namespace DefaultNamespace
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public EmployeeController(ApplicationDbContext context)
        {
            _context = context;
        }
        
        [HttpPost]
        public IActionResult AddEmployee([FromBody] Employee employee)
        {
            if (employee == null)
            {
                return BadRequest("Employee data is required");
            }
            
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Employees.Add(employee); 
            _context.SaveChanges();

            return CreatedAtAction(nameof(GetEmployeeById), new { employeeId = employee.EmployeeID }, employee);
        }

        
        [HttpPut("EditEmployee/{employeeId}")]
        public IActionResult EditEmployee(string employeeId, [FromBody] Employee updatedEmployee)
        {
            if (updatedEmployee == null)
            {
                return BadRequest("Updated employee data is required");
            }

            
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var existingEmployee = _context.Employees.Find(employeeId); 

            if (existingEmployee == null)
            {
                return NotFound("Employee not found");
            }

            existingEmployee.Name = updatedEmployee.Name;
            existingEmployee.Profession = updatedEmployee.Profession;
            existingEmployee.NIF = updatedEmployee.NIF;
            existingEmployee.Email = updatedEmployee.Email;
            existingEmployee.Contact = updatedEmployee.Contact;
            existingEmployee.Password = updatedEmployee.Password;
            existingEmployee.CompanyID = updatedEmployee.CompanyID;

            _context.SaveChanges(); 

            return Ok(existingEmployee);
        }

        // Remove an employee
        [HttpDelete("RemoveEmployee/{employeeId}")]
        public IActionResult RemoveEmployee(string employeeId)
        {
            var existingEmployee = _context.Employees.Find(employeeId);

            if (existingEmployee == null)
            {
                return NotFound("Employee not found");
            }

            _context.Employees.Remove(existingEmployee); // Remove the employee
            _context.SaveChanges();

            return Ok($"Employee with ID {employeeId} removed successfully");
        }

        // List all employees
        [HttpGet("ListAllEmployees")]
        public IActionResult ListAllEmployees()
        {
            var employees = _context.Employees.ToList(); // List all employees
            return Ok(employees);
        }

        // Get employee by ID
        [HttpGet("{employeeId}")]
        public IActionResult GetEmployeeById(string employeeId)
        {
            var employee = _context.Employees.Find(employeeId); // Adjust to your DbSet
            if (employee == null)
            {
                return NotFound("Employee not found");
            }

            return Ok(employee);
        }
    }
}
