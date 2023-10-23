import 'package:auth0demo/providers/utilisateur_provider.dart';
import 'package:auth0demo/vues/login.dart';
import 'package:auth0demo/vues/profile.dart';
import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:provider/provider.dart';

import 'database/database.dart';

void main() => runApp(MainView());

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool isLoading = false;

  late DatabaseHandler _db;

  @override
  void initState() {
    super.initState();

    _db = DatabaseHandler();

    if(_db.database == null) {
      isLoading = true;
      _initDatabase();
    } else {
      isLoading = false;
    }
  }

  void _initDatabase() async {
    await _db.initDb();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth0 Demo',
      home: Scaffold(
          appBar: AppBar(title: const Text('Auth0 Demo')),
          body: ChangeNotifierProvider(
            create: (context) => UtilisateurProvider(),
            child: Consumer<UtilisateurProvider> (
              builder: (context, utilisateurProvider, child) {
                return Center(
                  child: isLoading || utilisateurProvider.isAuthenticating
                    ? const CircularProgressIndicator()
                    : utilisateurProvider.isLoggedIn
                    ? Profile()
                    : Login()
                );
              }
            )
          )
      )
    );
  }
}
