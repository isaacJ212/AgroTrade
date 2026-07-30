using Agro_Trade.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.Interface
{
    public interface IUnitofWork
    {
        // UNIDAD DE PERSISTENCIA
        Task BeginTransactionAsync(CancellationToken ct);
        Task<int> SaveChangesAsync(CancellationToken ct);
        Task CommitAsync(CancellationToken ct);
        Task RollbackAsync(CancellationToken ct);
        Task DisposeAsync();
        // NAVEGACION PARA REPOSITORIOS 
        public IUserRepository Users { get; }
        public IDeliveryRequestRepository SolicitudRepartidor { get; }
        IRepository<Categoria> Categorias { get; }
        IRepository<Producto> Productos {get;}
        IRepository<Proveedor> Proveedores {get;}
        IRepository<Usuario> Usuarios{get;}
        IRepository<InventarioProveedor> InventarioProveedor{get;}
    
        IRepository<ImpactoSocial> ImpactosSociales { get; }
        IRepository<SuscripcionApp> Suscripciones{get;}
        IRepository<Valoracion> Valoraciones{get;}
        IRepository<Pedido> Pedidos { get; }
        IRepository<DetallePedido> DetallesPedido { get; }
        IRepository<Conversacion> Conversaciones {get;}
        IRepository<ConversacionParticipante> ConversacionParticipantes {get;}
        IRepository<Mensaje> Mensajes {get;}
    }
}
