import 'package:chat_app/Bloc/AuthBloc/auth_bloc.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Bloc/UserBloc/user_bloc.dart';
import 'package:chat_app/Bloc/UserBloc/user_event.dart';
import 'package:chat_app/Bloc/UserBloc/user_state.dart';
import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/CommonButton.dart';
import 'package:chat_app/Presentation/Widgets/ProfilePicWidget/ProfilePicWidget.dart';
import 'package:chat_app/Presentation/Widgets/TextInputWidget/TextInputWidget.dart';
import 'package:chat_app/Utils/Constants/AppFonts/AppFonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController biocon = TextEditingController();
 bool iseditmode=false;
  @override
  void initState() {
    super.initState();
    final user = context.read<UserBloc>().state.currentUser;
    if (user != null) {
      namecontroller.text = user.name;
      mobilecontroller.text = user.number;
      biocon.text = user.bio;
      emailcontroller.text = FirebaseAuth.instance.currentUser?.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle: AppFonts.headingSmall,
          title: Text("My Profile"),
        ),
    body:
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(!iseditmode)
              IgnorePointer(child: const ProfileImagePicker()),
              if(iseditmode)
                ProfileImagePicker(),
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
enabled: iseditmode,
                                label: "Name",
                                hintText: "",
                                controller: namecontroller,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              Gap(Get.height * 0.02),
                              InputFields(
                                enabled: iseditmode,
                                label: "Mobile Number",
                                hintText: "",
                                controller: mobilecontroller,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Mobile Number is required';
                                  }
                                  return null;
                                },
                              ),
                              Gap(Get.height * 0.02),
                              InputFields(
                                enabled: iseditmode,
                                label: "Bio",
                                hintText: "Tell us Something About You",
                                controller: biocon,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Bio is required';
                                  }
                                  return null;
                                },
                              ),
                              Gap(Get.height * 0.03),
                              CustomButton(
                                title: iseditmode ? "Save Profile" : "Edit Profile",
                                ontap: () {
                                  if(iseditmode){
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      if (auth.currentUser != null) {
                                        User currentuser = auth.currentUser!;
                                        String email = currentuser.email!;
                                        String uid = currentuser.uid;
                                        context.read<UserBloc>().add(
                                          UpdateUser(
                                            userModel: UserModel(
                                              name: namecontroller.text.trim(),
                                              profilePic: state.profileImageUrl!,
                                              uid: uid,
                                              email: email,
                                              number: mobilecontroller.text.trim(),
                                              bio: biocon.text.trim(),
                                            ),
                                          ),
                                        );

                                      }
                                      iseditmode=!iseditmode;
                                      setState(() {
                                      });
                                    }

                                  }
                                  else{
                                    iseditmode=!iseditmode;
                                    setState(() {
                                    });
                                  }
                                },
                                isloading: state.isLoading,
                              ),
                              Gap(Get.height * 0.025),
                              CustomButton(
                                title: "Log Out",
                                ontap: () {
                                  context.read<AuthBloc>().add(Logout());
                                },
                                isloading: state.isLoading,
                              ),
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
      ));
  }
}
