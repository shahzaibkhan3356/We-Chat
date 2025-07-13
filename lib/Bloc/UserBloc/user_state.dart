import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final String errorMessage;
  final List<UserModel> allUsers;
  final UserModel? currentUser;
  final Stream<UserModel?>? currentUserStream;

  final String? profileImageUrl;        // Final uploaded image URL from Firebase
  final String? localProfileImagePath;  // Temporary image file path for UI preview

  final bool isLoading;
  final bool isUploadingProfileImage;

  const UserState({
    this.errorMessage = '',
    this.allUsers = const [],
    this.currentUser,
    this.profileImageUrl,
    this.currentUserStream,

    this.localProfileImagePath,
    this.isLoading = false,
    this.isUploadingProfileImage = false,
  });

  UserState copyWith({
    String? errorMessage,
    List<UserModel>? allUsers,
    UserModel? currentUser,
    String? profileImageUrl,
    String? localProfileImagePath,
     Stream<UserModel?>? currentUserStream,
    bool? isLoading,
    bool? isUploadingProfileImage,
  }) {
    return UserState(
      errorMessage: errorMessage ?? this.errorMessage,
      allUsers: allUsers ?? this.allUsers,
      currentUserStream: currentUserStream ?? this.currentUserStream,
      currentUser: currentUser ?? this.currentUser,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      localProfileImagePath: localProfileImagePath ?? this.localProfileImagePath,
      isLoading: isLoading ?? this.isLoading,
      isUploadingProfileImage: isUploadingProfileImage ?? this.isUploadingProfileImage,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    allUsers,
    currentUser,
    profileImageUrl,
    localProfileImagePath,
    isLoading,
    isUploadingProfileImage,
    currentUserStream
  ];
}
