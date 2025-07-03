import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Adduser extends UserEvent {
  final UserModel usermodel;
  const Adduser({required this.usermodel});

  @override
  List<Object?> get props => [usermodel];
}

class UpdateUser extends UserEvent {
  final UserModel usermodel;
  const UpdateUser({required this.usermodel});

  @override
  List<Object?> get props => [usermodel];
}

class UploadProfileImage extends UserEvent {
  final String Profilepic;
  const UploadProfileImage({required this.Profilepic});

  @override
  List<Object?> get props => [Profilepic];
}

class GetAllUsers extends UserEvent {}

class PickAndCropProfileImage extends UserEvent {
  final ImageSource source;
  const PickAndCropProfileImage({required this.source});

  @override
  List<Object?> get props => [source];
}
