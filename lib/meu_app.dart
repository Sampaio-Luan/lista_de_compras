import 'package:flutter/material.dart';
import 'package:lista_de_compras/views/login_view.dart';


class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        
      ),
      home:   const LoginView(nome:'',email:'',senha:'')
    );
  }
}

