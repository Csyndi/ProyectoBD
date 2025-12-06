using Bubble.Models;
using BubbleI.Models;
using Microsoft.EntityFrameworkCore;

namespace BubbleI.Models
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<CategoriaTienda> CategoriasTienda { get; set; }
        public DbSet<Tienda> Tiendas { get; set; }
        public DbSet<CategoriaProducto> CategoriasProducto { get; set; }
        public DbSet<Producto> Productos { get; set; }
        public DbSet<Carrito> Carritos { get; set; }
        public DbSet<CarritoDetalle> CarritoDetalles { get; set; }
        public DbSet<Venta> Ventas { get; set; }
        public DbSet<DetalleVenta> DetalleVentas { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configurar Usuario
            modelBuilder.Entity<Usuario>(entity =>
            {
                entity.HasIndex(u => u.Email)
                      .IsUnique();

                entity.Property(u => u.Nombre)
                      .IsRequired()
                      .HasMaxLength(100);

                entity.Property(u => u.Email)
                      .IsRequired()
                      .HasMaxLength(100);

                entity.Property(u => u.Contrasena)
                      .IsRequired()
                      .HasMaxLength(255);

                entity.Property(u => u.Rol)
                      .HasMaxLength(50);
            });

            // Configurar CategoriaTienda
            modelBuilder.Entity<CategoriaTienda>(entity =>
            {
                entity.HasKey(ct => ct.Id);

                entity.Property(ct => ct.Nombre)
                      .IsRequired()
                      .HasMaxLength(100);

                entity.Property(ct => ct.Descripcion)
                      .HasMaxLength(500);
            });

            // Configurar Tienda
            modelBuilder.Entity<Tienda>(entity =>
            {
                entity.HasKey(t => t.Id);

                entity.Property(t => t.Nombre)
                      .IsRequired()
                      .HasMaxLength(100);

                entity.Property(t => t.Descripcion)
                      .HasMaxLength(500);

                entity.Property(t => t.Direccion)
                      .HasMaxLength(200);

                entity.Property(t => t.Telefono)
                      .HasMaxLength(20);

                entity.HasOne(t => t.Categoria)
                      .WithMany(c => c.Tiendas)
                      .HasForeignKey(t => t.CategoriaId)
                      .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(t => t.Usuario) // Asumiendo que Tienda pertenece a un Usuario
                      .WithMany()
                      .HasForeignKey(t => t.UsuarioId)
                      .OnDelete(DeleteBehavior.Restrict);
            });

            // Configurar CategoriaProducto
            modelBuilder.Entity<CategoriaProducto>(entity =>
            {
                entity.HasKey(cp => cp.Id);

                entity.Property(cp => cp.Nombre)
                      .IsRequired()
                      .HasMaxLength(100);

                entity.Property(cp => cp.Descripcion)
                      .HasMaxLength(500);
            });

            // En ApplicationDbContext.cs
            // Configurar Producto
            modelBuilder.Entity<Producto>(entity =>
            {
                entity.HasKey(p => p.Id);

                entity.Property(p => p.Nombre)
                      .IsRequired()
                      .HasMaxLength(100);

                entity.Property(p => p.Descripcion)
                      .HasMaxLength(1000);

                entity.Property(p => p.Precio)
                      .HasColumnType("decimal(18,2)");

                entity.Property(p => p.ImagenUrl)
                      .HasMaxLength(500);

                entity.Property(p => p.TiendaId)
                      .IsRequired();

                entity.Property(p => p.CategoriaProductoId)
                      .IsRequired(); // Mantener como requerido

                entity.HasOne(p => p.Tienda)
                      .WithMany(t => t.Productos)
                      .HasForeignKey(p => p.TiendaId)
                      .OnDelete(DeleteBehavior.Cascade);

                // Cambiar SetNull a Restrict o NoAction
                entity.HasOne(p => p.CategoriaProducto)
                      .WithMany(c => c.Productos)
                      .HasForeignKey(p => p.CategoriaProductoId)
                      .OnDelete(DeleteBehavior.Restrict); // ← Cambiado aquí
            });

            // Configurar Carrito
            modelBuilder.Entity<Carrito>(entity =>
            {
                entity.HasKey(c => c.Id);

                entity.Property(c => c.FechaCreacion)
                      .HasDefaultValueSql("GETDATE()");

                entity.HasOne(c => c.Usuario)
                      .WithMany()
                      .HasForeignKey(c => c.UsuarioId)
                      .OnDelete(DeleteBehavior.Cascade);
            });

            // Configurar CarritoDetalle
            modelBuilder.Entity<CarritoDetalle>(entity =>
            {
                entity.HasKey(cd => cd.Id);

                entity.Property(cd => cd.Cantidad)
                      .HasDefaultValue(1);

                entity.Property(cd => cd.PrecioUnitario)
                      .HasColumnType("decimal(18,2)");

                entity.HasOne(cd => cd.Carrito)
                      .WithMany(c => c.CarritoDetalles)
                      .HasForeignKey(cd => cd.CarritoId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(cd => cd.Producto)
                      .WithMany(p => p.CarritoDetalles)
                      .HasForeignKey(cd => cd.ProductoId)
                      .OnDelete(DeleteBehavior.Restrict);
            });

            // Configurar Venta
            modelBuilder.Entity<Venta>(entity =>
            {
                entity.HasKey(v => v.Id);

                entity.Property(v => v.FechaVenta)
                      .HasDefaultValueSql("GETDATE()");

                entity.Property(v => v.Total)
                      .HasColumnType("decimal(18,2)");

                entity.Property(v => v.Estado)
                      .HasMaxLength(50)
                      .HasDefaultValue("Pendiente");

                entity.HasOne(v => v.Tienda)
                      .WithMany(t => t.Ventas)
                      .HasForeignKey(v => v.TiendaId)
                      .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(v => v.Usuario)
                      .WithMany()
                      .HasForeignKey(v => v.UsuarioId)
                      .OnDelete(DeleteBehavior.Restrict);
            });

            // Configurar DetalleVenta
            modelBuilder.Entity<DetalleVenta>(entity =>
            {
                entity.HasKey(dv => dv.Id);

                entity.Property(dv => dv.Cantidad)
                      .IsRequired();

                entity.Property(dv => dv.PrecioUnitario)
                      .HasColumnType("decimal(18,2)");

                entity.Property(dv => dv.Subtotal)
                      .HasColumnType("decimal(18,2)");

                entity.HasOne(dv => dv.Venta)
                      .WithMany(v => v.DetalleVentas)
                      .HasForeignKey(dv => dv.VentaId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(dv => dv.Producto)
                      .WithMany(p => p.DetalleVentas)
                      .HasForeignKey(dv => dv.ProductoId)
                      .OnDelete(DeleteBehavior.Restrict);
            });
        }
    }
}