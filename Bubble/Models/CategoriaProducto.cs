using System.ComponentModel.DataAnnotations;

namespace Bubble.Models
{
    public class CategoriaProducto
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public ICollection<Producto> Productos { get; set; }
    }
}
