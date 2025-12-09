// Models/Producto.cs
namespace Bubble.Models
{
    public class Producto
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public decimal Precio { get; set; }
        public string ImagenUrl { get; set; }
        public int TiendaId { get; set; }
        public int CategoriaProductoId { get; set; }
        public int Tienda { get; set; }
        public string CategoriaProducto { get; set; }
    }
}