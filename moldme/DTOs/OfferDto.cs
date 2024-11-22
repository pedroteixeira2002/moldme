using moldme.Models;

namespace moldme.DTOs;

/// <summary>
/// Data transfer object for Offer model.
/// </summary>
public class OfferDto
{
    /// <summary>
    /// Offer's unique identifier.
    /// </summary>
    public DateTime Date { get; set; }

    /// <summary>
    /// Offer's unique identifier.
    /// </summary>
    public Status Status { get; set; }

    /// <summary>
    /// Offer's unique identifier.
    /// </summary>
    public string Description { get; set; }
}