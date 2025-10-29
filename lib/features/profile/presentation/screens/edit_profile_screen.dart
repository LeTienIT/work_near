import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_state.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_event.dart';
import 'package:work_near/features/profile/presentation/bloc/profile_state.dart';

class EditProfileScreen extends StatefulWidget{
  const EditProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditProfileScreen();
  }
}

class _EditProfileScreen extends State<EditProfileScreen>{
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if(authState is AuthAuthenticated){
      final params = GetProfileParams(authState.user.uid, authState.user.email);
      context.read<ProfileBloc>().add(LoadUserProfile(params));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật hồ sơ'),centerTitle: true,),
      body: BlocConsumer<ProfileBloc, ProfileState>(
          builder: (context, state){
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }

            if (state is ProfileLoaded || state is ProfileUpdated){
              final profile = state is ProfileLoaded ? state.userProfile : (state as ProfileUpdated).updatedProfile;

              _nameCtrl.text = profile.name ?? '';
              _phoneCtrl.text = profile.phone ?? '';
              _skillsCtrl.text = profile.skills?.join(', ') ?? '';

              return Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Họ và tên',
                            border: OutlineInputBorder()
                        ),
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return "Tên không được để trống";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Số điện thoại',
                            border: OutlineInputBorder()
                        ),
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return "SĐT không được để trống";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _skillsCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Kỹ năng (ngăn cách bằng dấu phẩy)',
                            border: OutlineInputBorder()
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){

                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Lưu thay đổi'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Không có dữ liệu hồ sơ'));
          },
          listener: (context, state){

          }
      ),
    );
  }
}