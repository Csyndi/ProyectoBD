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
    public class CategoriasTiendaController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CategoriasTiendaController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/CategoriasTienda
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CategoriaTienda>>> GetCategoriasTienda()
        {
            return await _context.CategoriasTienda
                .Include(ct => ct.Tiendas)
                .ToListAsync();
        }

        // GET: api/CategoriasTienda/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CategoriaTienda>> GetCategoriaTienda(int id)
        {
            var categoriaTienda = await _context.CategoriasTienda
                .Include(ct => ct.Tiendas)
                .FirstOrDefaultAsync(ct => ct.Id == id);

            if (categoriaTienda == null)
            {
                return NotFound();
            }

            return categoriaTienda;
        }

        // POST: api/CategoriasTienda
        [HttpPost]
        public async Task<ActionResult<CategoriaTienda>> PostCategoriaTienda(CategoriaTienda categoriaTienda)
        {
            _context.CategoriasTienda.Add(categoriaTienda);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCategoriaTienda", new { id = categoriaTienda.Id }, categoriaTienda);
        }

        // PUT: api/CategoriasTienda/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCategoriaTienda(int id, CategoriaTienda categoriaTienda)
        {
            if (id != categoriaTienda.Id)
            {
                return BadRequest();
            }

            _context.Entry(categoriaTienda).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CategoriaTiendaExists(id))
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

        // DELETE: api/CategoriasTienda/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCategoriaTienda(int id)
        {
            var categoriaTienda = await _context.CategoriasTienda.FindAsync(id);
            if (categoriaTienda == null)
            {
                return NotFound();
            }

            _context.CategoriasTienda.Remove(categoriaTienda);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CategoriaTiendaExists(int id)
        {
            return _context.CategoriasTienda.Any(e => e.Id == id);
        }
    }
}