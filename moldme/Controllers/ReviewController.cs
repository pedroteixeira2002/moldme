using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using moldme.data;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Controllers;


[ApiController]
[Route("api/[controller]")]
public class ReviewController : ControllerBase
{
    private readonly ApplicationDbContext dbContext;

    public ReviewController(ApplicationDbContext reviewContext)
    {
        dbContext = reviewContext;
    }
    
    [Authorize]
    [HttpPost("addReview")]
    public async Task<IActionResult> AddReview([FromBody] ReviewDto reviewDto)
    {   
        if (reviewDto == null)
        {
            return BadRequest("Review data is null");
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var reviewer = await dbContext.Employees.FindAsync(reviewDto.ReviewerId);;
    
        if (reviewer == null)
            return NotFound("Reviewer not found");
    
        var reviewedEmployeeEntity = await dbContext.Employees.FindAsync(reviewDto.ReviewedId);
    
        if (reviewedEmployeeEntity == null)
            return NotFound("Reviewed Employee not found");
    
        var review = new Review
        {
            ReviewID = Guid.NewGuid().ToString().Substring(0, 6), // Gera um ID único de 6 caracteres
            Comment = reviewDto.Comment,
            Stars = reviewDto.Stars,
            date = DateTime.Now,  // Define a data atual como data da avaliação
            ReviewerId = reviewer.EmployeeID, // Associa o ID do revisor
            ReviewedId = reviewedEmployeeEntity.EmployeeID // Associa o ID do avaliado
        };
    
        // Adiciona a avaliação ao banco de dados
        await dbContext.Reviews.AddAsync(review);
        await dbContext.SaveChangesAsync();
    
        // Retorna uma resposta com sucesso
        return Ok("Review added successfully");
    }

}