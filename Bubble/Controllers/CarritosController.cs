using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Bubble.Data;
using Bubble.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Bubble.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CarritosController : ControllerBase
    {
        private readonly BubbleDbContext _context;

        public CarritosController(BubbleDbContext context)
        {
            _context = context;
        }

        // GET: api/Carritos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Carrito>>> GetCarritos()
        {
            return await _context.Carritos.ToListAsync();
        }

        // GET: api/Carritos/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Carrito>> GetCarrito(int id)
        {
            var carrito = await _context.Carritos.FindAsync(id);

            if (carrito == null)
            {
                return NotFound();
            }

            return carrito;
        }

        // GET: api/Carritos/usuario/5
        [HttpGet("usuario/{usuarioId}")]
        public async Task<ActionResult<IEnumerable<Carrito>>> GetCarritosPorUsuario(int usuarioId)
        {
            return await _context.Carritos
                .Where(c => c.UsuarioId == usuarioId)
                .ToListAsync();
        }

        // POST: api/Carritos
        [HttpPost]
        public async Task<ActionResult<Carrito>> PostCarrito(Carrito carrito)
        {
            _context.Carritos.Add(carrito);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCarrito", new { id = carrito.Id }, carrito);
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

        // DELETE: api/Carritos/usuario/5
        [HttpDelete("usuario/{usuarioId}")]
        public async Task<IActionResult> DeleteCarritosPorUsuario(int usuarioId)
        {
            var carritos = await _context.Carritos
                .Where(c => c.UsuarioId == usuarioId)
                .ToListAsync();

            if (!carritos.Any())
            {
                return NotFound();
            }

            _context.Carritos.RemoveRange(carritos);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CarritoExists(int id)
        {
            return _context.Carritos.Any(e => e.Id == id);
        }
    }
}