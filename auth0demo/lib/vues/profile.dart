import 'package:auth0demo/vues/vue_admin.dart';
import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/utilisateur_provider.dart';

class Profile extends StatelessWidget {
  const Profile();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<UtilisateurProvider> (
        builder: (context, utilisateurProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 4),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(utilisateurProvider.pictureUrl.toString() ?? '')
                    )
                ),
              ),
              const SizedBox(height: 24),
              Text('Name: ${utilisateurProvider.name ?? ''}'),
              const SizedBox(height: 24),
              VueAdmin(),
              const SizedBox(height: 48),
              ElevatedButton(onPressed: () async {
                await Provider.of<UtilisateurProvider>(context, listen: false).logoutAction();
              },
                  child: const Text('Logout'))
            ],
          );
        }
    );

  }
  
}