import 'package:auth0demo/vues/login.dart';
import 'package:auth0demo/vues/profile.dart';
import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

void main() => runApp(MainView());

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;
  bool isLoading = false;

  late Auth0 auth0;
  late String errorMessage;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-t2ru3diusrdscg80.us.auth0.com',
        'ayafMTRoW0dY5tCdVTiQcqoAXy6ghAAa');
    errorMessage = '';
  }

  Future<void> logoutAction() async {
    await auth0.webAuthentication(scheme: "auth0demo").logout();

    setState(() {
      _credentials = null;
    });
  }

  Future<void> loginAction() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final credentials = await auth0.webAuthentication(scheme: "auth0demo").login();

      setState(() {
        isLoading = false;
        _credentials = credentials;
      });
    } on Exception catch(e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth0 Demo',
      home: Scaffold(
          appBar: AppBar(title: const Text('Auth0 Demo')),
          body: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : _credentials == null
                      ? Login(loginAction, errorMessage)
                      : Profile(logoutAction, _credentials?.user))),
    );
  }
}
