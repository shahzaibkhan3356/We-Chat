import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/CommonButton.dart';
import 'package:chat_app/Presentation/Widgets/TextInputWidget/TextInputWidget.dart';
import 'package:chat_app/Utils/Constants/AppFonts/AppFonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Bloc/UserBloc/user_bloc.dart';
import '../../../../Bloc/UserBloc/user_event.dart';
import '../../../../Bloc/UserBloc/user_state.dart';
import '../../../Widgets/ProfilePicWidget/ProfilePicWidget.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mobcon = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController biocon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: AppFonts.headingLarge,
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileImagePicker(),
              Gap(Get.height * 0.01),
              Text(
                "Upload Profile Picture",
                style: AppFonts.headingSmall.copyWith(fontSize: 17),
              ),
              Gap(Get.height * 0.02),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: _formKey,
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              InputFields(
                                label: "Name",
                                hintText: "Enter Your Name",
                                controller: namecontroller,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                },
                              ),
                              Gap(Get.height * 0.02),
                              InputFields(
                                label: "Mobile Number",
                                hintText: "Enter Your Mobile Number",
                                controller: mobcon,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Mobile Number is required';
                                  }
                                },
                              ),
                              Gap(Get.height * 0.02),
                              InputFields(
                                label: "Bio",
                                hintText: "Tell us Something About You",
                                controller: biocon,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Bio is required';
                                  }
                                },
                              ),
                              Gap(Get.height * 0.03),
                              CustomButton(
                                title: "Continue",
                                ontap: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    if (auth.currentUser != null) {
                                      User currentuser = auth.currentUser!;
                                      String email = currentuser.email!;
                                      String uid = currentuser.uid;
                                      context.read<UserBloc>().add(
                                        AddUser(
                                          userModel: UserModel(
                                            profilePic: state.profileImageUrl!,
                                            uid: uid,
                                            email: email,
                                            number: mobcon.text.trim(),
                                            bio: biocon.text.trim(),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                isloading: state.isLoading,
                              ),
                              Gap(Get.height * 0.025),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
