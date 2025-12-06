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
    public class CarritoDetallesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CarritoDetallesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/CarritoDetalles
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CarritoDetalle>>> GetCarritoDetalles()
        {
            return await _context.CarritoDetalles
                .Include(cd => cd.Carrito)
                .Include(cd => cd.Producto)
                .ToListAsync();
        }

        // GET: api/CarritoDetalles/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CarritoDetalle>> GetCarritoDetalle(int id)
        {
            var carritoDetalle = await _context.CarritoDetalles
                .Include(cd => cd.Carrito)
                .Include(cd => cd.Producto)
                .FirstOrDefaultAsync(cd => cd.Id == id);

            if (carritoDetalle == null)
            {
                return NotFound();
            }

            return carritoDetalle;
        }

        // GET: api/CarritoDetalles/carrito/5
        [HttpGet("carrito/{carritoId}")]
        public async Task<ActionResult<IEnumerable<CarritoDetalle>>> GetDetallesPorCarrito(int carritoId)
        {
            return await _context.CarritoDetalles
                .Where(cd => cd.CarritoId == carritoId)
                .Include(cd => cd.Producto)
                .ToListAsync();
        }

        // POST: api/CarritoDetalles/agregar
        [HttpPost("agregar")]
        public async Task<ActionResult<CarritoDetalle>> AgregarAlCarrito(CarritoDetalle carritoDetalle)
        {
            // Verificar si el producto ya está en el carrito
            var detalleExistente = await _context.CarritoDetalles
                .FirstOrDefaultAsync(cd => cd.CarritoId == carritoDetalle.CarritoId &&
                                         cd.ProductoId == carritoDetalle.ProductoId);

            if (detalleExistente != null)
            {
                // Actualizar cantidad
                detalleExistente.Cantidad += carritoDetalle.Cantidad;
                _context.Entry(detalleExistente).State = EntityState.Modified;
            }
            else
            {
                // Obtener precio del producto
                var producto = await _context.Productos.FindAsync(carritoDetalle.ProductoId);
                if (producto != null)
                {
                    carritoDetalle.PrecioUnitario = producto.Precio;
                }

                _context.CarritoDetalles.Add(carritoDetalle);
            }

            await _context.SaveChangesAsync();
            return CreatedAtAction("GetCarritoDetalle", new { id = carritoDetalle.Id }, carritoDetalle);
        }

        // PUT: api/CarritoDetalles/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCarritoDetalle(int id, CarritoDetalle carritoDetalle)
        {
            if (id != carritoDetalle.Id)
            {
                return BadRequest();
            }

            _context.Entry(carritoDetalle).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CarritoDetalleExists(id))
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

        // DELETE: api/CarritoDetalles/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCarritoDetalle(int id)
        {
            var carritoDetalle = await _context.CarritoDetalles.FindAsync(id);
            if (carritoDetalle == null)
            {
                return NotFound();
            }

            _context.CarritoDetalles.Remove(carritoDetalle);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CarritoDetalleExists(int id)
        {
            return _context.CarritoDetalles.Any(e => e.Id == id);
        }
    }
}