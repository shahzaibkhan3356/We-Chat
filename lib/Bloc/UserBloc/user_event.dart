import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

// 🔹 Create a user
class AddUser extends UserEvent {
  final UserModel userModel;
  const AddUser({required this.userModel});
  @override
  List<Object?> get props => [userModel];
}

// 🔹 Update user info (can include new profilePic url)
class UpdateUser extends UserEvent {
  final UserModel userModel;
  const UpdateUser({required this.userModel});
  @override
  List<Object?> get props => [userModel];
}

class PickAndUploadProfileImage extends UserEvent {
  final ImageSource source;
  const PickAndUploadProfileImage({required this.source});

  @override
  List<Object?> get props => [source];
}

// 🔹 Upload picked image to Firebase
class UploadProfileImage extends UserEvent {
  final String imagePath; // local file path to upload
  const UploadProfileImage({required this.imagePath});
  @override
  List<Object?> get props => [imagePath];
}

// 🔹 Fetch all users
class GetAllUsers extends UserEvent {}
