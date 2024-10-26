using System;
using System.Collections.Generic;
using System.Linq;

namespace DefaultNamespace
{
    public class InMemoryRepositoryEmployee
    {
        private readonly List<Employee> _employees = new();

        public void AddEmployee(Employee employee)
        {
            _employees.Add(employee); 
        }

        public void EditEmployee(int employeeId, Employee updatedEmployee)
        {
            var index = _employees.FindIndex(e => e.EmployeeId == employeeId);
            if (index != -1)
            {
                _employees[index] = updatedEmployee; 
            }
        }
        public void RemoveEmployee(int employeeId)
        {
            _employees.RemoveAll(e => e.EmployeeId == employeeId); 
        }

        public Employee GetEmployeeById(int employeeId)
        {
            return _employees.FirstOrDefault(e => e.EmployeeId == employeeId); 
        }

        public List<Employee> ListAllEmployees()
        {
            return _employees; 
        }

        public void SaveChanges()
        {
            throw new NotImplementedException();
        }
    }
}