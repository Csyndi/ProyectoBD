using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bubble.Models
{
    public class Producto
    {
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Nombre { get; set; }

        [MaxLength(1000)]
        public string Descripcion { get; set; }

        [Required]
        [Column(TypeName = "decimal(18,2)")]
        public decimal Precio { get; set; }

        [MaxLength(500)]
        public string ImagenUrl { get; set; }

        [Required]
        public int TiendaId { get; set; }

        // Cambiar esto para que sea nullable
        public int? CategoriaProductoId { get; set; } // ← Cambiado a int?

        // Relaciones
        public Tienda Tienda { get; set; }
        public CategoriaProducto CategoriaProducto { get; set; }

        // Colecciones
        public ICollection<CarritoDetalle> CarritoDetalles { get; set; }
        public ICollection<DetalleVenta> DetalleVentas { get; set; }
    }
}
