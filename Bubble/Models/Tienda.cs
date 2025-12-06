using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bubble.Models
{
    public class Tienda
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public string Direccion { get; set; }
        public string Telefono { get; set; }
        public int UsuarioId { get; set; } // Propiedad agregada
        public int CategoriaId { get; set; } // O CategoriaTiendaId

        // Propiedades de navegación
        public Usuario Usuario { get; set; } // Propiedad agregada
        public CategoriaTienda Categoria { get; set; }
        public ICollection<Producto> Productos { get; set; }
        public ICollection<Venta> Ventas { get; set; }
    }
}
