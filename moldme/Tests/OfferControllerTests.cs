using Xunit;
using Moq;
using Microsoft.AspNetCore.Mvc;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using System.Linq;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Task = System.Threading.Tasks.Task;

using moldme.DTOs;

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

        var offerDto = new OfferDto
        {
            OfferId = "1",
            CompanyId = "1",
            ProjectId = "1",
            Date = DateTime.Now,
            Status = Status.PENDING,
            Description = "Description 1"
        };

        var result = controller.SendOffer(offerDto) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Offer sent successfully", result.Value);

        var addedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "1");
        Assert.NotNull(addedOffer);
        Assert.Equal("1", addedOffer.CompanyId);
        Assert.Equal("1", addedOffer.ProjectId);
    }
}

[Fact]
public async Task SendOffer_InvalidCompany_ReturnsNotFound()
{
    using (var dbContext = GetInMemoryDbContext())
    {
        SeedData(dbContext);

        var controller = new OfferController(dbContext);

        var offerDto = new OfferDto
        {
            OfferId = "1",
            CompanyId = "invalid", // Non-existent company ID
            ProjectId = "1",
            Date = DateTime.Now,
            Status = Status.PENDING,
            Description = "Description 1"
        };

        var result = controller.SendOffer(offerDto) as NotFoundObjectResult;

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

        var offerDto = new OfferDto
        {
            OfferId = "1",
            CompanyId = "1",
            ProjectId = "invalid", // Non-existent project ID
            Date = DateTime.Now,
            Status = Status.PENDING,
            Description = "Description 1"
        };

        var result = controller.SendOffer(offerDto) as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project not found", result.Value);
    }
}
}