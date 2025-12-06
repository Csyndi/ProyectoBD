using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bubble.Models
{
    public class Venta
    {
        public int Id { get; set; }
        public int UsuarioId { get; set; } // Propiedad agregada
        public int TiendaId { get; set; }
        public DateTime FechaVenta { get; set; } // Propiedad agregada
        public decimal Total { get; set; }
        public string Estado { get; set; } // Propiedad agregada

        // Propiedades de navegación
        public Usuario Usuario { get; set; } // Propiedad agregada
        public Tienda Tienda { get; set; }
        public ICollection<DetalleVenta> DetalleVentas { get; set; }
    }
}
