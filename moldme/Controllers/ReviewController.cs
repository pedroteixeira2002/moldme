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
/// Review Controller
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class ReviewController : ControllerBase, IReview
{
    /// <summary>
    /// Database context
    /// </summary>
    private readonly ApplicationDbContext _context;

    /// <summary>
    /// Constructor for Review Controller
    /// </summary>
    /// <param name="reviewContext"></param>
    public ReviewController(ApplicationDbContext reviewContext)
    {
        _context = reviewContext;
    }
    
    ///<inheritdoc cref="IReview.ReviewCreate"/>
    [Authorize]
    [HttpPost("addReview")]
    public async Task<IActionResult> ReviewCreate([FromBody] ReviewDto reviewDto, string reviewerId, string reviewedId)
    {
        if (reviewDto == null)
        {
            return BadRequest("Review data is null");
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var reviewer = await _context.Employees.FindAsync(reviewerId);

        if (reviewer == null)
            return NotFound("Reviewer not found");

        var reviewedEmployeeEntity = await _context.Employees.FindAsync(reviewedId);

        if (reviewedEmployeeEntity == null)
            return NotFound("Reviewed Employee not found");

        var review = new Review
        {
            Comment = reviewDto.Comment,
            Stars = reviewDto.Stars,
            date = DateTime.Now, 
            ReviewerId = reviewer.EmployeeId, 
            ReviewedId = reviewedEmployeeEntity.EmployeeId 
        };

        await _context.Reviews.AddAsync(review);
        await _context.SaveChangesAsync();

        return Ok("Review added successfully");
    }
    ///<inheritdoc cref="IReview.ReviewGetAll"/>
    [Authorize]
    [HttpPost("getReviews")]
    public async Task<IActionResult> ReviewGetAll(string employeeId)
    {
        if (employeeId.IsNullOrEmpty())
            return BadRequest("No employee identification provided");
        
        var reviews = await _context.Reviews.Where(r => r.ReviewedId == employeeId).ToListAsync();

        if (reviews == null)
            return NotFound("No reviews found");

        return Ok(reviews);
    }
}