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
    public class CarritosController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CarritosController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Carritos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Carrito>>> GetCarritos()
        {
            return await _context.Carritos
                .Include(c => c.Usuario)
                .Include(c => c.CarritoDetalles)
                .ThenInclude(cd => cd.Producto)
                .ToListAsync();
        }

        // GET: api/Carritos/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Carrito>> GetCarrito(int id)
        {
            var carrito = await _context.Carritos
                .Include(c => c.Usuario)
                .Include(c => c.CarritoDetalles)
                .ThenInclude(cd => cd.Producto)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (carrito == null)
            {
                return NotFound();
            }

            return carrito;
        }

        // GET: api/Carritos/usuario/5
        [HttpGet("usuario/{usuarioId}")]
        public async Task<ActionResult<Carrito>> GetCarritoPorUsuario(int usuarioId)
        {
            var carrito = await _context.Carritos
                .Include(c => c.Usuario)
                .Include(c => c.CarritoDetalles)
                .ThenInclude(cd => cd.Producto)
                .FirstOrDefaultAsync(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return NotFound();
            }

            return carrito;
        }

        // PUT: api/Carritos/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCarrito(int id, Carrito carrito)
        {
            if (id != carrito.Id)
            {
                return BadRequest();
            }

            _context.Entry(carrito).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CarritoExists(id))
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

        // POST: api/Carritos
        [HttpPost]
        public async Task<ActionResult<Carrito>> PostCarrito(Carrito carrito)
        {
            _context.Carritos.Add(carrito);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCarrito", new { id = carrito.Id }, carrito);
        }

        // DELETE: api/Carritos/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCarrito(int id)
        {
            var carrito = await _context.Carritos.FindAsync(id);
            if (carrito == null)
            {
                return NotFound();
            }

            _context.Carritos.Remove(carrito);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CarritoExists(int id)
        {
            return _context.Carritos.Any(e => e.Id == id);
        }
    }
}