namespace DefaultNamespace;

public class Company
{
    public int companyId { get; set; }
    public string name { get; set; }
    public int taxid { get; set; }
    public string address { get; set; }
    public int contact { get; set; }
    public string email { get; set; }
    public string sector { get; set; }
    public enum Plan
    {
        Basic,
        Pro,
        Premium,
    }
    public Plan plan { get; set; }
    public string password { get; set; }
    public List<Project> projects { get; set; } = new List<Project>();
    public List<Employee> employees { get; set; }






