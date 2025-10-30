import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_near/core/presentation/widgets/app_drawer.dart';
import 'package:work_near/core/usecase/usecase.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_state.dart';
import 'package:work_near/features/profile/domain/entities/user_profile_entity.dart';
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
  List<String> skills = [];

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
      drawer: Drawer(child: AppDrawer(),),
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
              final dataSkills = profile.skills?.join(', ') ?? '';
              // CHỈ cập nhật 1 lần, nếu đang rỗng
              if (skills.isEmpty && (profile.skills?.isNotEmpty ?? false)) {
                skills = List<String>.from(profile.skills!);
              }
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
                        decoration: InputDecoration(
                            labelText: 'Ví dụ: Sửa xe, Nấu ăn, ...',
                            suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    skills.addAll(_skillsCtrl.text.split(',').map((e)=>e.trim()).where((e)=>e.isNotEmpty).toList());
                                    _skillsCtrl.clear();
                                  });
                                },
                                icon: Icon(Icons.add_box)
                            ),
                            border: OutlineInputBorder()
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,        // khoảng cách ngang giữa các chip
                        runSpacing: 8,     // khoảng cách dọc giữa các hàng chip
                        children: skills.map((s) {
                          return Chip(
                            key: ValueKey(s),
                            label: Text(
                              s,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            deleteIcon: const Icon(
                              Icons.clear,  // Hoặc Icons.close
                              color: Colors.red,
                              size: 18,  // Tùy chỉnh size nếu cần
                            ),
                            // QUAN TRỌNG: Thêm onDeleted để icon hiển thị và xử lý xóa
                            onDeleted: () {
                              setState(() {
                                skills.remove(s);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            final authState = context.read<AuthBloc>().state;
                            if(authState is AuthAuthenticated){
                              final entity = UserProfileEntity(
                                  uid: authState.user.uid,
                                  email: authState.user.email,
                                  name: _nameCtrl.text,
                                  phone: _phoneCtrl.text,
                                  avatarUrl: '',
                                  skills: skills
                              );

                              context.read<ProfileBloc>().add(UpdateUserProfile(entity));
                            }
                            
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
            if(state is ProfileUpdated){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Cập nhật thành công", style: TextStyle(color: Colors.green),))
              );
            }
          }
      ),
    );
  }
}