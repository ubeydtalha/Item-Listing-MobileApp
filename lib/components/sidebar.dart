import 'package:flutter/material.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/userAuth/userauth.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserAuthViewModel>(
      converter: (store) => UserAuthViewModel.fromStore(store),
      builder: (context, UserAuthViewModel userAuthViewModel) => Drawer(
        child: Stack(
          children: [
            ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: Image.network(
                          'https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png',
                        ).image,
                      ),
                      Text(userAuthViewModel.user?.appMetadata["name"] ??
                          userAuthViewModel.user?.email ??
                          ''),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Products'),
                  onTap: () {
                    Navigator.of(context).restorablePushNamedAndRemoveUntil(
                        '/products', (route) => false);
                  },
                ),
                ListTile(
                  title: const Text('Categories'),
                  onTap: () {
                    Navigator.of(context).restorablePushNamedAndRemoveUntil(
                        '/categories', (route) => false);
                  },
                ),
                ListTile(
                  title: const Text('Team'),
                  onTap: () {
                    Navigator.of(context).restorablePushNamedAndRemoveUntil(
                        '/team', (route) => false);
                    
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () async {
                            userAuthViewModel.userLogout();
                            Supabase.instance.client.auth.signOut().then(
                                (res) => {
                                      Navigator.of(context)
                                          .restorablePushNamedAndRemoveUntil(
                                              '/login', (route) => false)
                                    });
                            
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('currentUser', "app");

                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
