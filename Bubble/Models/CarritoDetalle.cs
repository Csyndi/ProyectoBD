using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bubble.Models
{
    public class CarritoDetalle
    {
        public int Id { get; set; }
        public int CarritoId { get; set; }
        public int ProductoId { get; set; }
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; } // Propiedad agregada

        // Propiedades de navegación
        public Carrito Carrito { get; set; }
        public Producto Producto { get; set; }
    }
}
