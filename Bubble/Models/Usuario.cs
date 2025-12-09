// Models/Usuario.cs
using System.ComponentModel.DataAnnotations;

namespace Bubble.Models
{
    public class Usuario
    {
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Nombre { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        public string Contrasena { get; set; }
        public string Rol { get; set; } = "Cliente";
        public DateTime FechaCreacion { get; set; } = DateTime.Now;
        public bool Activo { get; set; } = true;
    }
}