using System;
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
    public class VentasController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public VentasController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Ventas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Venta>>> GetVentas()
        {
            return await _context.Ventas
                .Include(v => v.Usuario)
                .Include(v => v.Tienda)
                .Include(v => v.DetalleVentas)
                .ThenInclude(dv => dv.Producto)
                .ToListAsync();
        }

        // GET: api/Ventas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Venta>> GetVenta(int id)
        {
            var venta = await _context.Ventas
                .Include(v => v.Usuario)
                .Include(v => v.Tienda)
                .Include(v => v.DetalleVentas)
                .ThenInclude(dv => dv.Producto)
                .FirstOrDefaultAsync(v => v.Id == id);

            if (venta == null)
            {
                return NotFound();
            }

            return venta;
        }

        // GET: api/Ventas/usuario/5
        [HttpGet("usuario/{usuarioId}")]
        public async Task<ActionResult<IEnumerable<Venta>>> GetVentasPorUsuario(int usuarioId)
        {
            return await _context.Ventas
                .Where(v => v.UsuarioId == usuarioId)
                .Include(v => v.Tienda)
                .Include(v => v.DetalleVentas)
                .ThenInclude(dv => dv.Producto)
                .ToListAsync();
        }

        // GET: api/Ventas/tienda/5
        [HttpGet("tienda/{tiendaId}")]
        public async Task<ActionResult<IEnumerable<Venta>>> GetVentasPorTienda(int tiendaId)
        {
            return await _context.Ventas
                .Where(v => v.TiendaId == tiendaId)
                .Include(v => v.Usuario)
                .Include(v => v.DetalleVentas)
                .ThenInclude(dv => dv.Producto)
                .ToListAsync();
        }

        // POST: api/Ventas/crear-desde-carrito
        [HttpPost("crear-desde-carrito")]
        public async Task<ActionResult<Venta>> CrearVentaDesdeCarrito([FromBody] CrearVentaRequest request)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                // Obtener carrito del usuario
                var carrito = await _context.Carritos
                    .Include(c => c.CarritoDetalles)
                    .ThenInclude(cd => cd.Producto)
                    .FirstOrDefaultAsync(c => c.UsuarioId == request.UsuarioId);

                if (carrito == null || !carrito.CarritoDetalles.Any())
                {
                    return BadRequest("El carrito está vacío");
                }

                // Crear nueva venta
                var venta = new Venta
                {
                    UsuarioId = request.UsuarioId,
                    TiendaId = request.TiendaId,
                    FechaVenta = DateTime.Now,
                    Estado = "Pendiente",
                    Total = 0
                };

                _context.Ventas.Add(venta);
                await _context.SaveChangesAsync();

                decimal totalVenta = 0;

                // Crear detalles de venta
                foreach (var detalleCarrito in carrito.CarritoDetalles)
                {
                    var detalleVenta = new DetalleVenta
                    {
                        VentaId = venta.Id,
                        ProductoId = detalleCarrito.ProductoId,
                        Cantidad = detalleCarrito.Cantidad,
                        PrecioUnitario = detalleCarrito.Producto.Precio,
                        Subtotal = detalleCarrito.Cantidad * detalleCarrito.Producto.Precio
                    };

                    totalVenta += detalleVenta.Subtotal;
                    _context.DetalleVentas.Add(detalleVenta);

                    // Limpiar carrito
                    _context.CarritoDetalles.Remove(detalleCarrito);
                }

                // Actualizar total de la venta
                venta.Total = totalVenta;
                _context.Entry(venta).State = EntityState.Modified;

                // Eliminar carrito
                _context.Carritos.Remove(carrito);

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return CreatedAtAction("GetVenta", new { id = venta.Id }, venta);
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        // PUT: api/Ventas/5/estado
        [HttpPut("{id}/estado")]
        public async Task<IActionResult> ActualizarEstadoVenta(int id, [FromBody] ActualizarEstadoRequest request)
        {
            var venta = await _context.Ventas.FindAsync(id);
            if (venta == null)
            {
                return NotFound();
            }

            venta.Estado = request.Estado;
            _context.Entry(venta).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!VentaExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/Ventas/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteVenta(int id)
        {
            var venta = await _context.Ventas.FindAsync(id);
            if (venta == null)
            {
                return NotFound();
            }

            _context.Ventas.Remove(venta);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool VentaExists(int id)
        {
            return _context.Ventas.Any(e => e.Id == id);
        }
    }

    public class CrearVentaRequest
    {
        public int UsuarioId { get; set; }
        public int TiendaId { get; set; }
    }

    public class ActualizarEstadoRequest
    {
        public string Estado { get; set; }
    }
}