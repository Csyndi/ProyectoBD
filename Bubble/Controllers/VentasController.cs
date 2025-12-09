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
    public class VentasController : ControllerBase
    {
        private readonly BubbleDbContext _context;

        public VentasController(BubbleDbContext context)
        {
            _context = context;
        }

        // GET: api/Ventas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Venta>>> GetVentas()
        {
            return await _context.Ventas.ToListAsync();
        }

        // GET: api/Ventas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Venta>> GetVenta(int id)
        {
            var venta = await _context.Ventas.FindAsync(id);

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
                .ToListAsync();
        }

        // GET: api/Ventas/estado/Pendiente
        [HttpGet("estado/{estado}")]
        public async Task<ActionResult<IEnumerable<Venta>>> GetVentasPorEstado(string estado)
        {
            return await _context.Ventas
                .Where(v => v.Estado == estado)
                .ToListAsync();
        }

        // POST: api/Ventas
        [HttpPost]
        public async Task<ActionResult<Venta>> PostVenta(Venta venta)
        {
            _context.Ventas.Add(venta);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetVenta", new { id = venta.Id }, venta);
        }

        // PUT: api/Ventas/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutVenta(int id, Venta venta)
        {
            if (id != venta.Id)
            {
                return BadRequest();
            }

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

        // PATCH: api/Ventas/5/estado
        [HttpPatch("{id}/estado")]
        public async Task<IActionResult> UpdateEstadoVenta(int id, [FromBody] string estado)
        {
            var venta = await _context.Ventas.FindAsync(id);
            if (venta == null)
            {
                return NotFound();
            }

            venta.Estado = estado;
            await _context.SaveChangesAsync();

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
}