import 'package:flutter/material.dart';
import 'package:lista_de_compras/views/home_view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nomeC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController senhaC = TextEditingController();
  bool login = true;
  String textbtn = "ENTRAR";
  String titulo = "LOGIN";

  String nome = '';
  String email = '';
  String senha = '';

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
                        height: 390,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 40),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              titulo,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30),
                            ),
                            login == false
                                ? campo(nomeC, 'Nome', 0)
                                : const Text(''),
                            campo(emailC, 'Email', 1),
                            campo(senhaC, 'Senha', 2),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white54,
                                foregroundColor: Colors.blue.shade900,
                                minimumSize: const Size(200, 50),
                                shadowColor: Colors.white,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (login == false) {
                                    nome = nomeC.text;
                                    email = emailC.text;
                                    senha = senhaC.text;

                                    nomeC.text = '';
                                    emailC.text = '';
                                    senhaC.text = '';

                                    textbtn = 'ENTRAR';
                                    titulo = "LOGIN";

                                    login = true;
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Cadastrado com sucesso, realize o login'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    });
                                  }

                                  if (emailC.text == email &&
                                      senhaC.text == senha) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomePage(title: 'Listas de Compras',)),
                                    );
                                  }else{
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Email ou senha incorretos'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    });
                                  }
                                }
                              },
                              child: Text(
                                textbtn,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          txtbtn(1, 'Cadastrar-me'),
                          txtbtn(2, 'Esqueci a senha'),
                        ],
                      ),
                      txtbtn(3, 'Login'),
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: const Text(
            'IMPORTANTE',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text(
                  'Digite seu email, e confirme para receber um link para redefinicao da senha',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                campo(emailC, 'Email', 1),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Acesse seu email para redefinir senha'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  TextButton txtbtn(int op, String label) {
    return TextButton(
      onPressed: () {
        switch (op) {
          case 1:
            login = false;
            textbtn = 'CADASTRAR';
            titulo = 'CADASTRO';
            break;
          case 3:
            login = true;
            textbtn = 'ENTRAR';
            titulo = "LOGIN";
            break;
        }
        if (op == 2) {
          _showMyDialog();
        }

        formKey.currentState!.reset();
        setState(() {});
      },
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 18),
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
          return 'Preenchimento obrigatorio';
        }
        return null;
      },
    );
  }
}
