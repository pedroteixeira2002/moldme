using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;
using System.ComponentModel.DataAnnotations;

public class Offer
{
    [Key, StringLength(6)]
    public String OfferId { get; set; }
    
    [ForeignKey("Company")]
    public string CompanyId { get; set; }
    
    [ForeignKey("Project")]
    public string ProjectId { get; set; }
    
    [Required, DataType(DataType.DateTime)]
    public DateTime Date { get; set; }
    
    [Required, EnumDataType(typeof(Status))]
    public Status Status { get; set; }
    
    [Required, StringLength(256)]
    public String Description { get; set; }
    
}