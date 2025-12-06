using System.ComponentModel.DataAnnotations;

namespace Bubble.Models
{
    public class Carrito
    {
        public int Id { get; set; }
        public int UsuarioId { get; set; }
        public DateTime FechaCreacion { get; set; }

        // Propiedades de navegación
        public Usuario Usuario { get; set; }
        public ICollection<CarritoDetalle> CarritoDetalles { get; set; }
    }
}
