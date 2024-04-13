import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthService {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<void> createFolder(String folderPath, String folderName) async {
    try {
      print("Creating folder: $folderPath");
      final reference = FirebaseStorage.instance.ref().child(folderPath +
          "/" +
          folderName +
          "/.empty"); // Add ".empty" to filename
      final newMetaData = SettableMetadata(
        contentType: 'text/plain',
        customMetadata: {'folderName': folderName},
      );
      String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';
      await reference.putString(dataUrl,
          format: PutStringFormat.dataUrl, metadata: newMetaData);
      print("Folder created (simulated) at: $folderPath");
    } catch (error) {
      print("Error creating folder: $error");
    }
  }

  Future<List<dynamic>> listFoldersAndFiles(String folderPath) async {
    try {
      print('folder path => $folderPath');
      final storageRef = storage.ref().child(folderPath);
      final listResult = await storageRef.listAll();

      List<dynamic> foldersAndFiles = [];

      // Add folders to the list
      for (var prefix in listResult.prefixes) {
        foldersAndFiles.add({'type': 'folder', 'name': prefix.name});
      }

      // Add files to the list
      for (var item in listResult.items) {
        if (!item.name.endsWith(".empty")) {
          foldersAndFiles.add({'type': 'file', 'name': item.name});
        }
      }
      return foldersAndFiles;
    } catch (e) {
      print('Error listing folders and files: $e');
      throw e;
    }
  }

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

  Future<MyUser?> signInWithEmailAndPassword(
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

      return MyUser(
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

  Future<bool> updatePassword(
      {required String email, required String newPassword}) async {
    try {
      final user =
          await db.collection("users").where("email", isEqualTo: email).get();
      String hashedPw = BCrypt.hashpw(newPassword, BCrypt.gensalt());
      user.docs.first.reference.update({"password": hashedPw});
      return true;
    } catch (error) {
      print("Error updating Password");
      return false;
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

  Future<bool> storeOTP({required String otp, required String email}) async {
    //find user
    try {
      final user_ref =
          await db.collection("users").where("email", isEqualTo: email).get();
      //store in otp field
      user_ref.docs[0].reference.update({"one_time_password": otp});
      return true;
    } catch (error) {
      print("Error storing otp");
      return false;
    }
  }

  Future<bool> verifyOTP({required String otp, required String email}) async {
    try {
      final user =
          await db.collection("users").where("email", isEqualTo: email).get();
      String dbOtp = user.docs.first.data()["one_time_password"];

      if (dbOtp != otp) throw "error";
      return true;
    } catch (error) {
      print("incorrect otp");
      return false;
    }
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
