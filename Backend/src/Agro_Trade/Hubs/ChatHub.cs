using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace Agro_Trade.Hubs
{
    public class ChatHub : Hub
    {
        // Los clientes llaman a este método enviando el ID de su conversación
        public async Task JoinConversation(int idConversacion)
        {
            // Agrupamos la conexión bajo el ID de la conversación.
            // Así podemos emitir mensajes solo a los clientes de esa conversación.
            await Groups.AddToGroupAsync(Context.ConnectionId, idConversacion.ToString());
        }

        public async Task LeaveConversation(int idConversacion)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, idConversacion.ToString());
        }
    }
}
