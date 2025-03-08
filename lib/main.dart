import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/sidebar.dart';
import 'package:flutter_application_3/models/team.dart';
import 'package:flutter_application_3/pages/category/category.list.dart';
import 'package:flutter_application_3/pages/login/login.dart';
import 'package:flutter_application_3/pages/login/register.dart';
import 'package:flutter_application_3/pages/category/category.new.dart';
import 'package:flutter_application_3/pages/product/product.new.dart';
import 'package:flutter_application_3/pages/product/product.list.dart';
import 'package:flutter_application_3/pages/sync/sync.list.dart';
import 'package:flutter_application_3/pages/team/team.add.member.dart';
import 'package:flutter_application_3/pages/team/team.list.dart';
import 'package:flutter_application_3/pages/team/team.new.dart';
import 'package:flutter_application_3/services/api.dart';
import 'package:flutter_application_3/store/app.action.dart';
import 'package:flutter_application_3/store/app.middleware.dart';
import 'package:flutter_application_3/store/app.reducer.dart';
import 'package:flutter_application_3/store/app.state.dart';
import 'package:flutter_application_3/store/team/team.action.dart';
import 'package:flutter_application_3/store/userAuth/userauth.action.dart';
import 'package:flutter_application_3/store/userAuth/userauth.vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
Future<void> main() async {
  await Supabase.initialize(
    url: 'https://mfswdevkbyrhtmbgcoyv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1mc3dkZXZrYnlyaHRtYmdjb3l2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwNDQ4MzUsImV4cCI6MjAzNTYyMDgzNX0.4-D1kbwwRQ7b6JV9lNqa2iTmYHwnW64Z0cFPBBhOJbI',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
    storageOptions: const StorageClientOptions(
      retryAttempts: 10,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  String? currentUserId = prefs.getString('currentUser');

  print('currentUserId: $currentUserId');

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(
      key: currentUserId ?? 'default',
    ),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
    debug: true,
  );
  late final AppState initialState;
  try {
    initialState =AppState.initial();// (await persistor.load())! ;
    //;
  } catch (e) {
    initialState = AppState.initial();
  }

  // presist edilmiş kullanıcı tokını burada kontrol edilecek
  try {
    if (initialState.userAuthState.session != null) {
      String? accessToken = initialState.userAuthState.session!.accessToken;

      await supabase.auth.recoverSession(accessToken);
    }
  } catch (e) {
    print(e);
  }

  final store = Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [
      persistor.createMiddleware(),
      connectivityMiddleware,
    ],
  );

  await API.initialize();

  try {
    int responseCode = await API.client.connectBackend();
    if (responseCode == 401) {
      store.dispatch(UserAuthLogoutAction());
    } else if (responseCode != 200) {
      store.dispatch(CheckConnectivityAction());
    }
  } catch (e) {
    store.dispatch(CheckConnectivityAction());
  }
  
  runApp(Phoenix(
      child: MyApp(store: store)
    ));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  // final List<Product> products = List.generate(10, (index) => Product.random());
  // final List<Category> categories = Category.randomCategoryList(count: 20);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget homePage = MyHomePage(
      title: 'Categrizator',
    );
    return StoreProvider(
      store: store,
      child: Root(store: store, homePage: homePage),
    );
  }
}

class Root extends StatelessWidget {
  const Root({
    super.key,
    required this.store,
    required this.homePage,
  });

  final Store<AppState> store;
  final Widget homePage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      home: store.state.userAuthState.user == null ? LoginPage() : homePage,
      routes: {
        '/products': (context) => MyHomePage.products(
              title: 'Categrizator',
            ),
        '/categories': (context) => MyHomePage.categories(
              title: 'Categrizator',
            ),
        '/newProduct': (context) => const NewProductPage(),
        '/newCategory': (context) => CreateCategoryPage(),
        '/login': (context) =>
            store.state.userAuthState.user == null ? LoginPage() : homePage,
        '/register': (context) => store.state.userAuthState.user == null
            ? const RegisterPage()
            : homePage,
        '/team': (context) => MyHomePage.team(
              title: 'Categrizator',
            ),
        '/newTeam': (context) => const NewTeamPage(),
        '/team/add': (context) => TeamAddMemberPage(
              arguments: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
        ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  int selectedIndex = 0;

  factory MyHomePage.products({
    Key? key,
    required String title,
  }) {
    return MyHomePage(key: key, title: title, selectedIndex: 0);
  }

  factory MyHomePage.categories({
    Key? key,
    required String title,
  }) {
    return MyHomePage(key: key, title: title, selectedIndex: 1);
  }

  factory MyHomePage.team({
    Key? key,
    required String title,
  }) {
    return MyHomePage(key: key, title: title, selectedIndex: 2);
  }

  MyHomePage({super.key, required this.title, this.selectedIndex = 0});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  List<Widget> _pages = [];
  late StreamSubscription<List<ConnectivityResult>> subscription;
  final TextEditingController teamController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const ProductsList(),
      const CategoryList(),
      const TeamList(),
    ];

    selectedIndex = widget.selectedIndex;
  }

  void onConnectivityChanged(
    List<ConnectivityResult> event, Store<AppState> store) {
      bool isOnline = event.contains(ConnectivityResult.none) ? false : true;
      store.dispatch(UpdateConnectivityAction(isOnline));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserAuthViewModel>(
      onInit: (store) => {
        store.dispatch(CheckUserAuthAction()),
        subscription = Connectivity().onConnectivityChanged.listen((event) {
          onConnectivityChanged(event, store);
        }),
        if (store.state.isOnline
            && !API.client.isInitilFetch
        ) {API.client.getAllMyData(store)}
      },
      onDispose: (store) => subscription.cancel(),
      converter: (store) => UserAuthViewModel.fromStore(store),
      builder: (context, UserAuthViewModel userAuthViewModel) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              DropdownMenu(
                initialSelection:
                    userAuthViewModel.store.state.teamState.selectedTeam?.name,
                dropdownMenuEntries: [
                  const DropdownMenuEntry(
                    value: '00000000-0000-0000-0000-000000000000',
                    label: 'Personal',
                  ),
                  for (var team
                      in userAuthViewModel.store.state.teamState.teams)
                    DropdownMenuEntry(
                      value: team.id,
                      label: team.name,
                    ),
                ],
                onSelected: (value) => {
                  if (value == '00000000-0000-0000-0000-000000000000')
                    userAuthViewModel.store.dispatch(
                      SelectTeamAction(
                        Team(
                          id: '00000000-0000-0000-0000-000000000000',
                          name: userAuthViewModel
                                  .store.state.userAuthState.user?.email ??
                              '',
                          userId: userAuthViewModel
                              .store.state.userAuthState.user!.id,
                        ),
                      ),
                    )
                  else
                    userAuthViewModel.store.dispatch(
                      SelectTeamAction(
                        userAuthViewModel.store.state.teamState.teams
                            .firstWhere(
                          (element) => element.id == value,
                        ),
                      ),
                    ),
                    API.client.getAllMyData(userAuthViewModel.store)
                },
              ),
              IconButton(
                icon: userAuthViewModel.store.state.isOnline
                    ? const Icon(Icons.wifi)
                    : const Icon(Icons.wifi_off),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SyncList()));
                },
              ),
            ],
          ),
        ),
        body: _pages[selectedIndex],
        drawer: Sidebar(),
        floatingActionButton:
            ([0, 1, 2].where((element) => element == selectedIndex).isNotEmpty)
                ? FloatingActionButton(
                    onPressed: () {
                      switch (selectedIndex) {
                        case 0:
                          Navigator.pushNamed(context, '/newProduct');
                          break;
                        case 1:
                          Navigator.pushNamed(context, '/newCategory');
                          break;
                        case 2:
                          Navigator.pushNamed(context, '/newTeam');
                          break;
                      }
                    },
                    tooltip: 'Add',
                    child: const Icon(Icons.add),
                  )
                : null,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
            selectedIndex = value;
          }),
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Teams',
            ),
          ],
        ),
      ),
    );
  }
}
