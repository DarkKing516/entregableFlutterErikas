import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert'; // for using json.decode()
// import 'login.dart';

import 'signin.dart';

void main() {
  runApp(const MyAppAccount());
}

class MyAppAccount extends StatelessWidget {
  const MyAppAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Editar Usuario',
      home: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -40,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 10,
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -110,
                left: 100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Editar Usuario',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Account(),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _documentController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _loading = true;
  bool _error = false;
  bool _isPasswordVisible = false; // To toggle password visibility

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _documentController = TextEditingController();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _fetchData(); // Fetch user data on initialization
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // The function that fetches data from the API
  Future<void> _fetchData() async {
    final apiUrl =
        'https://api-movil-rh0g.onrender.com/api/users/${LoginPage.odiii}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = json.decode(response.body);

      setState(() {
        _nameController.text = data['name'];
        _phoneController.text = data['phone'];
        _documentController.text = data['document'];
        _emailController.text = data['email'];
        _usernameController.text = data['username'];
        _passwordController.text = data['password'];
        _loading = false;
        _error = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  // Function to update user information
  Future<void> _updateUser() async {
    final apiUrl =
        'https://api-movil-rh0g.onrender.com/api/users/${LoginPage.odiii}';

    final updatedData = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'document': _documentController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        // Successful update
        _showSuccessDialog();
      } else {
        // Error occurred during update
        _showErrorDialog();
        print('Error code: ${response.statusCode}');
        // You can show an error message or handle it as needed
      }
    } catch (error) {
      print('Error: $error');
      _showErrorDialog();
      // Handle network errors
    }
  }

  // Function to show success dialog
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Los datos se actualizaron correctamente.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Function to show error dialog
  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ocurrió un error al actualizar los datos.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthPortion = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network('https://http.cat/401'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginBonito()),
                          );
                        },
                        child: const Text('Regresar'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: screenWidthPortion,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(60),
                              bottomRight: Radius.circular(60),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: 'Nombre'),
                              ),
                              TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                    labelText: 'Teléfono'),
                              ),
                              TextFormField(
                                controller: _documentController,
                                decoration: const InputDecoration(
                                    labelText: 'Documento'),
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Correo electrónico',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su correo electrónico';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                    labelText: 'Nombre de usuario'),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su contraseña';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom - (-250),
                        left: MediaQuery.of(context).size.width / 1 - 140,
                        child: ElevatedButton(
                          onPressed: _updateUser,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(24),
                            backgroundColor: Colors.lightBlue,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
