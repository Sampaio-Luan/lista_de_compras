import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/meu_app.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MeuApp() ,
    ),
   
  );
}
