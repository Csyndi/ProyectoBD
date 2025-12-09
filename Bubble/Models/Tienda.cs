// Models/Tienda.cs
namespace Bubble.Models
{
    public class Tienda
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public int UsuarioId { get; set; }
        public string Usuario { get; set; }
    }
}