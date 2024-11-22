using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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
}