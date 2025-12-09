// Models/Carrito.cs
namespace Bubble.Models
{
    public class Carrito
    {
        public int Id { get; set; }
        public int UsuarioId { get; set; }
        public DateTime FechaCreacion { get; set; } = DateTime.Now;
        public string Usuario { get; set; }
        public string CarritoDetalles { get; set; }
    }
}