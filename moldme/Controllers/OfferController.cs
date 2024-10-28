using Microsoft.AspNetCore.Mvc;
using moldme.data;
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
    [HttpPost("sendOffer")]
    public IActionResult SendOffer(string companyId, string projectId, [FromBody] Offer offer)
    {
        // Search for the companyID in the database
        var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyId);
        
        if (company == null)
            return NotFound("Company not found");
        
        // Search for the projectID in the database
        var project = dbContext.Projects.FirstOrDefault(p => p.ProjectId == projectId);
        
        if (project == null)
            return NotFound("Project not found");
        
        // Associa a oferta à empresa e ao projeto através das chaves estrangeiras
        offer.CompanyId = company.CompanyID;
        offer.ProjectId = project.ProjectId;
        
        // Query the database to add the offer
        dbContext.Offers.Add(offer.Status == Status.PENDING ? offer : throw new Exception("Offer status must be PENDING"));
        // Save changes to the database
        dbContext.SaveChanges();

        return Ok("Offer sent successfully");
    }
    
}