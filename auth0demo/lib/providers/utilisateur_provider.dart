
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0demo/controleurs/utilisateur_controleur.dart';
import 'package:auth0demo/models/role.dart';
import 'package:auth0demo/models/utilisateur.dart';
import 'package:flutter/material.dart';

class UtilisateurProvider extends ChangeNotifier {
  Credentials? _credentials;
  Utilisateur? _utilisateur;
  bool _isAuthenticating = false;
  late Auth0 _auth0;
  late UtilisateurControleur _utilisateurControleur;
  late String _errorMessage = '';

  List<Role>? get roles => _utilisateur?.roles;

  bool get isLoggedIn => _credentials != null;
  bool get isAuthenticating => _isAuthenticating;
  String get errorMessage => _errorMessage;
  Uri? get pictureUrl => _credentials?.user.pictureUrl;
  String? get name => _credentials?.user.name;

  bool hasRole(String role) {
    return roles?.any((r) => r.role == role) ?? false;
  }

  UtilisateurProvider(Auth0 auth0, UtilisateurControleur utilisateurControleur) {
    _auth0 = auth0;
    _utilisateurControleur = utilisateurControleur;
    _errorMessage = '';
  }

  Future<void> loginAction() async {
    _isAuthenticating = true;
    _errorMessage = '';

    notifyListeners();

    try {
      final credentials = await _auth0.webAuthentication(scheme: "auth0demo").login();

      Utilisateur utilisateur = await _utilisateurControleur.getOrInsertUtilisateur(
          credentials.user.sub,
          credentials.user.name
      );

      _isAuthenticating = false;
      _credentials = credentials;
      _utilisateur = utilisateur;

      notifyListeners();
    } on Exception catch(e, s) {
      debugPrint('login error: $e - stack: $s');

      _isAuthenticating = false;
      _errorMessage = e.toString();

      notifyListeners();
    }
  }

  Future<void> logoutAction() async {
    await _auth0.webAuthentication(scheme: "auth0demo").logout();

    _credentials = null;
    _utilisateur = null;

    notifyListeners();
  }
}