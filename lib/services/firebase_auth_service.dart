import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:bcrypt/bcrypt.dart';

class FirebaseAuthService {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createUserWithEmailAndPassword(
      String firstName, String lastName, String email, String password) async {
    try {
      // Check if the email already exists
      final emailExists = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (emailExists.docs.isNotEmpty) {
        throw "Email address already exists";
      }

      String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      final user = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': hashedPassword,
      };

      DocumentReference doc = await db.collection("users").add(user);
      print('User created successfully, ${doc.id}');
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final snapshot =
          await db.collection("users").where('email', isEqualTo: email).get();

      if (snapshot.docs.isEmpty) {
        throw 'User not found';
      }
      final userData = snapshot.docs.first.data();

      bool checkPassword = BCrypt.checkpw(password, userData['password']);
      if (!checkPassword) {
        throw 'Password is incorrect';
      }

      return User(
        id: snapshot.docs.first.id,
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        email: userData['email'],
      );
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<String> userExists({required String email}) async {
    var firstName = "";
    final emailExists =
        await db.collection("users").where("email", isEqualTo: email).get();

    if (emailExists.docs.isEmpty) {
      throw "Email address does not exist";
    }
    firstName = emailExists.docs[0].data()["firstName"];

    return firstName; //"" or "email";
  }

  // for signing out
  // Future<void> signOut() async {
  //   await _firebaseAuth.signOut();
  // }

  // for authentication using email/password providers
  // Future<User?> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // for sign in authentication with email/password providers
  // Future<User?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   print('$email, $password, login ');
  //   try {
  //     final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}
