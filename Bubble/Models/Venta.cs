// Models/Venta.cs
namespace Bubble.Models
{
    public class Venta
    {
        public int Id { get; set; }
        public int UsuarioId { get; set; }
        public DateTime FechaVenta { get; set; } = DateTime.Now;
        public decimal Total { get; set; }
        public string Estado { get; set; } = "Pendiente";
        public string Usuario { get; set; }
        public string DetalleVentas { get; set; }
    }
}