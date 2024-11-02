using Microsoft.AspNetCore.Mvc;
using moldme.data;
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
    
    [HttpPost("addReview")]
    public IActionResult AddReview(string reviewerID, string reviewedEmployee,[FromBody] Review review)
    {
        // Verifica se se o reviwewerID é válido
        var _reviewer = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == reviewerID);
        
        // Se o reviewerID não for válido, retorna um erro
        if (_reviewer == null)
            return NotFound("Reviewer not found");
        
        // Verifica se se o reviewedEmployee é válido
        var _reviewedEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == reviewedEmployee);
        
        // Se o reviewedEmployee não for válido, retorna um erro
        if (_reviewedEmployee == null)
            return NotFound("Reviewed Employee not found");
        
        
        // Associa o Reviewer e o ReviewedEmployee à avaliação
        review.ReviewerID = _reviewer.EmployeeID;
        review.ReviewedId = _reviewedEmployee.EmployeeID;
        
        // Adiciona a avaliação ao banco de dados
        dbContext.Reviews.Add(review);
        dbContext.SaveChanges();
        
        return Ok("Review added successfully");
    }
}