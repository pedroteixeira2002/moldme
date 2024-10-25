namespace DefaultNamespace;
// Microsoft.AspNetCore.Mvc;

namespace moldme.Controllers;
[ApiController]
[Route("api/[controller]")]
public class ProjectController : Controller
{
    private readonly List<Project> _projects = new List<Project>();
    

 
    
}