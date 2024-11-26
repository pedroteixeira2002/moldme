using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

using System.ComponentModel.DataAnnotations;

/// <summary>
/// Represents an offer made by a company for a project.
/// </summary>
public class Offer
{
    /// <summary>
    /// Gets or sets the unique identifier for the offer.
    /// </summary>
    [Key, StringLength(36)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public String OfferId { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the company making the offer.
    /// </summary>
    [Required, MaxLength(36)] 
    public string CompanyId { get; set; }
    
    /// <summary>
    /// Gets or sets the company making the offer.
    /// </summary>
    [ForeignKey("CompanyId")] 
    public Company Company { get; set; }
    
    /// <summary>
    /// Gets or sets the unique identifier for the project associated with the offer.
    /// </summary>
    [Required, MaxLength(36)] 
    public string ProjectId { get; set; }
    
    /// <summary>
    /// Gets or sets the project associated with the offer.
    /// </summary>
    [ForeignKey("ProjectId")] 
    public Project Project { get; set; }
    
    /// <summary>
    /// Gets or sets the date and time when the offer was made.
    /// </summary>
    [Required, DataType(DataType.DateTime)]
    public DateTime Date { get; set; }
    
    /// <summary>
    /// Gets or sets the status of the offer.
    /// </summary>
    [Required, EnumDataType(typeof(Status))]
    public Status Status { get; set; }
    
    /// <summary>
    /// Gets or sets the description of the offer.
    /// </summary>
    [Required, StringLength(256)] 
    public String Description { get; set; }
}