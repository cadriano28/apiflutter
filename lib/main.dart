import 'package:apiflutter/addList.dart';
import 'package:apiflutter/userForm.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter User API Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> futureUsers;
  final UserService userService = UserService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Added for email
  final TextEditingController pictureController = TextEditingController();

  get onPressed => null;

  @override
  void initState() {
    super.initState();
    futureUsers = userService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(210, 245, 204, 129),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 142, 47),
        centerTitle: true,
        title: const Text('Lista de Usuários',
            style: TextStyle(
              
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),

              
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
      body: Column(
        children: [
          _buildUserList(),
        //  _buildAddUserForm(),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.picture!),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email), // Changed to display email
                  trailing: _buildEditAndDeleteButtons(user),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildEditAndDeleteButtons(User user) {
    return Wrap(
      spacing: 12,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _showEditDialog(user),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteUser(user.id!),
        ),
      ],
    );
  }

  void _showEditDialog(User user) {
    tituloController.text = user.title!;
    firstnameController.text = user.firstName;
    lastnameController.text = user.lastName;
    emailController.text =
        user.email; // Assuming email cannot be updated, disable this field
    pictureController.text = user.picture!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                  controller: tituloController,
                  decoration: InputDecoration(labelText: 'Título')),
              TextFormField(
                  controller: firstnameController,
                  decoration: InputDecoration(labelText: 'Primeiro Nome')),
              TextFormField(
                  controller: lastnameController,
                  decoration: InputDecoration(labelText: 'Último Nome')),
              TextFormField(
                  controller: pictureController,
                  decoration: InputDecoration(labelText: 'URL da Imagem')),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Update"),
            onPressed: () {
              _updateUser(user);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _updateUser(User user) {
    // Inicializa um Map para armazenar apenas os campos permitidos para atualização
    Map<String, dynamic> dataToUpdate = {
      'Primeiro Nome': firstnameController.text,
      'Último Nome': lastnameController.text,
      'Imagem': pictureController.text,
      // Não inclua 'email' pois é proibido atualizar
    };

    if (tituloController.text.isNotEmpty &&
        firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        pictureController.text.isNotEmpty) {
      userService.updateUser(user.id!, dataToUpdate).then((updatedUser) {
        _showSnackbar('User updated successfully!');
        _refreshUserList();
      }).catchError((error) {
        _showSnackbar('Failed to update user: $error');
      });
    }
  }

  void _deleteUser(String id) {
    userService.deleteUser(id).then((_) {
      _showSnackbar('User deleted successfully!');
      _refreshUserList();
    }).catchError((error) {
      _showSnackbar('Failed to delete user.');
    });
  }

  // Widget _buildAddUserForm() {
  //   return Padding(
  //     padding: EdgeInsets.all(8.0),
  //     child: Column(
  //       children: <Widget>[
  //         TextFormField(
  //             controller: firstnameController,
  //             decoration: InputDecoration(labelText: 'Primeiro Nome')),
  //         TextFormField(
  //             controller: lastnameController,
  //             decoration: InputDecoration(labelText: 'Último Nome')),
  //         TextFormField(
  //             controller: emailController, // Added email input field
  //             decoration: InputDecoration(labelText: 'Email')),
  //         ElevatedButton(
  //           onPressed: _addUser,
  //           child: Text('Adicionar Usuário'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _addUser() {
  //   if (firstnameController.text.isNotEmpty &&
  //       lastnameController.text.isNotEmpty &&
  //       emailController.text.isNotEmpty) {
  //     userService
  //         .createUser(User(
  //       id: '', // ID é gerado pela API, não precisa enviar
  //       title: tituloController
  //           .text, // Incluído, assumindo que você ainda quer enviar isso
  //       firstName: firstnameController.text,
  //       lastName: lastnameController.text,
  //       email: emailController.text,
  //       picture: pictureController.text, // Incluído, assumindo que é necessário
  //     ))
  //         .then((newUser) {
  //       _showSnackbar('Usuário adicionado com sucesso!');
  //       _refreshUserList();
  //     }).catchError((erro) {
  //       _showSnackbar('Falha ao adicionar usuário: $erro');
  //     });
  //   } else {
  //     _showSnackbar('Por favor preencha todos os campos.');
  //   }
  //}

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

class UserForm {
  const UserForm();
}
