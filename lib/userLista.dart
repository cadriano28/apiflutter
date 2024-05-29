
// import 'package:apiflutter/main.dart';
// import 'package:apiflutter/main.dart';
// import 'package:apiflutter/user.dart';
// import 'package:apiflutter/user_service.dart';
// import 'package:flutter/material.dart';

// import 'main.dart';
// import 'userLista.dart';

// class UserListScreen extends StatefulWidget {
//   const UserListScreen({super.key});

//   @override
//   State UserListScreen> createState() =>  UserListScreenState();

// }

// class  UserListScreenState extends State UserListScreen> {
// _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   late Future<List<User>> futureUsers;
//   final UserService userService = UserService();

//   final TextEditingController tituloController = TextEditingController();
//   final TextEditingController firstnameController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();
//   final TextEditingController emailController =
//       TextEditingController(); // Added for email
//   final TextEditingController pictureController = TextEditingController();

//    void _addUser() {
//     if (firstnameController.text.isNotEmpty &&
//         lastnameController.text.isNotEmpty &&
//         emailController.text.isNotEmpty) {
//       userService
//           .createUser(User(
//         id: '', // ID é gerado pela API, não precisa enviar
//         title: tituloController.text, // Incluído, assumindo que você ainda quer enviar isso
//         firstName: firstnameController.text,
//         lastName: lastnameController.text,
//         email: emailController.text,
//         picture: pictureController.text, // Incluído, assumindo que é necessário
//       ))
//           .then((newUser) {
//         _showSnackbar('User added successfully!');
//         _refreshUserList();
//       }).catchError((error) {
//         _showSnackbar('Failed to add user: $error');
//       });
//     } else {
//       _showSnackbar('Please fill in all fields.');
//     }
//   }

//   void _refreshUserList() {
//     setState(() {
//       futureUsers = userService.getUsers();
//     });
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   void initState() {
//     super.initState();
//     futureUsers = userService.getUsers();
//   }
//   @override

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         children: <Widget>[
//           TextFormField(
//               controller: firstnameController,
//               decoration: InputDecoration(labelText: 'First Name')),
//           TextFormField(
//               controller: lastnameController,
//               decoration: InputDecoration(labelText: 'Last Name')),
//           TextFormField(
//               controller: emailController, // Added email input field
//               decoration: InputDecoration(labelText: 'Email')),
//           ElevatedButton(
//             onPressed: _addUser,
//             child: Text('Add User'),
//           ),
//         ],
//       ),
//     );),
//     )
    
    
//   }

// }

//   @override
  


