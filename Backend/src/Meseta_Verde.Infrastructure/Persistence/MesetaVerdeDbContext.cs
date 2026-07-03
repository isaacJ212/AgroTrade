using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Meseta_Verde.Infrastructure.Persistence
{
    public class MesetaVerdeDbContext : DbContext
    {
        public MesetaVerdeDbContext(DbContextOptions<MesetaVerdeDbContext> options)
            : base(options)
        {
        }

        public DbSet<Usuario> Usuarios { get; set; } = null!;
        public DbSet<Rol> Roles { get; set; } = null!;
        public DbSet<Permiso> Permisos { get; set; } = null!;
        public DbSet<UsuarioRol> UsuariosRoles { get; set; } = null!;
        public DbSet<RolPermiso> RolesPermisos { get; set; } = null!;
        public DbSet<Proveedor> Proveedores { get; set; } = null!;
        public DbSet<Categoria> Categorias { get; set; } = null!;
        public DbSet<Producto> Productos { get; set; } = null!;
        public DbSet<InventarioProveedor> InventarioProveedor { get; set; } = null!;
        public DbSet<SuscripcionApp> SuscripcionesApp { get; set; } = null!;
        public DbSet<Pedido> Pedidos { get; set; } = null!;
        public DbSet<DetallePedido> DetallesPedido { get; set; } = null!;
        public DbSet<LogisticaEntrega> LogisticaEntregas { get; set; } = null!;
        public DbSet<Valoracion> Valoraciones { get; set; } = null!;
        public DbSet<ImpactoSocial> ImpactosSociales { get; set; } = null!;
        public DbSet<Conversacion> Conversaciones { get; set; } = null!;
        public DbSet<ConversacionParticipante> ConversacionParticipantes { get; set; } = null!;
        public DbSet<Mensaje> Mensajes { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(MesetaVerdeDbContext).Assembly);
        }
    }
}
