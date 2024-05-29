import 'package:apiflutter/user.dart';
import 'package:apiflutter/user_service.dart';
import 'package:flutter/material.dart';

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  late Future<List<User>> futureUsers;
  final UserService userService = UserService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Added for email
  final TextEditingController pictureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(210, 245, 204, 129),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 243, 142, 47),
          centerTitle: true,
          title: const Text('Lista de Usuários',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 255, 255, 1),
              )),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddList()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // Container(
              //   padding: EdgeInsets.only(top: 30,bottom: 25),
              //   width: 430,
              //   child: TextFormField(
              //   controller: firstnameController,
              //   decoration: InputDecoration(
              //   labelText: 'Primeiro Nome',
              //   enabledBorder: OutlineInputBorder(
              //     borderSide: BorderSide(color: Color.fromARGB(255, 26, 12, 223)),),
              // ),),),

              Center(
                child: Container(
                  height: 300,
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 25
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 430,
                          child: TextFormField(
                            controller: firstnameController,
                            decoration: InputDecoration(
                              labelText: 'Primeiro Nome',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 430,
                          child: TextFormField(
                            controller: lastnameController,
                            decoration: InputDecoration(
                              labelText: 'Último Nome',
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0)),),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 430,
                          child: TextFormField(
                            controller: lastnameController,
                            decoration: InputDecoration(
                              labelText: 'Último Nome',
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0)),),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              // Column(
              //   children: [
              //     Center(
              //       child: SizedBox(
              //         width: 430,
              //         child: TextFormField(
              //           controller: lastnameController,
              //           decoration: InputDecoration(
              //             labelText: 'Último Nome',
              //             enabledBorder: OutlineInputBorder(),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 25.0),
              //     // other widgets here

              //     SizedBox(
              //       width: 430,
              //       child: TextFormField(
              //         controller: emailController,
              //         decoration: InputDecoration(
              //           labelText: 'Email',
              //           enabledBorder: OutlineInputBorder(),
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 30.0),
              //   ],
              // ),

              SizedBox(
                height: 40.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 242, 243), // set your desired background color here
                  ),
                  onPressed: _addUser,
                  child: const Text('Adicionar'),
                ),
              )
            ],
          ),
        ));
  }

  void _addUser() {
    if (firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      userService
          .createUser(User(
        id: '', // ID é gerado pela API, não precisa enviar
        title: tituloController
            .text, // Incluído, assumindo que você ainda quer enviar isso
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        picture: pictureController.text, // Incluído, assumindo que é necessário
      ))
          .then((newUser) {
        _showSnackbar('Usuário adicionado com sucesso!');
        _refreshUserList();
      }).catchError((erro) {
        _showSnackbar('Falha ao adicionar usuário:$erro');
      });
    } else {
      _showSnackbar('Por favor preencha todos os campos.');
    }
  }

  void _refreshUserList() {
    setState(() {
      futureUsers = userService.getUsers();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
