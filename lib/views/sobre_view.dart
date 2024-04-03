import 'package:flutter/material.dart';
import 'package:lista_de_compras/repositories/listas_repository.dart';
import 'package:lista_de_compras/views/login_view.dart';

class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  @override
  Widget build(BuildContext context) {
    final r = ListasRespository();
    String temaEscolhido =
        'O aplicativo é focado em ajudar os usuários a organizar seus itens de compras de maneira eficiente, com recurso de listas e itens editáveis, facilmente gerenciáveis.';
    String objetivo =
        'O principal objetivo é simplificar o processo de compra, economizando tempo do usuário na criação de suas listas. ';
    String dev = 'Luan Santos Sampaio ';
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue[300],
              child: const Icon(Icons.person_3_outlined,
                  size: 50, color: Colors.white),
            ),
            accountName: Text(r.user.text, style: const TextStyle(color: Colors.white),),
            accountEmail: Text(r.email.text),
          ),
          Column(
            children: [
              ListTile(
                title: const Text(
                  'Sobre',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                leading: const Icon(Icons.quiz_outlined,
                    color: Colors.blue, size: 30),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text.rich(
                              textAlign: TextAlign.justify,
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: '\nSobre:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 22),
                                  ),
                                  const TextSpan(
                                    text: '\n\nTema Escolhido: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 18),
                                  ),
                                  TextSpan(
                                    text: temaEscolhido,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const TextSpan(
                                    text: '\n\nObjetivo do Aplicativo: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 18),
                                  ),
                                  TextSpan(
                                    text: objetivo,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const TextSpan(
                                    text: '\n\nNome do Desenvolvedor: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 18),
                                  ),
                                  TextSpan(
                                    text: dev,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]);
                      });
                },
              ),
              Divider(
                color: Colors.blue[400],
              ),
              ListTile(
                  title: const Text(
                    'Sair',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  leading: const Icon(Icons.exit_to_app_sharp,
                      color: Colors.blue, size: 30),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 0,
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            title: const Text(
                              'Atenção !!!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.blue),
                            ),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tem certeza que quer sair do aplicativo?',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Não",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sim",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ),
                              ),
                            ],
                          );
                        });
                  }),
              const SizedBox(
                height: 5,
              )
            ],
          )
        ],
      ),
    );
  }
}
