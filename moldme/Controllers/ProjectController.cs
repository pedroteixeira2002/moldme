using Microsoft.AspNetCore.Mvc;

namespace DefaultNamespace;
// Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class ProjectController : Controller
{
    private readonly List<Project> _projects = new List<Project>();
    

 
    
}