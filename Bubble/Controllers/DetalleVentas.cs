using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Bubble.Models;
using BubbleI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BubbleI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DetalleVentasController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public DetalleVentasController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/DetalleVentas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<DetalleVenta>>> GetDetalleVentas()
        {
            return await _context.DetalleVentas
                .Include(dv => dv.Venta)
                .Include(dv => dv.Producto)
                .ToListAsync();
        }

        // GET: api/DetalleVentas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<DetalleVenta>> GetDetalleVenta(int id)
        {
            var detalleVenta = await _context.DetalleVentas
                .Include(dv => dv.Venta)
                .Include(dv => dv.Producto)
                .FirstOrDefaultAsync(dv => dv.Id == id);

            if (detalleVenta == null)
            {
                return NotFound();
            }

            return detalleVenta;
        }

        // GET: api/DetalleVentas/venta/5
        [HttpGet("venta/{ventaId}")]
        public async Task<ActionResult<IEnumerable<DetalleVenta>>> GetDetallesPorVenta(int ventaId)
        {
            return await _context.DetalleVentas
                .Where(dv => dv.VentaId == ventaId)
                .Include(dv => dv.Producto)
                .ToListAsync();
        }

        private bool DetalleVentaExists(int id)
        {
            return _context.DetalleVentas.Any(e => e.Id == id);
        }
    }
}