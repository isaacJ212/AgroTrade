import 'package:flutter/material.dart';

class Rol {
  final int RolId;
  final String NombreRol;
  final String Description;
  final IconData icono;

  const Rol({
    required this.RolId,
    required this.NombreRol,
    required this.Description,
    required this.icono,
  });
}
