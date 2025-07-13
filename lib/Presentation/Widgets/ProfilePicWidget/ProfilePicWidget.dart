import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Bloc/UserBloc/user_bloc.dart';
import '../../../../Bloc/UserBloc/user_event.dart';
import '../../../../Bloc/UserBloc/user_state.dart';

class ProfileImagePicker extends StatelessWidget {
  final bool? iseditmode;
  const ProfileImagePicker({super.key,this.iseditmode});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        ImageProvider imageProvider;
        if (state.localProfileImagePath != null &&
            state.localProfileImagePath!.isNotEmpty) {
          imageProvider = FileImage(File(state.localProfileImagePath!));
        } else if (state.profileImageUrl != null) {
          imageProvider = NetworkImage(state.profileImageUrl!);
        } else {
          imageProvider = const AssetImage("assets/Images/user.png");
        }
        return GestureDetector(
          onTap: () {
            context.read<UserBloc>().add(
              PickAndUploadProfileImage(source: ImageSource.gallery),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: Get.width * 0.18,
                backgroundColor: state.localProfileImagePath != null
                    ? Colors.grey
                    : Colors.blue,
                backgroundImage: imageProvider,
              ),
              if (state.isUploadingProfileImage)
                Container(
                  width: Get.width * 0.36,
                  height: Get.width * 0.36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  ),
                ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
