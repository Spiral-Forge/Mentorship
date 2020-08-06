
import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';

class Constants{

  final AuthService _auth=AuthService();
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  Future<FirebaseUser> getCurrentUser(){
    return _authUser.currentUser();
  }

  static String myName = "";
}