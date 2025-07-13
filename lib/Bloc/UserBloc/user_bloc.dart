import 'package:bloc/bloc.dart';
import 'package:chat_app/Bloc/UserBloc/user_event.dart';
import 'package:chat_app/Bloc/UserBloc/user_state.dart';
import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:image_picker/image_picker.dart';

import '../../Repository/FirestoreRepository/FirestoreRepo.dart';
import '../../Utils/NavigationService/navigation_service.dart';
import '../../Utils/Snackbar/Snackbar.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreRepo firestoreRepo;

  UserBloc(this.firestoreRepo) : super(const UserState()) {
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<GetAllUsers>(_getAllUsers);
    on<PickAndUploadProfileImage>(_onPickAndUploadImage);
    on<FetchProfilePicUrl>(_onFetchProfilePic);
    on<GetUserData>((event, emit) async {
      final user = await firestoreRepo.getUser();
      emit(state.copyWith(currentUser: user));
    });
  }





  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await firestoreRepo.createUser(event.userModel);
      NavigationService.Gofromall(RouteNames.home);
      showSnackbar("Profile", "Profile Created Successfully");
      emit(state.copyWith(isLoading: false, currentUser: event.userModel));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: firestoreRepo.getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await firestoreRepo.updateUser(event.userModel);
      showSnackbar("Profile", "Profile Updated Successfully");
      emit(state.copyWith(isLoading: false, currentUser: event.userModel));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: firestoreRepo.getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _getAllUsers(GetAllUsers event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final users = await firestoreRepo.getAllUsers();
      emit(state.copyWith(isLoading: false, allUsers: users));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: firestoreRepo.getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onFetchProfilePic(
    FetchProfilePicUrl event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final profileUrl = await firestoreRepo.getProfilePictureUrl();
      emit(state.copyWith(isLoading: false, profileImageUrl: profileUrl ?? ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: firestoreRepo.getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onPickAndUploadImage(
    PickAndUploadProfileImage event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(isUploadingProfileImage: true));

      final pickedFile = await ImagePicker().pickImage(
        source: event.source,
        imageQuality: 50,
      );
      if (pickedFile == null) {
        emit(state.copyWith(isUploadingProfileImage: false));
        return;
      }

      emit(state.copyWith(localProfileImagePath: pickedFile.path));

      final imageUrl = await firestoreRepo.uploadProfilePicture(
        pickedFile.path,
      );
      if (imageUrl != null) {
        emit(state.copyWith(profileImageUrl: imageUrl));
      }

      emit(state.copyWith(isUploadingProfileImage: false));
    } catch (e) {
      emit(state.copyWith(isUploadingProfileImage: false));
      showSnackbar("Image Upload", "Failed to upload image");
    }
  }
}
