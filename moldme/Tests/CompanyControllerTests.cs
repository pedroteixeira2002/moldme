using DefaultNamespace;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using Xunit;
using System;
using System.Linq;
using moldme.Models;

public class CompanyControllerTests
{
    [Fact]
    public void AddProjectTest()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString()) 
            .Options;

        using (var dbContext = new ApplicationDbContext(options))
        {
            var company = new Company
            {
                CompanyID = "1",
                Name = "Company 1",
                Address = "Address 1",
                Email = "[email protected]",
                Contact = 123456789,
                TaxId = 123456789,
                Sector = "Sector 1",
                Plan = SubscriptionPlan.Premium,
                Password = "password"
            };

            dbContext.Companies.Add(company);
            dbContext.SaveChanges();
            
            var controller = new CompanyController(dbContext);
            
            var project = new Project
            {
                ProjectId = "1",
                Name = "Project 1",
                Description = "Description 1",
                Budget = 1000,
                Status = Status.INPROGRESS,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now.AddDays(30),
                CompanyId = company.CompanyID
            };
            
            var result = controller.AddProject(company.CompanyID, project) as OkObjectResult;
            Assert.NotNull(result); 
            Assert.Equal("Project added successfully", result.Value);
            
            var addedProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == "1");
            Assert.NotNull(addedProject);
            Assert.Equal("1", addedProject.CompanyId);
        }
    }

    [Fact]
    public void EditProjectTest()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "Edit_project_database")
            .Options;

        using (var dbContext = new ApplicationDbContext(options))
        {
            var company = new Company
            {
                CompanyID = "1",
                Name = "Company 1",
                Address = "Address 1",
                Email = "[email protected]",
                Contact = 123456789,
                TaxId = 123456789,
                Sector = "Sector 1",
                Plan = SubscriptionPlan.Premium,
                Password = "password"
            };

            var project = new Project
            {
                ProjectId = "1",
                Name = "Original Project",
                Description = "Original Description",
                Budget = 5000,
                Status = Status.INPROGRESS,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now.AddDays(30),
                CompanyId = company.CompanyID
            };

            dbContext.Companies.Add(company);
            dbContext.Projects.Add(project);
            dbContext.SaveChanges();

            var controller = new CompanyController(dbContext);
            
            var updatedProject = new Project
            {
                ProjectId = "1",
                Name = "Updated Project",
                Description = "Updated Description",
                Budget = 10000,
                Status = Status.DONE,
                StartDate = DateTime.Now.AddDays(-10),
                EndDate = DateTime.Now.AddDays(20),
                CompanyId = company.CompanyID
            };
            
            var result = controller.EditProject("1", updatedProject) as OkObjectResult;
            
            Assert.NotNull(result);
            var updatedProjectFromDb = result.Value as Project;
            Assert.Equal("Updated Project", updatedProjectFromDb.Name);
            Assert.Equal(10000, updatedProjectFromDb.Budget);
            Assert.Equal(Status.DONE, updatedProjectFromDb.Status);
        }
    }
    [Fact]
    public void ViewProjectTest()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "View_project_database")
                .Options;

            using (var dbContext = new ApplicationDbContext(options))
            {
                var project = new Project
                {
                    ProjectId = "1",
                    Name = "View Project",
                    Description = "View Description",
                    Budget = 3000,
                    Status = Status.INPROGRESS,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddDays(60),
                    CompanyId = "1"
                };

                dbContext.Projects.Add(project);
                dbContext.SaveChanges();

                var controller = new CompanyController(dbContext);
                
                var result = controller.ViewProject("1") as OkObjectResult;
                Assert.NotNull(result);
                var projectFromDb = result.Value as Project;
                Assert.Equal("View Project", projectFromDb.Name);
                Assert.Equal("View Description", projectFromDb.Description);
            }
        }

        [Fact]
        public void RemoveProjectTest()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "Remove_project_database")
                .Options;

            using (var dbContext = new ApplicationDbContext(options))
            {
                var project = new Project
                {
                    ProjectId = "1",
                    Name = "Remove Project",
                    Description = "To be removed",
                    Budget = 4000,
                    Status = Status.INPROGRESS,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddDays(45),
                    CompanyId = "1"
                };

                dbContext.Projects.Add(project);
                dbContext.SaveChanges();

                var controller = new CompanyController(dbContext);
                var result = controller.RemoveProject("1") as OkObjectResult;
                Assert.NotNull(result);
                Assert.Equal("Project removed successfully", result.Value);

                var removedProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == "1");
                Assert.Null(removedProject);
            }
        }
    }