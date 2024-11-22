using Xunit;
using Microsoft.AspNetCore.Mvc;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Microsoft.EntityFrameworkCore;
using moldme.DTOs;
using Task = System.Threading.Tasks.Task;

namespace moldme.Tests;

public class OfferControllerTests
{
    private ApplicationDbContext GetInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options);
    }

    private void SeedData(ApplicationDbContext dbContext)
    {
        var company = new Company
        {
            CompanyID = "1",
            Name = "Company 1",
            Address = "Address 1",
            Email = "email@example.com",
            Contact = 123456789,
            TaxId = 123456789,
            Sector = "Sector 1",
            Plan = SubscriptionPlan.Premium,
            Password = "password"
        };

        var project = new Project
        {
            ProjectId = "1",
            Name = "Project 1",
            Description = "Description 1",
            Budget = 1000,
            Status = Status.INPROGRESS,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now,
            CompanyId = company.CompanyID
        };

        dbContext.Companies.Add(company);
        dbContext.Projects.Add(project);
        dbContext.SaveChanges();
    }

    [Fact]
    public void Offer_Properties_GetterSetter_WorksCorrectly()
    {
        var offer = new Offer
        {
            OfferId = "OFFER01",
            CompanyId = "C12345",
            ProjectId = "P12345",
            Date = new DateTime(2023, 10, 1),
            Status = Status.PENDING,
            Description = "Offer Description",
            Company = new Company
            {
                CompanyID = "1",
                Name = "Company 1",
                Address = "Address 1",
                Email = "email@example.com",
                Contact = 123456789,
                TaxId = 123456789,
                Sector = "Sector 1",
                Plan = SubscriptionPlan.Premium,
                Password = "password"
            },
            Project = new Project
            {
                ProjectId = "1",
                Name = "Project 1",
                Description = "Description 1",
                Budget = 1000,
                Status = Status.INPROGRESS,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = "1"
            }
        };


        Assert.Equal("OFFER01", offer.OfferId);
        Assert.Equal("C12345", offer.CompanyId);
        Assert.Equal("P12345", offer.ProjectId);
        Assert.Equal(new DateTime(2023, 10, 1), offer.Date);
        Assert.Equal(Status.PENDING, offer.Status);
        Assert.Equal("Offer Description", offer.Description);
        Assert.Equal("Company 1", offer.Company.Name);
        Assert.Equal("Project 1", offer.Project.Name);


        offer.CompanyId = "C67890";
        offer.ProjectId = "P67890";
        offer.Date = new DateTime(2023, 11, 1);
        offer.Status = Status.ACCEPTED;
        offer.Description = "Updated Offer Description";
        offer.Company = new Company
        {
            CompanyID = "2",
            Name = "Company 2",
            Address = "Address 2",
            Email = "email2@example.com",
            Contact = 987654321,
            TaxId = 987654321,
            Sector = "Sector 2",
            Plan = SubscriptionPlan.Basic,
            Password = "password2"
        };
        offer.Project = new Project
        {
            ProjectId = "2",
            Name = "Project 2",
            Description = "Description 2",
            Budget = 2000,
            Status = Status.DONE,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now,
            CompanyId = "2"
        };
        Assert.Equal("C67890", offer.CompanyId);
        Assert.Equal("P67890", offer.ProjectId);
        Assert.Equal(new DateTime(2023, 11, 1), offer.Date);
        Assert.Equal(Status.ACCEPTED, offer.Status);
        Assert.Equal("Updated Offer Description", offer.Description);
        Assert.Equal("Company 2", offer.Company.Name);
        Assert.Equal("Project 2", offer.Project.Name);
    }

    [Fact]
    public async Task AddOfferTest()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var project = new Project
            {
                ProjectId = "PROJ01",
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = "1"
            };
            dbContext.Projects.Add(project);
            
            var CompanyId = "1";
            var ProjectId = "1";
            
            var offerDto = new OfferDto
            {
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };
            
            dbContext.SaveChanges();
            

            var result = controller.OfferSend(offerDto, CompanyId, ProjectId) as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer sent successfully", result.Value);
        }
    }

    [Fact]
    public async Task SendOffer_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var CompanyId = "invalid";
            var ProjectId = "1";
            var offerDto = new OfferDto
            {
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };

            var result = controller.OfferSend(offerDto, CompanyId, ProjectId) as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }

    [Fact]
    public async Task SendOffer_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);
            var CompanyId = "1";
            var ProjectId = "invalid";
            var offerDto = new OfferDto
            {
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };

            var result = controller.OfferSend(offerDto, CompanyId, ProjectId) as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }

    // Testes para o método OfferAccept
    [Fact]
    public async Task OfferAccept_ShouldReturnOk_WhenOfferIsAccepted()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);
            var project = new Project
            {
                ProjectId = "PROJ01",
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = "1"
            };
            dbContext.Projects.Add(project);
            var offer = new Offer
            {
                OfferId = "OFFER01",
                CompanyId = "1",
                ProjectId = "PROJ01",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };
            dbContext.Offers.Add(offer);

            dbContext.SaveChanges();
            var result = await controller.OfferAccept("1", "PROJ01", "OFFER01") as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer accepted successfully", result.Value);

            var acceptedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "OFFER01");
            Assert.NotNull(acceptedOffer);
            Assert.Equal(Status.ACCEPTED, acceptedOffer.Status);
        }
    }

    [Fact]
    public async Task OfferAccept_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var result = await controller.OfferAccept("invalid", "PROJ01", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }


    [Fact]
    public async Task OfferAccept_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);
            var project = new Project
            {
                ProjectId = "PROJ01",
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = "1"
            };
            dbContext.Projects.Add(project);
            dbContext.SaveChanges();

            var result = await controller.OfferAccept("1", "invalid", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }

    [Fact]
    public async Task OfferAccept_InvalidOffer_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);
            var project = new Project
            {
                ProjectId = "PROJ01",
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = "1"
            };
            dbContext.Projects.Add(project);
            dbContext.SaveChanges();

            var result = await controller.OfferAccept("1", "PROJ01", "invalid") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer not found", result.Value);
        }
    }

    // Testes para o método OfferReject
    [Fact]
    public async Task OfferReject_ShouldReturnOk_WhenOfferIsRejected()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);
            
            var project = new Project
            {
                ProjectId = "PROJ01",
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = "1"
            };
            dbContext.Projects.Add(project);
            var offer = new Offer
            {
                OfferId = "OFFER01",
                CompanyId = "1",
                ProjectId = "PROJ01",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };
            dbContext.Offers.Add(offer);

            dbContext.SaveChanges();

            var result = await controller.OfferReject("1", "PROJ01", "OFFER01") as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer rejected successfully", result.Value);

            var rejectedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "OFFER01");
            Assert.NotNull(rejectedOffer);
            Assert.Equal(Status.DENIED, rejectedOffer.Status);
        }
    }

    [Fact]
    public async Task OfferReject_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var result = await controller.OfferReject("invalid", "PROJ01", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }

    [Fact]
    public async Task OfferReject_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var result = await controller.OfferReject("1", "invalid", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }

    [Fact]
    public async Task OfferReject_InvalidOffer_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var project = new Project
            {
                ProjectId = "PROJ01",
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = "1"
            };
            dbContext.Projects.Add(project);
            var offer = new Offer
            {
                OfferId = "OFFER01",
                CompanyId = "1",
                ProjectId = "PROJ01",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };
            dbContext.Offers.Add(offer);
            dbContext.SaveChanges();
            
            var result = await controller.OfferReject("1", "PROJ01", "invalid") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer not found", result.Value);
        }
    }
}