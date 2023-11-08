import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0demo/controleurs/utilisateur_controleur.dart';
import 'package:auth0demo/models/role.dart';
import 'package:auth0demo/models/utilisateur.dart';
import 'package:auth0demo/providers/utilisateur_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'utilisateur_provider_test.mocks.dart';

// Rouller la commande "dart run build_runner build"

@GenerateMocks([Auth0, WebAuthentication, UtilisateurControleur])
void main() {
  group('loginAction', () {
    test('tester le login', () async {
      final auth0 = MockAuth0();
      final webAuthentication = MockWebAuthentication();
      final utilisateurControleur = MockUtilisateurControleur();

      when(auth0.webAuthentication(scheme: "auth0demo"))
        .thenReturn(webAuthentication);

      when(webAuthentication.login())
        .thenAnswer((_) async => Credentials(
          idToken: "idToken",
          accessToken: "accessToken",
          expiresAt: DateTime.now(),
          user: UserProfile(
            sub: "idUnique",
            name: "nom",
            pictureUrl: Uri(path: "path_to_image")
          ),
          tokenType: "tokenType"));

      when(utilisateurControleur.getOrInsertUtilisateur("idUnique", "nom"))
        .thenAnswer((_) async => Utilisateur("idUnique", "nom", List<Role>.empty()));

      final utilisateurProvider = UtilisateurProvider(auth0, utilisateurControleur);

      expect(utilisateurProvider.isLoggedIn, false);

      await utilisateurProvider.loginAction();

      expect(utilisateurProvider.isLoggedIn, true);
    });

  });
}