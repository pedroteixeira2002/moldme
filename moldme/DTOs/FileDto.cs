namespace moldme.DTOs;

public class FileDto
{
    public string TaskId { get; set; }
    public string FileName { get; set; }
    public byte[] FileContent { get; set; }
    public string MimeType { get; set; }
}