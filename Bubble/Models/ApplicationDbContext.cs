using Microsoft.EntityFrameworkCore;
using Bubble.Models;

namespace Bubble.Data
{
    public class BubbleDbContext : DbContext
    {
        public BubbleDbContext(DbContextOptions<BubbleDbContext> options) : base(options)
        {
        }

        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Producto> Productos { get; set; }
        public DbSet<Tienda> Tiendas { get; set; }
        public DbSet<Carrito> Carritos { get; set; }
        public DbSet<Venta> Ventas { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configuración de Usuario
            modelBuilder.Entity<Usuario>(entity =>
            {
                entity.HasIndex(u => u.Email)
                      .IsUnique();

                // Especificar tipos de columnas para PostgreSQL
                entity.Property(u => u.Email)
                      .HasMaxLength(100);

                entity.Property(u => u.Nombre)
                      .HasMaxLength(100);

                entity.Property(u => u.Rol)
                      .HasMaxLength(50);
            });

            // Configuración de Producto
            modelBuilder.Entity<Producto>(entity =>
            {
                entity.Property(p => p.Nombre)
                      .HasMaxLength(200)
                      .IsRequired();

                entity.Property(p => p.Descripcion)
                      .HasMaxLength(1000);

                entity.Property(p => p.CategoriaProducto)
                      .HasMaxLength(100);

                entity.Property(p => p.Precio)
                      .HasPrecision(18, 2);
            });

            // Configuración de Tienda
            modelBuilder.Entity<Tienda>(entity =>
            {
                entity.Property(t => t.Nombre)
                      .HasMaxLength(200)
                      .IsRequired();

                entity.Property(t => t.Usuario)
                      .HasMaxLength(100)
                      .IsRequired();

            });

            // Configuración de Carrito
            modelBuilder.Entity<Carrito>(entity =>
            {
                entity.Property(c => c.Usuario)
                      .HasMaxLength(100)
                      .IsRequired();

                entity.Property(c => c.CarritoDetalles)
                      .HasColumnType("jsonb"); // Usar tipo jsonb de PostgreSQL si almacenas JSON
            });

            // Configuración de Venta
            modelBuilder.Entity<Venta>(entity =>
            {
                entity.Property(v => v.Usuario)
                      .HasMaxLength(100)
                      .IsRequired();

                entity.Property(v => v.DetalleVentas)
                      .HasColumnType("jsonb"); // Usar tipo jsonb de PostgreSQL

                entity.Property(v => v.Total)
                      .HasPrecision(18, 2);
            });

            // Opcional: Configurar nombres de tablas en minúsculas para PostgreSQL
            foreach (var entity in modelBuilder.Model.GetEntityTypes())
            {
                entity.SetTableName(entity.GetTableName().ToLower());

                foreach (var property in entity.GetProperties())
                {
                    property.SetColumnName(property.GetColumnName().ToLower());
                }

                foreach (var key in entity.GetKeys())
                {
                    key.SetName(key.GetName().ToLower());
                }

                foreach (var foreignKey in entity.GetForeignKeys())
                {
                    foreignKey.SetConstraintName(foreignKey.GetConstraintName().ToLower());
                }

                foreach (var index in entity.GetIndexes())
                {
                    index.SetDatabaseName(index.GetDatabaseName().ToLower());
                }
            }
        }
    }
}