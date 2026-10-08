import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/services/api_session.dart';
import 'package:agrotrade_frontend/models/repartidor_models.dart';
import 'package:agrotrade_frontend/routes/app_routes.dart';
import 'package:agrotrade_frontend/screens/repartidor/verificacionRepartidorModal.dart';
import 'homeRepartidor.dart';
import 'entregasRepartidor.dart';
import 'rutaEntregaRepartidor.dart';
import 'perfilRepartidor.dart';
import 'detalleEntregaRepartidor.dart';
import 'recogerPedidoRepartidor.dart';
import 'entregaEnCursoRepartidor.dart';
import 'onboardingRepartidor.dart';
import 'formularioSolicitudRepartidor.dart';

void navegarRepartidor(BuildContext context, int actual, int destino) {
  if (actual == destino) return;
  
  // Verificar si el repartidor está verificado para acceder a funciones operativas
  final session = ApiSession.instance;
  final esRepartidor = session.roles.contains('Repartidor');
  final estaVerificado = session.isRepartidorVerificado;
  
  // Índices que requieren verificación: 0=Home, 1=Entregas, 2=Ruta
  // Perfil (3) siempre accesible
  const indicesProtegidos = {0, 1, 2};
  
  if (esRepartidor && indicesProtegidos.contains(destino) && !estaVerificado) {
    // Obtener estado actual para mostrar modal apropiado
    final estado = session.repartidorEstado ?? RepartidorEstado(tieneRepartidor: false, solicitudEstado: null);
    
    VerificacionRepartidorModal.show(
      context: context,
      estado: estado,
      onCorregirReenviar: () => Navigator.pushNamed(context, AppRoutes.formularioSolicitudRepartidor),
      onIrAOnboarding: () => Navigator.pushNamed(context, AppRoutes.onboardingRepartidor),
    );
    return;
  }
  
  final Widget pantalla;
  switch (destino) {
    case 0:
      pantalla = const InicioRepartidor();
      break;
    case 1:
      pantalla = const Entregasrepartidor();
      break;
    case 2:
      pantalla = const RutaEntregaRepartidor();
      break;
    case 3:
      pantalla = const PerfilRepartidor();
      break;
    default:
      return;
  }
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute<void>(builder: (_) => pantalla),
    (_) => false,
  );
}