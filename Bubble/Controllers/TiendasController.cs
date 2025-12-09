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
    public class TiendasController : ControllerBase
    {
        private readonly BubbleDbContext _context;

        public TiendasController(BubbleDbContext context)
        {
            _context = context;
        }

        // GET: api/Tiendas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Tienda>>> GetTiendas()
        {
            return await _context.Tiendas.ToListAsync();
        }

        // GET: api/Tiendas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Tienda>> GetTienda(int id)
        {
            var tienda = await _context.Tiendas.FindAsync(id);

            if (tienda == null)
            {
                return NotFound();
            }

            return tienda;
        }

        // GET: api/Tiendas/usuario/5
        [HttpGet("usuario/{usuarioId}")]
        public async Task<ActionResult<IEnumerable<Tienda>>> GetTiendasPorUsuario(int usuarioId)
        {
            return await _context.Tiendas
                .Where(t => t.UsuarioId == usuarioId)
                .ToListAsync();
        }

        // POST: api/Tiendas
        [HttpPost]
        public async Task<ActionResult<Tienda>> PostTienda(Tienda tienda)
        {
            _context.Tiendas.Add(tienda);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTienda", new { id = tienda.Id }, tienda);
        }

        // PUT: api/Tiendas/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTienda(int id, Tienda tienda)
        {
            if (id != tienda.Id)
            {
                return BadRequest();
            }

            _context.Entry(tienda).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TiendaExists(id))
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

        // DELETE: api/Tiendas/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTienda(int id)
        {
            var tienda = await _context.Tiendas.FindAsync(id);
            if (tienda == null)
            {
                return NotFound();
            }

            _context.Tiendas.Remove(tienda);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TiendaExists(int id)
        {
            return _context.Tiendas.Any(e => e.Id == id);
        }
    }
}