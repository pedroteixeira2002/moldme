using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Xunit;
using DefaultNamespace; 

namespace moldme.Tests
{
    public class EmployeeControllerTest
    {
        private readonly EmployeeController _controller;
        private readonly InMemoryRepositoryEmployee _repositoryEmployee;

        public EmployeeControllerTest()
        {
            _repositoryEmployee = new InMemoryRepositoryEmployee();
            _controller = new EmployeeController(_repositoryEmployee);
        }

        [Fact]
        public void AddEmployee_ReturnsOkResult_WhenEmployeeIsAdded()
        {
            // Arrange
            var employee = new Employee { EmployeeId = 1 };

            // Act
            var result = _controller.AddEmployee(employee);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            Assert.Equal(employee, okResult.Value);
        }

        [Fact]
        public void EditEmployee_ReturnsOkResult_WhenEmployeeExists()
        {
            // Arrange
            var employeeId = 1;
            var existingEmployee = new Employee { EmployeeId = employeeId };
            var updatedEmployee = new Employee { EmployeeId = employeeId };

            // Add the existing employee to the repository
            _repositoryEmployee.AddEmployee(existingEmployee);

            // Act
            var result = _controller.EditEmployee(employeeId, updatedEmployee);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            Assert.Equal(existingEmployee, okResult.Value);
        }

        [Fact]
        public void EditEmployee_ReturnsNotFound_WhenEmployeeDoesNotExist()
        {
            // Arrange
            var employeeId = 1;
            var updatedEmployee = new Employee { EmployeeId = employeeId };

            // Act
            var result = _controller.EditEmployee(employeeId, updatedEmployee);

            // Assert
            Assert.IsType<NotFoundObjectResult>(result);
        }

        [Fact]
        public void RemoveEmployee_ReturnsOkResult_WhenEmployeeExists()
        {
            // Arrange
            var employeeId = 1;
            var employee = new Employee { EmployeeId = employeeId };
            _repositoryEmployee.AddEmployee(employee);

            // Act
            var result = _controller.RemoveEmployee(employeeId);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            Assert.Equal($"Employee with ID {employeeId} removed successfully", okResult.Value);
        }

        [Fact]
        public void ListAllEmployees_ReturnsOkResult()
        {
            // Arrange
            var employees = new List<Employee>
            {
                new Employee { EmployeeId = 1 },
                new Employee { EmployeeId = 2 }
            };
            foreach (var employee in employees)
            {
                _repositoryEmployee.AddEmployee(employee);
            }

            // Act
            var result = _controller.ListAllEmployees();

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            var returnedEmployees = Assert.IsAssignableFrom<List<Employee>>(okResult.Value);
            Assert.Equal(employees.Count, returnedEmployees.Count);
        }

       
    }
}
