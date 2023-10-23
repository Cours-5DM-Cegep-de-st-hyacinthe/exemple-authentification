import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/utilisateur_provider.dart';

class VueAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UtilisateurProvider> (
      builder: (context, utilisateurProvider, child) {
        return utilisateurProvider.isLoggedIn
          ? Text('Je suis un admin')
          : SizedBox.shrink();
      }
    );

  }

}