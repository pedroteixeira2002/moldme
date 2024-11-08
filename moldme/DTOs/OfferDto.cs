using moldme.Models;

namespace moldme.DTOs;

public class OfferDto 
{
    public string OfferId { get; set; }
    public string CompanyId { get; set; }
    public string ProjectId { get; set; }
    public DateTime Date { get; set; }
    public Status Status { get; set; }
    public string Description { get; set; }
}