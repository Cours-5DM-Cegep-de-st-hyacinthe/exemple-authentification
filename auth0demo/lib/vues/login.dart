

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/utilisateur_provider.dart';

class Login extends StatelessWidget {
  const Login ();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () async {
            await Provider.of<UtilisateurProvider>(context, listen: false).loginAction();
          },
          child: const Text('Login')
        ),
        Consumer<UtilisateurProvider> (
          builder: (context, utilisateurProvider, child) {
            return Text(utilisateurProvider.errorMessage ?? '');
          }
        )
      ]
    );
  }
}