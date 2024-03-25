import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'LISTA DE COMPRAS',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border(
                            right: BorderSide(color: Colors.white),
                            left: BorderSide(color: Colors.white),
                            top: BorderSide(color: Colors.white),
                            bottom: BorderSide(color: Colors.white),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.white38,
                              Colors.white60,
                              Colors.white38,
                              Colors.white70,
                              Colors.white60,
                              Colors.white38,
                              Colors.white60,
                            ],
                          ),
                        ),
                        height: 350,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 40),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            campo(nome, 'Nome', 0),
                            campo(email, 'Email', 1),
                            campo(senha, 'Senha', 2),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white54,
                                foregroundColor: Colors.blue.shade900,
                                minimumSize: const Size(200, 50),
                                shadowColor: Colors.white,
                              ),
                              onPressed: () { },
                              child: const Text(
                                'ENTRAR',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Cadastrar-me',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Esqueci a senha',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField campo(
    TextEditingController controller,
    String label,
    int index,
  ) {
    List<IconData> icone = [
      Icons.person_outlined,
      Icons.email_outlined,
      Icons.key
    ];

    return TextFormField(
      controller: controller,
      obscureText: index == 2 ? true : false,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        prefixIcon: Icon(icone[index]),
      ),
      validator: (value) {
        if (value == null) {
          return 'Preenchimento obrigatorio';
        } else if (value.isEmpty) {
          return 'Informe um valor';
        }
        //Retornar null significa sucesso na validação
        return null;
      },
    );
  }
}
