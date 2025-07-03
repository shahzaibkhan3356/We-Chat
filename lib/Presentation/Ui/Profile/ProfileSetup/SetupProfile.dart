import 'dart:io';

import 'package:chat_app/Bloc/UserBloc/user_bloc.dart';
import 'package:chat_app/Bloc/UserBloc/user_event.dart';
import 'package:chat_app/Bloc/UserBloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Utils/Constants/AppColors/appfonts.dart';
import '../../../Widgets/Container/GlassContainer.dart';
import '../../../Widgets/TextInputWidget/TextInputWidget.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: GlassContainer(
            height: Get.height * 0.8,
            width: Get.width * 0.85,
            child: SingleChildScrollView(
              child: BlocBuilder<Userbloc, UserState>(
                builder: (context, state) {
                  final showLoading = state.isUploadingProfilePic;
                  final avatarImage = state.localProfilePicPath != null
                      ? FileImage(File(state.localProfilePicPath!))
                      : (state.profilepic.isNotEmpty
                            ? NetworkImage(state.profilepic)
                            : const AssetImage("assets/Images/user.png")
                                  as ImageProvider);
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey[800],
                                backgroundImage: avatarImage,
                              ),
                              if (showLoading)
                                const SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                context.read<Userbloc>().add(
                                  PickAndCropProfileImage(
                                    source: ImageSource.gallery,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      AuthTextField(
                        label: "Your Name",
                        hintText: "Enter your full name",
                        controller: TextEditingController(),
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Name is required";
                          return null;
                        },
                        focusNode: FocusNode(),
                      ),
                      const SizedBox(height: 20),

                      AuthTextField(
                        focusNode: FocusNode(),
                        label: "Mobile Number",
                        hintText: "Enter your mobile number",
                        controller: TextEditingController(),
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Mobile number is required";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      AuthTextField(
                        focusNode: FocusNode(),
                        label: "Bio",
                        hintText: "Tell us something about yourself",
                        controller: TextEditingController(),
                        keyboardType: TextInputType.multiline,
                        prefixIcon: Icons.info_outline,
                        validator: (value) => null,
                      ),
                      const SizedBox(height: 30),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
