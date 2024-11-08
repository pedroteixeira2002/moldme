using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using moldme.data;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Controllers;

[ApiController]
[Route("api/[controller]")]

public class OfferController : ControllerBase
{
    // Access to the database context
    private readonly ApplicationDbContext dbContext;
    
    public OfferController(ApplicationDbContext offerContext)
    {
        dbContext = offerContext;
    }
    
    // Enviar uma oferta para um projeto associado a uma empresa
    [Authorize]
    [HttpPost("sendOffer")]
    public IActionResult SendOffer([FromBody] OfferDto offerDto)
    {
        // Search for the companyID in the database
        var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == offerDto.CompanyId);

        if (company == null)
            return NotFound("Company not found");

        // Search for the projectID in the database
        var project = dbContext.Projects.FirstOrDefault(p => p.ProjectId == offerDto.ProjectId);

        if (project == null)
            return NotFound("Project not found");

        // Create a new Offer entity from the DTO
        var offer = new Offer
        {
            OfferId = offerDto.OfferId,
            CompanyId = company.CompanyID,
            ProjectId = project.ProjectId,
            Date = offerDto.Date,
            Status = offerDto.Status,
            Description = offerDto.Description
        };

        // Query the database to add the offer
        dbContext.Offers.Add(offer.Status == Status.PENDING ? offer : throw new Exception("Offer status must be PENDING"));
        // Save changes to the database
        dbContext.SaveChanges();

        return Ok("Offer sent successfully");
    }
    
}