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
    public class CategoriasProductoController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CategoriasProductoController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/CategoriasProducto
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CategoriaProducto>>> GetCategoriasProducto()
        {
            return await _context.CategoriasProducto
                .Include(cp => cp.Productos)
                .ThenInclude(p => p.Tienda)
                .ToListAsync();
        }

        // GET: api/CategoriasProducto/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CategoriaProducto>> GetCategoriaProducto(int id)
        {
            var categoriaProducto = await _context.CategoriasProducto
                .Include(cp => cp.Productos)
                .ThenInclude(p => p.Tienda)
                .FirstOrDefaultAsync(cp => cp.Id == id);

            if (categoriaProducto == null)
            {
                return NotFound();
            }

            return categoriaProducto;
        }

        // POST: api/CategoriasProducto
        [HttpPost]
        public async Task<ActionResult<CategoriaProducto>> PostCategoriaProducto(CategoriaProducto categoriaProducto)
        {
            _context.CategoriasProducto.Add(categoriaProducto);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCategoriaProducto", new { id = categoriaProducto.Id }, categoriaProducto);
        }

        // PUT: api/CategoriasProducto/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCategoriaProducto(int id, CategoriaProducto categoriaProducto)
        {
            if (id != categoriaProducto.Id)
            {
                return BadRequest();
            }

            _context.Entry(categoriaProducto).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CategoriaProductoExists(id))
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

        // DELETE: api/CategoriasProducto/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCategoriaProducto(int id)
        {
            var categoriaProducto = await _context.CategoriasProducto.FindAsync(id);
            if (categoriaProducto == null)
            {
                return NotFound();
            }

            _context.CategoriasProducto.Remove(categoriaProducto);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CategoriaProductoExists(int id)
        {
            return _context.CategoriasProducto.Any(e => e.Id == id);
        }
    }
}