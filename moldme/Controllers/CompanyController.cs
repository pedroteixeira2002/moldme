namespace DefaultNamespace;

[ApiController]
[Rout("api/[controller]")]
public class CompanyController : Controller
{
    private readonly InMemoryRepository _repository;
    //isto é só para simular uma db 
    public CompanyController(InMemoryRepository repository)
    {
        _repository = repository;
    }
    
    [HttpPost]
    public IActionResult AddProject(int companyId, Project project)
    {
        var company = _repository.GetCompany(companyId);
        
        if (company == null )
            return NotFound("Company not found");
    }
    //logica do genero _repository.(add project) falta a base de dados
    company.savechanges();
    
    
    // apenas exemplo falta a db
    [HttpPut("EditProject/{projectId}")]
    public IActionResult EditProject(int projectId, Project updatedProject)
    {
        var existingProject = _repository.GetProjectById(projectId);

        if (existingProject == null)
        {
            return NotFound("Project not found");
        }

        _repository.EditProject(projectId, updatedProject);
        _repository.SaveChanges();

        return Ok(existingProject);
    }
}


}