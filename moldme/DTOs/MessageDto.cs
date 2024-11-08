namespace moldme.DTOs;

public class MessageDto
{
    public required String Text { get; set; }
    public required String SenderId { get; set; }
    public required String ChatId { get; set; }
}