using Microsoft.AspNetCore.Authorization;
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
    [Authorize]
    [HttpPost("sendOffer")]
    public async Task<IActionResult> SendOffer(string companyId, string projectId, [FromBody] Offer offer)
    {
        if (offer == null)
        {
            return BadRequest("Offer is null");
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        // Search for the companyID in the database
        var company = await dbContext.Companies.FindAsync(companyId);
        
        if (company == null)
            return NotFound("Company not found");
        
        // Search for the projectID in the database
        var project =  await dbContext.Projects.FindAsync(projectId);
        
        if (project == null)
            return NotFound("Project not found");
        
        if (offer.Status != Status.PENDING)
        {
            return BadRequest("Offer status must be PENDING");
        }
        
        // Associa a oferta à empresa e ao projeto através das chaves estrangeiras
        offer.CompanyId = company.CompanyID;
        offer.ProjectId = project.ProjectId;
        
        // Query the database to add the offer
        await dbContext.Offers.AddAsync(offer);
        // Save changes to the database
        await dbContext.SaveChangesAsync();

        return Ok("Offer sent successfully");
    }
    
}