using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common.Interface;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Infrastructure.Persistence.UnitofWork
{
    public class UnitOfWork: IUnitofWork
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly IRepository<Categoria> _categoriaRepository;
        private readonly IRepository<Producto> _productoRepository;
        private readonly IRepository<Proveedor> _proveedorRepository;
        private readonly IRepository<Usuario> _usuarioRepository;
        private readonly IRepository<InventarioProveedor> _inventarioProveedorRepository;
        private readonly IRepository<ImpactoSocial> _impactoSocialRepository;
        private readonly IRepository<Valoracion> _valoracionRepository;
        private readonly IRepository<Pedido> _pedidoRepository;
        private readonly IRepository<DetallePedido> _detallePedidoRepository;
        private readonly IRepository<Conversacion> _conversacionRepository;//
        private readonly IRepository<ConversacionParticipante> _ConversacionParticipanteRepository;
        private readonly IRepository<Mensaje> _mensajeRepository;
        private readonly MesetaVerdeDbContext _context;
        private IDbContextTransaction? _transaction;
        public UnitOfWork(MesetaVerdeDbContext context, IServiceProvider serviceProvider, IRepository<Categoria> categoriaRepository, IRepository<Producto> productoRepository, IRepository<Proveedor> proveedorRepository, IRepository<Usuario> usuarioRepository, IRepository<InventarioProveedor> inventarioProveedorRepository, IRepository<ImpactoSocial> impactoSocialRepository, IRepository<Valoracion> valoracionRepository, IRepository<Pedido> pedidoRepository, IRepository<DetallePedido> detallePedidoRepository, IRepository<Conversacion> conversacionRepository, IRepository<ConversacionParticipante> ConversacionParticpanteRepository, IRepository<Mensaje> mensajeRepository)
        {
            _context = context;
            _serviceProvider = serviceProvider;
            _categoriaRepository = categoriaRepository;
            _productoRepository = productoRepository;
            _proveedorRepository = proveedorRepository;
            _usuarioRepository = usuarioRepository;
            _inventarioProveedorRepository = inventarioProveedorRepository;
            _impactoSocialRepository = impactoSocialRepository;
            _valoracionRepository = valoracionRepository;
            _pedidoRepository = pedidoRepository;
            _detallePedidoRepository = detallePedidoRepository;
            _conversacionRepository = conversacionRepository;
            _ConversacionParticipanteRepository = ConversacionParticpanteRepository;
            _mensajeRepository = mensajeRepository;
        }
        //PROPIEDADES DE NAVEGACION DE CONTEXTO
        public IUserRepository Users => _serviceProvider.GetRequiredService<IUserRepository>();
        public IDeliveryRequestRepository SolicitudRepartidor => _serviceProvider.GetRequiredService<IDeliveryRequestRepository>();
        public IRepository<Categoria> Categorias => _categoriaRepository;
        public IRepository<Producto> Productos => _productoRepository;
        public IRepository<Proveedor> Proveedores => _proveedorRepository;
        public IRepository<Usuario> Usuarios => _usuarioRepository;
        public IRepository<InventarioProveedor> InventarioProveedor => _inventarioProveedorRepository;
        public IRepository<ImpactoSocial> ImpactosSociales => _impactoSocialRepository;
        public IRepository<Valoracion> Valoraciones => _valoracionRepository;
        public IRepository<Pedido> Pedidos => _pedidoRepository;
        public IRepository<DetallePedido> DetallesPedido => _detallePedidoRepository;
        public IRepository<Conversacion> Conversaciones => _conversacionRepository;
        public IRepository<ConversacionParticipante> ConversacionParticipantes => _ConversacionParticipanteRepository;
        public IRepository<Mensaje> Mensajes => _mensajeRepository;
        
        //CONFIGURACIONES DE PERSISTENCIA
        public async Task BeginTransactionAsync(CancellationToken ct)
        {
            _transaction =  await _context.Database.BeginTransactionAsync(ct);
        }
        public async Task<int>SaveChangesAsync(CancellationToken ct)
        {
            return await _context.SaveChangesAsync(ct);
        }
        public async Task CommitAsync(CancellationToken ct)
        {
            try
            {
                   await _context.SaveChangesAsync(ct);
                if (_transaction != null)
                {
                    await _transaction.CommitAsync(ct);
                }



            }
            catch
            {
                await _transaction.RollbackAsync(ct);
                throw;
            }
            finally
            {
                if (_transaction != null)
                {
                    await _transaction.DisposeAsync();
                }
            }
        }
        public async Task RollbackAsync(CancellationToken ct)
        {
            await _transaction.RollbackAsync(ct);
        }

        public async Task DisposeAsync()
        {
            if (_transaction != null)
            {
                await _transaction.DisposeAsync();
            }
            await _context.DisposeAsync();
        }
    }
}
