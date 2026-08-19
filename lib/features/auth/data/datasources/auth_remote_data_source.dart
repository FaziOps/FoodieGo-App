import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/core/errors/exceptions.dart';
import 'package:restaurant_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();

  Future<void> resetPassword(String email);

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateProfilePic({required String uid, required String imagePath, Uint8List? imageBytes});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    FirebaseStorage? storage,
  }) : storage = storage ?? FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection(AppConstants.usersCollection);

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;

      final model = UserModel(
        uid: uid,
        name: name,
        email: email,
        role: role,
        phone: phone,
      );

      await _users.doc(uid).set(model.toMap());
      return model;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign up failed.');
    } catch (_) {
      throw ServerException('Could not create account.');
    }
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _users.doc(credential.user!.uid).get();
      if (!doc.exists) {
        throw AuthException('No profile found for this account.');
      }
      return UserModel.fromSnapshot(doc);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Login failed.');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Could not send reset email.');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final current = firebaseAuth.currentUser;
    if (current == null) return null;
    final doc = await _users.doc(current.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromSnapshot(doc);
  }

  @override
  Future<UserModel> updateProfilePic({required String uid, required String imagePath, Uint8List? imageBytes}) async {
    try {
      String downloadUrl = '';
      final ref = storage.ref().child('profile_pics/$uid.jpg');

      try {
        if (imageBytes != null) {
          final uploadTask = await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
          downloadUrl = await uploadTask.ref.getDownloadURL();
        } else if (imagePath.isNotEmpty) {
          final uploadTask = await ref.putFile(File(imagePath));
          downloadUrl = await uploadTask.ref.getDownloadURL();
        }
      } catch (storageError) {
        // Fallback: If Firebase Storage is not initialized or in local file sandbox mode,
        // use file path URL / network string directly
        downloadUrl = imagePath;
      }

      if (downloadUrl.isEmpty) {
        downloadUrl = imagePath;
      }

      await _users.doc(uid).update({'profilePic': downloadUrl});

      final doc = await _users.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      } else {
        final current = await getCurrentUser();
        return (current ?? const UserModel(uid: '', name: '', email: '', role: 'customer', phone: '')).copyWith(profilePic: downloadUrl) as UserModel;
      }
    } catch (e) {
      throw ServerException('Failed to update profile picture: ${e.toString()}');
    }
  }
}
