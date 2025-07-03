import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final String errorMessage;
  final List<UserModel> allUsers;
  final UserModel? currentUser;
  final String profilepic;
  final bool isLoading;
  final bool isUploadingProfilePic;
  final String? localProfilePicPath;

  const UserState({
    this.errorMessage = '',
    this.allUsers = const [],
    this.currentUser,
    this.isLoading = false,
    this.profilepic = '',
    this.isUploadingProfilePic = false,
    this.localProfilePicPath,
  });

  UserState copyWith({
    String? errorMessage,
    String? profilepic,
    List<UserModel>? allUsers,
    UserModel? currentUser,
    bool? isLoading,
    bool? isUploadingProfilePic,
    String? localProfilePicPath,
  }) {
    return UserState(
      errorMessage: errorMessage ?? this.errorMessage,
      allUsers: allUsers ?? this.allUsers,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      profilepic: profilepic ?? this.profilepic,
      isUploadingProfilePic:
          isUploadingProfilePic ?? this.isUploadingProfilePic,
      localProfilePicPath: localProfilePicPath ?? this.localProfilePicPath,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    allUsers,
    currentUser,
    profilepic,
    isLoading,
    isUploadingProfilePic,
    localProfilePicPath,
  ];
}
