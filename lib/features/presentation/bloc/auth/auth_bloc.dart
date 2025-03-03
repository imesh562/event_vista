import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventvista/features/domain/repositories/repository.dart';
import 'package:eventvista/utils/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/models/common/common_error_response.dart';
import '../base_bloc.dart';
import '../base_event.dart';
import '../base_state.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Base<AuthEvent, BaseState<AuthState>> {
  final Repository repository;
  final DeviceInfo deviceInfo;
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  AuthBloc({
    required this.repository,
    required this.deviceInfo,
    required this.auth,
    required this.fireStore,
  }) : super(AuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignOutEvent>(_onSignOut);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<FetchUserProfileEvent>(_onFetchUserProfile);
  }

  Future<UserCredential> _signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await fireStore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<void> _signOut() async {
    await auth.signOut();
  }

  Future<bool> _isProfileComplete() async {
    if (currentUser == null) return false;

    DocumentSnapshot userDoc =
        await fireStore.collection('users').doc(currentUser!.uid).get();
    return userDoc.exists && userDoc.get('profileCompleted') == true;
  }

  Future<Directory> _getCacheDir() async {
    final appDir = await getApplicationCacheDirectory();
    final cacheDir = Directory('${appDir.path}/profile_pictures');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir;
  }

  Future<String> _uploadProfilePicture(File imageFile) async {
    if (currentUser == null) throw Exception('No authenticated user');

    try {
      final cacheDir = await _getCacheDir();

      String fileName = 'profile_${currentUser!.uid}.jpg';
      File cachedImage = File('${cacheDir.path}/$fileName');

      await imageFile.copy(cachedImage.path);

      String cachedPath = cachedImage.path;

      await fireStore.collection('users').doc(currentUser!.uid).update({
        'profileImagePath': cachedPath,
        'profileImageCached': true,
        'profileImageUpdatedAt': FieldValue.serverTimestamp(),
      });

      return cachedPath;
    } catch (e) {
      throw Exception('Failed to cache profile picture: ${e.toString()}');
    }
  }

  Future<File?> getProfilePictureFromCache() async {
    if (currentUser == null) return null;

    try {
      final userData = await _getUserProfile();

      if (userData != null &&
          userData.containsKey('profileImagePath') &&
          userData['profileImageCached'] == true) {
        String imagePath = userData['profileImagePath'];
        File cachedImage = File(imagePath);

        if (await cachedImage.exists()) {
          return cachedImage;
        }
      }

      return null;
    } catch (e) {
      print('Error getting cached profile picture: ${e.toString()}');
      return null;
    }
  }

  Future<void> _updateUserProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String mailingAddress,
  }) async {
    if (currentUser == null) throw Exception('No authenticated user');

    await fireStore.collection('users').doc(currentUser!.uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'mailingAddress': mailingAddress,
      'profileCompleted': true,
    });
  }

  Future<Map<String, dynamic>?> _getUserProfile() async {
    if (currentUser == null) return null;

    DocumentSnapshot userDoc =
        await fireStore.collection('users').doc(currentUser!.uid).get();
    if (!userDoc.exists) return null;

    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<BaseState<AuthState>> emit,
  ) async {
    emit(APILoadingState());

    try {
      final userCredential = await _signUpWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthNeedsProfilePicture(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email and password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage =
              'The password is too weak. Please use a stronger password.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = 'Sign up failed: ${e.message ?? e.code}';
      }

      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: errorMessage,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      String errorMessage = 'Database error: ${e.message ?? e.code}';

      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: errorMessage,
          ),
        ),
      );
    } catch (e) {
      String errorMessage;

      if (e is SocketException) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e is TimeoutException) {
        errorMessage = 'Connection timed out. Please try again.';
      } else {
        errorMessage = 'An unexpected error occurred: ${e.toString()}';
      }

      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<BaseState<AuthState>> emit,
  ) async {
    emit(APILoadingState());

    try {
      final userCredential = await _signInWithEmailAndPassword(
        event.email,
        event.password,
      );

      bool isProfileComplete = await _isProfileComplete();

      if (isProfileComplete) {
        emit(AuthAuthenticated(userCredential.user!));
      } else {
        final userData = await _getUserProfile();
        final hasProfilePicture = userData != null &&
            userData.containsKey('profileImagePath') &&
            userData['profileImageCached'] == true;

        if (hasProfilePicture) {
          emit(AuthProfileIncomplete(userCredential.user!));
        } else {
          emit(AuthNeedsProfilePicture(userCredential.user!));
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email and password login is not enabled.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message ?? e.code}';
      }

      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: errorMessage,
          ),
        ),
      );
    } catch (e) {
      String errorMessage;

      if (e is SocketException) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e is TimeoutException) {
        errorMessage = 'Connection timed out. Please try again.';
      } else {
        errorMessage = 'An unexpected error occurred: ${e.toString()}';
      }

      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<BaseState<AuthState>> emit,
  ) async {
    emit(APILoadingState());

    try {
      await _signOut();
      emit(
        AuthorizedFailureState(
          errorResponseModel: ErrorResponseModel(),
        ),
      );
    } catch (e) {
      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePictureEvent event,
    Emitter<BaseState<AuthState>> emit,
  ) async {
    emit(APILoadingState());

    try {
      await _uploadProfilePicture(event.imageFile);
      emit(AuthProfileIncomplete(currentUser!));
    } catch (e) {
      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<BaseState<AuthState>> emit,
  ) async {
    emit(APILoadingState());

    try {
      await _updateUserProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        mailingAddress: event.mailingAddress,
      );

      emit(AuthAuthenticated(currentUser!));
    } catch (e) {
      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<BaseState<AuthState>> emit,
  ) async {
    emit(APILoadingState());

    try {
      final userData = await _getUserProfile();

      if (userData != null) {
        File? profilePicture = await getProfilePictureFromCache();

        final completeUserData = {
          ...userData,
          'profilePic': profilePicture,
        };

        emit(ProfileLoaded(
          currentUser!,
          completeUserData,
        ));
      } else {
        emit(
          APIFailureState(
            errorResponseModel: ErrorResponseModel(
              responseError: 'User profile not found',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        APIFailureState(
          errorResponseModel: ErrorResponseModel(
            responseError: e.toString(),
          ),
        ),
      );
    }
  }
}
