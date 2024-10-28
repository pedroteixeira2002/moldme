using Xunit;
using Moq;
using Microsoft.AspNetCore.Mvc;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using System.Linq;
using System.Collections.Generic;
using DefaultNamespace;
using Microsoft.EntityFrameworkCore;

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
            EndDate = DateTime.Now.AddDays(30),
            CompanyId = company.CompanyID
        };

        dbContext.Companies.Add(company);
        dbContext.Projects.Add(project);
        dbContext.SaveChanges();
    }

    [Fact]
    public void AddOfferTest()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var offer = new Offer
            {
                OfferId = "1",
                CompanyId = "1",
                ProjectId = "1",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };

            var result = controller.SendOffer("1", "1", offer) as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer sent successfully", result.Value);

            var addedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "1");
            Assert.NotNull(addedOffer);
            Assert.Equal("1", addedOffer.CompanyId);
            Assert.Equal("1", addedOffer.ProjectId);
        }
    }

    [Fact]
    public void SendOffer_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var offer = new Offer
            {
                OfferId = "1",
                CompanyId = "invalid",
                ProjectId = "1",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };

            var result = controller.SendOffer("invalid", "1", offer) as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }

    [Fact]
    public void SendOffer_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new OfferController(dbContext);

            var offer = new Offer
            {
                OfferId = "1",
                CompanyId = "1",
                ProjectId = "invalid",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };

            var result = controller.SendOffer("1", "invalid", offer) as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }
}