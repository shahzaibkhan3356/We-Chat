import 'package:chat_app/Bloc/UserBloc/user_event.dart';
import 'package:chat_app/Bloc/UserBloc/user_state.dart';
import 'package:chat_app/Presentation/Widgets/CropImage/CropImage.dart';
import 'package:chat_app/Repository/FirestoreRepository/FirestoreRepo.dart';
import 'package:chat_app/Utils/NavigationService/navigation_service.dart';
import 'package:chat_app/Utils/Snackbar/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

mixin UserBlocImageMixin on Bloc<UserEvent, UserState> {
  void registerImageEvents() {
    on<PickAndCropProfileImage>(_onPickAndCropProfileImage);
  }

  Future<void> _onPickAndCropProfileImage(
    PickAndCropProfileImage event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(isUploadingProfilePic: true));
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: event.source,
        imageQuality: 80,
      );
      if (pickedFile == null) {
        emit(state.copyWith(isUploadingProfilePic: false));
        showSnackbar("Error", "No Image Selected");
        return;
      }
      // Crop
      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) {
        emit(state.copyWith(isUploadingProfilePic: false));
        showSnackbar("Error", "No context for cropping");
        return;
      }
      final croppedPath = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => CropImage(path: pickedFile.path)),
      );
      if (croppedPath == null || croppedPath.isEmpty) {
        emit(state.copyWith(isUploadingProfilePic: false));
        showSnackbar("Error", "No Image Selected");
        return;
      }
      emit(
        state.copyWith(
          localProfilePicPath: croppedPath,
          isUploadingProfilePic: true,
        ),
      );
      // Upload
      final url = await RepositoryProvider.of<FirestoreRepo>(
        context,
      ).uploadProfilePicture(croppedPath);
      if (url != null) {
        emit(
          state.copyWith(
            profilepic: url,
            isUploadingProfilePic: false,
            localProfilePicPath: null,
          ),
        );
        showSnackbar("Profile", "Profile picture updated!");
      } else {
        emit(
          state.copyWith(
            isUploadingProfilePic: false,
            localProfilePicPath: null,
          ),
        );
        showSnackbar("Error", "Failed to upload profile picture");
      }
    } catch (e) {
      emit(
        state.copyWith(isUploadingProfilePic: false, localProfilePicPath: null),
      );
      showSnackbar("Error", "Error picking/cropping/uploading image");
    }
  }
}
