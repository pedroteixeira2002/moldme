using System.Collections.Generic;
using DefaultNamespace;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.Models; // Ensure your Employee model is correctly imported
using Xunit;

namespace moldme.Tests
{
    public class EmployeeControllerTest
    {
        private readonly EmployeeController _controller;
        private readonly ApplicationDbContext _context;

        public EmployeeControllerTest()
        {
            // Setting up an in-memory database for testing
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDatabase")
                .Options;

            _context = new ApplicationDbContext(options);
            _controller = new EmployeeController(_context);
        }

        [Fact]
        public void AddEmployee_ReturnsOkResult_WhenEmployeeIsAdded()
        {
            // Arrange
            var employee = new Employee { StaffID = "E001", Name = "John Doe", Profession = "Developer", NIF = 123456789, Email = "john.doe@example.com", Password = "password" };

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
            var employeeId = "E001"; // Using string as per your Employee model
            var existingEmployee = new Employee { StaffID = employeeId, Name = "John Doe", Profession = "Developer", NIF = 123456789, Email = "john.doe@example.com", Password = "password" };
            _context.Employees.Add(existingEmployee);
            _context.SaveChanges();

            var updatedEmployee = new Employee { StaffID = employeeId, Name = "Jane Doe", Profession = "Senior Developer", NIF = 987654321, Email = "jane.doe@example.com", Password = "newpassword" };

            // Act
            var result = _controller.EditEmployee(employeeId, updatedEmployee);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            var returnedEmployee = Assert.IsType<Employee>(okResult.Value);
            Assert.Equal("Jane Doe", returnedEmployee.Name);
        }

        [Fact]
        public void EditEmployee_ReturnsNotFound_WhenEmployeeDoesNotExist()
        {
            // Arrange
            var employeeId = "E999"; // Non-existing employee ID
            var updatedEmployee = new Employee { StaffID = employeeId };

            // Act
            var result = _controller.EditEmployee(employeeId, updatedEmployee);

            // Assert
            Assert.IsType<NotFoundObjectResult>(result);
        }

        [Fact]
        public void RemoveEmployee_ReturnsOkResult_WhenEmployeeExists()
        {
            // Arrange
            var employeeId = "E001";
            var employee = new Employee { StaffID = employeeId, Name = "John Doe", Profession = "Developer", NIF = 123456789, Email = "john.doe@example.com", Password = "password" };
            _context.Employees.Add(employee);
            _context.SaveChanges();

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
                new Employee { StaffID = "E001", Name = "John Doe", Profession = "Developer", NIF = 123456789, Email = "john.doe@example.com", Password = "password" },
                new Employee { StaffID = "E002", Name = "Jane Smith", Profession = "Designer", NIF = 987654321, Email = "jane.smith@example.com", Password = "password" }
            };
            _context.Employees.AddRange(employees);
            _context.SaveChanges();

            // Act
            var result = _controller.ListAllEmployees();

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            var returnedEmployees = Assert.IsAssignableFrom<List<Employee>>(okResult.Value);
            Assert.Equal(employees.Count, returnedEmployees.Count);
        }
    }
}
