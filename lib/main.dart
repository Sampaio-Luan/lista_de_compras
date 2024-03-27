import 'package:flutter/material.dart';
import 'package:lista_de_compras/meu_app.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) =>  const MeuApp(),
    ),
  );
}




