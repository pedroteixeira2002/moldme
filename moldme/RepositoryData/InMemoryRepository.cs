using System.Collections.Generic;
using System.Linq;
using DefaultNamespace;

namespace moldme.Controllers;

public class InMemoryRepository
{
    private readonly List<Company> _companies = new List<Company>();
    private int _nextCompanyId = 1;
    private int _nextProjectId = 1;

    // Adiciona uma nova empresa
    public void AddCompany(Company company)
    {
        company.companyId = _nextCompanyId++;
        _companies.Add(company);
    }

    // Obtém uma empresa pelo ID
    public Company GetCompany(int companyId)
    {
        return _companies.FirstOrDefault(c => c.companyId == companyId);
    }

    // Adiciona um novo projeto a uma empresa
    public void AddProject(int companyId, Project project)
    {
        var company = GetCompany(companyId);
        if (company != null)
        {
            project.projectId = _nextProjectId++;
            company.projects.Add(project);
        }
    }

    // Edita um projeto existente de uma empresa
    public bool EditProject(int projectId, Project updatedProject)
    {
        var project = GetProjectById(projectId);
        if (project != null)
        {
            project.name =updatedProject.name;
            project.description= updatedProject.description;
            project.price = updatedProject.price;
            project.status = updatedProject.status;
            project.startDate = updatedProject.startDate;
            project.endDate = updatedProject.endDate;
            return true;
        }
        return false;
    }

    // Obtém um projeto pelo ID
    public Project GetProjectById(int projectId)
    {
        return _companies
            .SelectMany(c => c.projects)
            .FirstOrDefault(p => p.projectId == projectId);
    }

    // Remove um projeto pelo ID
    public bool RemoveProject(int projectId)
    {
        var project = GetProjectById(projectId);
        if (project != null)
        {
            var company = _companies.FirstOrDefault(c => c.projects.Contains(project));
            if (company != null)
            {
                company.projects.Remove(project);
                return true;
            }
        }
        return false;
    }

    // Salva as alterações (simulação)
    public void SaveChanges()
    {
        // Aqui, não é necessário fazer nada já que os dados estão em memória.
    }
}
