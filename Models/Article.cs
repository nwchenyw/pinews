using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PiNewsCore.Models
{
    public class Article
    {
        [Key]
        public int Id { get; set; }
    [Required]
    [MaxLength(250)]
    public string Title { get; set; } = string.Empty;

    public string? Content { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public int? CategoryId { get; set; }
    public Category? Category { get; set; }
    }
}
