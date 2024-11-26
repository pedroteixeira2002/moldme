namespace moldme.Models;

/// <summary>
/// Represents the status of an entity.
/// </summary>
public enum Status
{
    /// <summary>
    /// The entity is new.
    /// </summary>
    NEW,

    /// <summary>
    /// The entity is in progress.
    /// </summary>
    INPROGRESS,

    /// <summary>
    /// The entity is done.
    /// </summary>
    DONE,

    /// <summary>
    /// The entity is closed.
    /// </summary>
    CLOSED,

    /// <summary>
    /// The entity is canceled.
    /// </summary>
    CANCELED,

    /// <summary>
    /// The entity is pending.
    /// </summary>
    PENDING,

    /// <summary>
    /// The entity is accepted.
    /// </summary>
    ACCEPTED,

    /// <summary>
    /// The entity is denied.
    /// </summary>
    DENIED,
}