using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using moldme.data;
using moldme.DTOs;
using moldme.Interface;
using moldme.Models;

namespace moldme.Controllers;

/// <summary>
/// Controller for Offer
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class OfferController : ControllerBase, IOffer
{
    /// <summary>
    /// Database context
    /// </summary>
    private readonly ApplicationDbContext _context;

    /// <summary>
    /// Constructor for OfferController
    /// </summary>
    /// <param name="offerContext"></param>
    public OfferController(ApplicationDbContext offerContext)
    {
        _context = offerContext;
    }

    ///<inheritdoc cref="IOffer.OfferSend(OfferDto,string,string)"/>
    [Authorize]
    [HttpPost("sendOffer")]
    public IActionResult OfferSend([FromBody] OfferDto offerDto, string companyId, string projectId)
    {
        // Search for the companyID in the database
        var company = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);

        if (company == null)
            return NotFound("Company not found");

        // Search for the projectID in the database
        var project = _context.Projects.FirstOrDefault(p => p.ProjectId == projectId);

        if (project == null)
            return NotFound("Project not found");

        // Create a new Offer entity from the DTO
        var offer = new Offer
        {
            CompanyId = company.CompanyId,
            ProjectId = project.ProjectId,
            Date = offerDto.Date,
            Status = offerDto.Status,
            Description = offerDto.Description,
            Company = company,
            Project = project
        };

        // Query the database to add the offer
        _context.Offers.Add(offer.Status == Status.PENDING
            ? offer
            : throw new Exception("Offer status must be PENDING"));
        // Save changes to the database
        _context.SaveChanges();

        return Ok("Offer sent successfully");
    }

    ///<inheritdoc cref="IOffer.OfferAccept(string,string,string)"/>
    [Authorize]
    [HttpPut("acceptOffer/{offerId}")]
    public async Task<IActionResult> OfferAccept(string companyId, string projectId, string offerId)
    {
        // Search for the companyID in the database
        var company = await _context.Companies.FirstOrDefaultAsync(c => c.CompanyId == companyId);

        if (company == null)
            return NotFound("Company not found");

        // Search for the projectID in the database
        var project = await _context.Projects.FirstOrDefaultAsync(p => p.ProjectId == projectId);

        if (project == null)
            return NotFound("Project not found");

        // Search for the offerID in the database
        var offer = await _context.Offers.FirstOrDefaultAsync(o => o.OfferId == offerId);

        if (offer == null)
            return NotFound("Offer not found");

        // Verifica se a oferta pertence à empresa correta
        if (offer.CompanyId != company.CompanyId)
            return BadRequest("Offer does not belong to the specified company.");

        // Verifica se a oferta pertence ao projeto correto
        if (offer.ProjectId != project.ProjectId)
            return BadRequest("Offer does not belong to the specified project.");

        offer.Status = Status.ACCEPTED; // Altera o status da oferta para aceite

        await _context.SaveChangesAsync();

        return Ok("Offer accepted successfully");
    }

    ///<inheritdoc cref="IOffer.OfferReject(string,string,string)"/>
    [Authorize]
    [HttpPut("rejectOffer/{offerId}")]
    public async Task<IActionResult> OfferReject(string companyId, string projectId, string offerId)
    {
        // Search for the companyID in the database
        var company = await _context.Companies.FirstOrDefaultAsync(c => c.CompanyId == companyId);

        if (company == null)
            return NotFound("Company not found");

        // Search for the projectID in the database
        var project = await _context.Projects.FirstOrDefaultAsync(p => p.ProjectId == projectId);

        if (project == null)
            return NotFound("Project not found");

        // Search for the offerID in the database
        var offer = await _context.Offers.FirstOrDefaultAsync(o => o.OfferId == offerId);

        if (offer == null)
            return NotFound("Offer not found");

        // Verifica se a oferta pertence à empresa correta
        if (offer.CompanyId != company.CompanyId)
            return BadRequest("Offer does not belong to the specified company.");

        // Verifica se a oferta pertence ao projeto correto
        if (offer.ProjectId != project.ProjectId)
            return BadRequest("Offer does not belong to the specified project.");

        offer.Status = Status.DENIED; // Altera o status da oferta para rejeitada

        await _context.SaveChangesAsync();

        return Ok("Offer rejected successfully");
    }

    ///<inheritdoc cref="IOffer.OfferGetAll(string)"/>
    [Authorize]
    [HttpGet("getOffers/{companyId}")]
    public async Task<IActionResult> OfferGetAll(string companyId)
    {
        if (companyId.IsNullOrEmpty())
            return BadRequest("Company ID is required");

        var company = await _context.Companies.FirstOrDefaultAsync(c => c.CompanyId == companyId);

        if (company == null)
            return NotFound("Company not found");

        var offers = await _context.Offers.Where(o => o.CompanyId == company.CompanyId).ToListAsync();

        return Ok(offers);
    }
}