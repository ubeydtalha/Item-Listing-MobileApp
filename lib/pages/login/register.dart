import 'package:flutter/material.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/userAuth/userauth.action.dart';
import 'package:flutter_application_3/store/userAuth/userauth.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _submit(context) async {
  if (_formKey.currentState!.validate()) {
    // Ensure password is not empty
    if (_passwordController.text.isEmpty) {
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password cannot be empty')),
      );
      return;
    }

    // Process data
    try {
      final response = await Supabase.instance.client.auth.signUp(
        password: _passwordController.text,
        email: _emailController.text,
        // data: {
        //   'name': _usernameController.text,
        // },
      );

      if (response.user != null) {
        StoreProvider.of<AppState>(context).dispatch(UserAuthSuccessAction(user: response.user, isSuccess: 1));
        // Handle sign-up success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up successful')),
        );
        Navigator.of(context).pop();
      } else {
        // Handle sign-up failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up failed')),
        );
      }
    } catch (e) {
      // Handle exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,UserAuthViewModel>(
      converter: (store) => UserAuthViewModel.fromStore(store),
      builder:(context , UserAuthViewModel userAuthViewModel) => Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _submit(context),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}