using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Common.Interface;
using Google.GenAI.Types;
using MediatR;
using MediatR.Wrappers;

namespace Agro_Trade.Application.Features.Auth;

public record GoogleDataCatchCommand(int userId, GoogleCatchDataDto dto) : IRequest<Result<Unit>>;

public class GoogleSignInCaptureDataHandler(IUnitofWork context) : IRequestHandler<GoogleDataCatchCommand, Result<Unit>>
{
    
    public async Task<Result<Unit>> Handle(GoogleDataCatchCommand request, CancellationToken ct)
    {
       
        var dto = request.dto;
        var validUser = await context.Users.GetToUpdateAsync(request.userId, ct);
        if (validUser is null || !validUser.OAuthProvider!.ToLower().Contains("google"))
        {
            return Result<Unit>.Failure(401, "Usuario no existe o No esta registrado con google");
        }
        //validamos el departamento
        var departamento = NormalizarDepartamento(dto.Departamento);
        if (departamento is null)
            return Result<Unit>.Failure(400, "Ingrese un Departamento Valido en nicaragua");
        
        validUser.Departamento = departamento;
        validUser.Telefono = dto.Telefono;
        validUser.Municipio = dto.Municipio;
        validUser.DireccionExacta = dto.DireccionExacta;

        await context.SaveChangesAsync(ct);

        return Result<Unit>.Success(204, Unit.Value, "Datos Completados exitosamente", true);

    }
    
    // HELPER DE VALIDACION
    private string? NormalizarDepartamento(string? departamentoInput)
    {
        if (string.IsNullOrWhiteSpace(departamentoInput)) return null;

        var departamentosValidos = new[] {
            "leon", "carazo", "granada", "chontales", "rivas", "rio san juan", 
            "racs", "racn", "jinotega", "esteli", "boaco", "chinandega", "masaya", "matagalpa"
        };

        string input = departamentoInput.Trim().ToLower();

        
        var deptoEncontrado = departamentosValidos.FirstOrDefault(item => input.Contains(item));
        if (deptoEncontrado is null) return null;

        return deptoEncontrado switch
        {
            "racn"         => "Región Autónoma del Caribe Norte",
            "racs"         => "Región Autónoma del Caribe Sur",
            "rio san juan" => "Río San Juan",
            "leon"         => "León",
            "esteli"       => "Estelí",
            _              => MayusculaPrimera(deptoEncontrado)
        };
    }
    
    private string MayusculaPrimera(string s)  {
        var capitalizado = s[0] + new string(s.Skip(1).ToArray());
        return capitalizado;
    }
    
}




