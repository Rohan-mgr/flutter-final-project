import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_final_project/helper/directory_path.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/types/Blogs.dart';
import 'package:flutter_final_project/types/profile.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:bcrypt/bcrypt.dart';
import "dart:io";
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthService {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<bool> createFolder(String folderPath, String folderName) async {
    try {
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
      return true;
    } catch (error) {
      print("Error creating folder: $error");
      return false;
    }
  }

  Future<bool> deleteFile(String fullPath) async {
    try {
      final storageRef = storage.ref().child(fullPath);
      await storageRef.delete();
      print('File deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  Future<void> deleteFolder(String folderPath) async {
    final storageRef = storage.ref().child(folderPath);
    final listResult = await storageRef.listAll();

    // Delete files in the current folder
    await Future.forEach(listResult.items, (Reference item) async {
      await item.delete();
    });

    // Recursively delete subfolders
    await Future.forEach(listResult.prefixes, (prefix) async {
      await deleteFolder(prefix.fullPath);
    });
  }

  Future<String?> getFileDownloadUrl(String filePath) async {
    try {
      final fileUrl = await storage.ref().child(filePath).getDownloadURL();
      print('fileUrl => $fileUrl');
      return fileUrl;
    } catch (e) {
      print('Error getting download URL: $e');
      return null;
    }
  }

  Future<int> getUserDownloadCount(String? userId) async {
    try {
      final docRef = db.collection('users').doc(userId);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data()!['downloads'] ?? 0;
      } else {
        print('User document not found');
        return 0; // Handle user not found case (optional)
      }
    } catch (e) {
      print('Error getting download count: $e');
      return 0; // Handle errors (optional)
    }
  }

  Future<void> updateDownloadCount(String? userId) async {
    try {
      final docRef = db.collection('users').doc(userId);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final currentDownloads = docSnapshot.data()!['downloads'] ?? 0;
        await docRef.update({'downloads': currentDownloads + 1});
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error updating download count: $e');
    }
  }

  Future<void> deleteExistingProfileFromStorage(String fullPath) async {
    try {
      final storageRef = storage.ref().child(fullPath);
      await storageRef.delete();
      print('Existing image deleted from storage');
    } catch (e) {
      print('Error deleting image from storage: $e');
    }
  }

  Future<MyUser?> updateUserName(
      String newFirstName, String newLastName, user) async {
    try {
      final docRef = db.collection('users').doc(user?.id);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        print('User document not found');
        return null;
      }

      await docRef.update({
        'firstName': newFirstName,
        'lastName': newLastName,
      });

      return MyUser(
        id: user?.id,
        firstName: newFirstName,
        lastName: newLastName,
        email: user?.email,
        isAdmin: user?.isAdmin,
        profilePic: user?.profilePic,
      );
    } catch (e) {
      print("Error updating user name: $e");
      return null;
    }
  }

  Future<MyUser?> updateUserProfilePicture(
    String? userId,
    UserProfile? userProfile,
  ) async {
    try {
      final docRef = db.collection('users').doc(userId);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        print('User document not found');
        return null;
      }
      final profileData = docSnapshot.data();
      final existingProfile = profileData?['profile'] as Map<String, dynamic>?;

      if (existingProfile == null) {
        print('Profile object not found');
        return null;
      }
      final existingFullPath = existingProfile['storageFullPath'] as String?;
      if (existingFullPath != null &&
          userProfile?.fullStoragePath != existingFullPath) {
        // Delete the existing image file using its full path
        await deleteExistingProfileFromStorage(existingFullPath);
      }

      // Update profile object with new downloadUrl and storageFullPath
      await docRef.update({
        'profile.downloadUrl': userProfile?.downloadUrl,
        'profile.storageFullPath': userProfile?.fullStoragePath,
      });
      return MyUser(
        id: userId!,
        firstName: profileData?['firstName'],
        lastName: profileData?['lastName'],
        email: profileData?['email'],
        isAdmin: profileData?['isAdmin'] ?? false,
        profilePic: userProfile?.downloadUrl,
      );
    } catch (e) {
      print('Error updating profile picture: $e');
      return null;
    }
  }

  // downloading file in the user device
  Future<void> downloadFilePublicly(String? userId, file) async {
    try {
      final fileUrl = await getFileDownloadUrl(file['fullPath']);
      var storePath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      var fileName = file['name'];
      var extension = file['mimeType'] ?? 'ext'; // Handle missing extension
      String path = '$storePath/${fileName}_${Uuid().v4()}.$extension';

      print("Downloading file...");
      await Dio().download(
        fileUrl!,
        path,
      );

      // Update user download count
      if (userId != null) {
        await updateDownloadCount(userId);
      }
    } catch (e) {
      print("Error downloading file publicly: $e");
      return null;
    }
  }

  // downloading file privately for previewing
  Future<String?> downloadFilePrivately(
      String fileName, String filePath) async {
    try {
      final fileUrl = await getFileDownloadUrl(filePath);
      print('fileUrl download privately => $fileUrl');

      var storePath = await DirectoryPath().getPath();
      var path = '$storePath/$fileName';

      bool isFileExists = await File(path).exists();

      if (!isFileExists) {
        print("preparing file...");
        await Dio().download(fileUrl!, path);
      }

      return path;
    } catch (e) {
      print('Error downloading file privately: $e');
      return null;
    }
  }

  Future<UserProfile?> uploadFileToFirebase(File file, String folderPath,
      [bool? isProfilePic]) async {
    try {
      final loggedUser = await Storage.getUser("user");
      String? loggedUsername = loggedUser?.firstName ?? "";
      print("loggedUser file upload => ${loggedUsername}");

      // Check for null and assign default value (optional)
      bool useProfilePicPrefix = isProfilePic ?? false;
      // Create a storage reference with a unique filename
      String fileName = file.path.split("/").last;
      final storageRef = storage.ref().child(
          '$folderPath/${useProfilePicPrefix ? "${Uuid().v4()}_" : ""}$fileName');

      // Define custom metadata
      final metadata = SettableMetadata(
        customMetadata: {
          'uploadBy': loggedUsername,
        },
      );

      // Upload the file to Firebase Storage with custom metadata
      final uploadTask = storageRef.putFile(file, metadata);

      // Track upload progress (optional)
      uploadTask.snapshotEvents.listen((event) {
        int progress =
            ((event.bytesTransferred / event.totalBytes) * 100).round();
        // Display upload progress (e.g., with a progress bar)
        print('Upload progress: $progress%');
      });

      // Wait for the upload to complete
      await uploadTask.whenComplete(() => print('Upload complete'));
      final downloadUrl = await storageRef.getDownloadURL();
      final fullStoragePath = storageRef.fullPath;
      return UserProfile(
          downloadUrl: downloadUrl, fullStoragePath: fullStoragePath);
    } catch (e) {
      print("Error uploading file => $e");
      return null;
    }
  }

  //to upload blog
  Future<void> uploadBlogToFirebase(
      {required File filepath,
      required String title,
      required String content,
      required String fileName}) async {
    try {
      final loggedInUser = (await Storage.getUser("user"))!.email;
      const folderPath = "blogs";
      final storageRef = storage.ref().child('$folderPath/$fileName');
      final createdOn = Timestamp.now();
      String? downloadRef;

      //uploading thumbnail to firebase
      await storageRef.putFile(filepath);
      downloadRef = await storageRef.getDownloadURL();

      Blog blog = new Blog(
        title: title,
        content: content,
        imgUrl: downloadRef,
        user: loggedInUser,
        createdOn: createdOn,
      );
      print("uploading");
      //upload to blog
      DocumentReference doc = await db.collection("blogs").add(blog.toJson());
      print("completely called");
    } catch (error) {
      print(error);
    }
  }

  Future<String> getCorrespondingName({required String email}) async {
    final user =
        await db.collection("users").where("email", isEqualTo: email).get();

    return user.docs[0].data()["firstName"] +
        " " +
        user.docs[0].data()["lastName"];
  }

  //get blogs
  Future<List<Map>> getBlogs() async {
    try {
      final querySnapshot = await db.collection("blogs").get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.reference.id, ...doc.data()})
          .toList();
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<void> LikeBlog(
      {required String blogId,
      required String email,
      required int likes,
      required bool isLiked}) async {
    final documentReference = await db.collection("blogs").doc(blogId);
    final reference = await db.collection("blogs").doc(blogId).get();
    List likedByArr = reference.data()!["likedBy"];
    if (isLiked) {
      likedByArr = [...likedByArr, email];
    } else {
      likedByArr.remove(email);
    }

    await documentReference.update({"likes": likes, "likedBy": likedByArr});
  }

  Future<List<dynamic>> listFoldersAndFiles(String folderPath) async {
    try {
      print('folder path => $folderPath');
      final storageRef = storage.ref().child(folderPath);
      final listResult = await storageRef.listAll();

      List<dynamic> foldersAndFiles = [];

      // Add folders to the list
      for (var prefix in listResult.prefixes) {
        final fullPath = '${folderPath}/${prefix.name}';
        foldersAndFiles
            .add({'type': 'folder', 'name': prefix.name, 'fullPath': fullPath});
      }

      // Add files to the list
      // Filter out items without metadata
      final itemsWithMetadata = listResult.items
          .where((item) => !item.name.endsWith(".empty"))
          .toList();

      final metadataFutures = itemsWithMetadata
          .map((item) => storage.ref().child(item.fullPath).getMetadata());

      // Wait for all metadata requests to complete
      final List<FullMetadata> metadataList =
          await Future.wait(metadataFutures);

      // Process metadata and add files to the list
      for (int i = 0; i < itemsWithMetadata.length; i++) {
        final item = itemsWithMetadata[i];
        final metadata = metadataList[i];

        final sizeInKB = (metadata.size ?? 0) / 1000;
        final size = sizeInKB < 1000
            ? '${sizeInKB.toStringAsFixed(2)} KB'
            : '${(sizeInKB / 1000).toStringAsFixed(2)} MB';

        final createdAt =
            DateFormat('yyyy-MM-dd', 'en_US').format(metadata.timeCreated!);
        final uploadedBy = metadata.customMetadata?['uploadBy'] ?? '';
        final mimeType = item.fullPath.split(".").last;

        foldersAndFiles.add({
          'type': 'file',
          'name': item.name,
          'fullPath': item.fullPath,
          'mimeType': mimeType,
          'createdAt': createdAt,
          'fileSize': size,
          'uploadedBy': uploadedBy,
        });
      }

      return foldersAndFiles;
    } catch (e) {
      print('Error listing folders and files: $e');
      throw e;
    }
  }

  Future<void> removeFilesFromFavouriteList(String documentId) async {
    try {
      await db.collection('favourites').doc(documentId).delete();
      print('File removed from favourite list successfully');
    } catch (e) {
      print('Error removing file from favourite list: $e');
      throw e;
    }
  }

  Future<List<dynamic>> listFavouriteFiles(String? userId) async {
    try {
      final favouriteFiles = await db
          .collection('favourites')
          .where('userId', isEqualTo: userId)
          .get();

      List<dynamic> files = [];
      favouriteFiles.docs.forEach((file) {
        final data = file.data();
        data['documentId'] = file.id;
        files.add(data);
        print("data => $data");
      });

      return files;
    } catch (e) {
      print('Error listing favourite files: $e');
      throw e;
    }
  }

  Future<void> addFileToFavouriteList(String? userId, file) async {
    try {
      final fileExits = await db
          .collection('favourites')
          .where('userId', isEqualTo: userId)
          .where('name', isEqualTo: file?['name'])
          .get();
      if (fileExits.docs.isNotEmpty) {
        throw "File already exists in favourite list";
      }

      final favouriteFile = <String, dynamic>{
        'createdAt': file?['createdAt'],
        'fullPath': file?['fullPath'],
        'name': file?['name'],
        'size': file?['fileSize'],
        'uploadedBy': file?['uploadedBy'],
        'mimeType': file?['mimeType'],
        'userId': userId,
      };

      DocumentReference doc =
          await db.collection("favourites").add(favouriteFile);
      print('File added to favourite list successfully, ${doc.id}');
    } catch (e) {
      print('Error adding file to favourite list: $e');
      throw e;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String firstName, String lastName, String email, String password) async {
    try {
      // Check if the email already exists
      final emailExists =
          await db.collection('users').where('email', isEqualTo: email).get();

      if (emailExists.docs.isNotEmpty) {
        throw "Email address already exists";
      }

      String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      final user = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': hashedPassword,
        'isAdmin': false,
        'profile': {'downloadUrl': "", 'storageFullPath': ""}
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
        isAdmin: userData['isAdmin'] ?? false,
        profilePic: userData['profile']?['downloadUrl'] ?? "",
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
}
