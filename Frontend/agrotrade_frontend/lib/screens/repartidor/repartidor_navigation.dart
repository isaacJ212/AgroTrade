import 'package:flutter/material.dart';
import 'homeRepartidor.dart';
import 'entregasRepartidor.dart';
import 'rutaEntregaRepartidor.dart';
import 'perfilRepartidor.dart';
import 'detalleEntregaRepartidor.dart';
import 'recogerPedidoRepartidor.dart';
import 'entregaEnCursoRepartidor.dart';
import 'repartidor_demo.dart';

void navegarRepartidor(BuildContext context, int actual, int destino) {
  if (actual == destino) return;
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

void abrirEntregaDemo(BuildContext context, EntregaDemo entrega) {
  final Widget pantalla;
  if (entrega.estado == EstadoEntregaDemo.enCurso) {
    pantalla = entrega.recogido
        ? EntregaEnCursoRepartidor(pedidoId: entrega.id)
        : RecogerPedidoRepartidor(pedidoId: entrega.id);
  } else {
    pantalla = DetalleEntregaRepartidor(pedidoId: entrega.id);
  }
  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => pantalla));
}
