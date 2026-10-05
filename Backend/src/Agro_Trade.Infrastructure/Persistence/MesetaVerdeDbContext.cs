using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Agro_Trade.Application.Common.Interface; //

namespace Agro_Trade.Infrastructure.Persistence
{
    public class AgroTradeDbContext : DbContext
    {
        public AgroTradeDbContext(DbContextOptions<AgroTradeDbContext> options)
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
        public DbSet<RegistroTransferenciaMock> RegistrosTransferenciaMock { get; set; } = null!;
        public DbSet<DetallePedido> DetallesPedido { get; set; } = null!;
        public DbSet<LogisticaEntrega> LogisticaEntregas { get; set; } = null!;
        public DbSet<NotificacionEntrega> NotificacionesEntrega { get; set; } = null!;
        public DbSet<Valoracion> Valoraciones { get; set; } = null!;
        public DbSet<ImpactoSocial> ImpactosSociales { get; set; } = null!;
        public DbSet<Conversacion> Conversaciones { get; set; } = null!;
        public DbSet<ConversacionParticipante> ConversacionParticipantes { get; set; } = null!;
        public DbSet<Mensaje> Mensajes { get; set; } = null!;
        public DbSet<SolicitudRepartidor> SolicitudRepartidor { get; set; } = null!;
        public DbSet<Repartidor> Repartidor { get; set; } = null!;  
        public DbSet<Actividad> Actividades { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(AgroTradeDbContext).Assembly);
            
            // Seed Data 
            modelBuilder.Entity<Actividad>().HasData(
                new Actividad { Id = 1, Title = "El productor 'Finca Los Pinos' se ha registrado en la plataforma", IconType = "user", IconClass = "icon-green-bg", CreatedAt = DateTime.UtcNow.AddMinutes(-5) },
                new Actividad { Id = 2, Title = "Verificación aprobada para 'Transportes El Rápido'", IconType = "check-circle", IconClass = "icon-blue-bg", CreatedAt = DateTime.UtcNow.AddHours(-1) },
                new Actividad { Id = 3, Title = "Se ha reportado un problema con el pedido #1045", IconType = "alert-circle", IconClass = "icon-orange-bg", CreatedAt = DateTime.UtcNow.AddHours(-2) },
                new Actividad { Id = 4, Title = "Nueva categoría 'Frutas Tropicales' creada", IconType = "layers", IconClass = "icon-purple-bg", CreatedAt = DateTime.UtcNow.AddDays(-1) }
            );
        }
    }
}
