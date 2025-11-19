using System.ComponentModel.DataAnnotations;

namespace PiNewsCore.Models
{
    public class Member
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string UserName { get; set; } = string.Empty;

        public string? Email { get; set; }
    }
}
