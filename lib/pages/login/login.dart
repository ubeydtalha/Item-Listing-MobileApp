import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/userAuth/userauth.action.dart';
import 'package:flutter_application_3/store/userAuth/userauth.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserAuthViewModel>(
      converter: (store) => UserAuthViewModel.fromStore(store),
      builder: (context, userAuthViewModel) => Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    AuthResponse response =
                        await Supabase.instance.client.auth.signInWithPassword(
                      email: _usernameController.text,
                      password: _passwordController.text,
                    );
                    if (response.user == null ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign in failed')),
                      );
                    } else {
                      try {
                        API.initialize();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('An error occurred: $e')),
                        );
                        
                      }
                      StoreProvider.of<AppState>(context).dispatch(
                          UserAuthSuccessAction(
                              user: response.user,
                              session: response.session,
                              isSuccess: 1));

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('currentUser', response.user!.id);

                      Phoenix.rebirth(context);

                      // Navigator.of(context).restorablePushNamedAndRemoveUntil(
                      //     '/products', (route) => false);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },),

              if (userAuthViewModel.isLoading)
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
