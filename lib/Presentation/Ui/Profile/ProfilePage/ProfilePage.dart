import 'package:chat_app/Bloc/UserBloc/user_bloc.dart';
import 'package:chat_app/Bloc/UserBloc/user_event.dart';
import 'package:chat_app/Bloc/UserBloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  bool isEditMode = false;
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserData());
    nameController = TextEditingController();
    numberController = TextEditingController();
    bioController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditMode) {
                _onSavePressed(context);
              } else {
                setState(() => isEditMode = true);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.currentUserStream == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder(
            stream: state.currentUserStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final user = snapshot.data!;

              nameController.text = user.name;
              numberController.text = user.number;
              bioController.text = user.bio ?? '';

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        context.read<UserBloc>().add(
                     PickAndUploadProfileImage(source: ImageSource.gallery)
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(user.profilePic),
                          ),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildField("Name", nameController, enabled: isEditMode),
                    _buildField("Phone", numberController, enabled: isEditMode),
                    _buildField("Bio", bioController, enabled: isEditMode, maxLines: 3),

                    const SizedBox(height: 20),
                    Text(
                      user.email,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {bool enabled = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey.shade200,
        ),
      ),
    );
  }

  void _onSavePressed(BuildContext context) {
    final bloc = context.read<UserBloc>();
    final currentUser = bloc.state.currentUser;

    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: nameController.text,
        number: numberController.text,
        bio: bioController.text,
      );

    bloc.add(UpdateUser(userModel: updatedUser));
    }

    setState(() => isEditMode = false);
  }
}
