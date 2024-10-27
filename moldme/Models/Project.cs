using System;

namespace DefaultNamespace;

public class Project
{
    public string projectID { get; set; } 
    public string name { get; set; } 
    public string description { get; set; }

    public string status { get; set; }
    public decimal budget { get; set; } 

    public string startDate { get; set; }
    public string endDate { get; set; }

    public string companyID { get; set; } 
}