import 'package:flutter/material.dart';
import 'package:goryon/services/storage_service.dart';
import 'package:provider/provider.dart';

import '../viewmodels.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Future? _loginFuture;
  final _passwordTextController = TextEditingController();
  final _podURLController = TextEditingController();
  final _usernameTextController = TextEditingController();

  Future _handleLogin(BuildContext context) async {
    final storage = Provider.of<StorageService>(context, listen: false);
    try {
      await context.read<AuthViewModel>().login(
            _usernameTextController.text,
            _passwordTextController.text,
            _podURLController.text,
          );
      await storage.savePodUrl(_podURLController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error logging in: " + e.toString())));
    }
  }

  String? requiredFieldValidator(String? value) {
    if (value!.isEmpty) {
      return 'Required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yarn.social')),
      body: AutofillGroup(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(32.0),
            children: [
              SizedBox(height: 16),
              TextFormField(
                validator: requiredFieldValidator,
                controller: _usernameTextController,
                autofillHints: [AutofillHints.username],
                decoration: InputDecoration(
                  labelText: 'Username',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              TextFormField(
                validator: requiredFieldValidator,
                controller: _passwordTextController,
                autofillHints: [AutofillHints.password],
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.url,
                autofillHints: [AutofillHints.url],
                validator: requiredFieldValidator,
                controller: _podURLController,
                decoration: InputDecoration(
                  labelText: 'Pod URL',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(height: 16),
              FutureBuilder(
                future: _loginFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() {
                        _loginFuture = _handleLogin(context);
                      });
                    },
                    child: const Text('Login'),
                  );
                },
              ),
              SizedBox(height: 8),
              Builder(builder: (context) {
                return TextButton(
                  onPressed: () async {
                    if (await Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Register())) ??
                        false) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Successfully registered an account. You can now login',
                        ),
                      ));
                    }
                  },
                  child: const Text('Register'),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
