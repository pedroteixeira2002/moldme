namespace DefaultNamespace;

public class Project
{
    public int projectId { get; set; }
    public string name { get; set; }
    public string description { get; set; }
    public DateTime startDate { get; set; }
    public DateTime endDate { get; set; }
    public enum Status
    {
        Opened,
        Closed,
    }
    public float price { get; set; }
    public Status status { get; set; }
    
}