import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_near/core/presentation/widgets/app_drawer.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/job_entity.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../bloc/job_state.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _locationDetailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Job'), centerTitle: true,),
      drawer: Drawer(child: AppDrawer(),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<JobBloc, JobState>(
          listener: (context, state) {
            if (state is JobAddedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đăng job thành công!')),
              );
            } else if (state is JobError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is JobLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.star_rate_rounded, color: Colors.red,)
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Không được để trống";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.star_rate_rounded, color: Colors.red,)
                    ),
                    maxLines: 3,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Không được để trống";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Chi phí',
                        border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Địa điểm',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.star_rate_rounded, color: Colors.red,)
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Không được để trống";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationDetailCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Chi tiết địa điểm',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.star_rate_rounded, color: Colors.red,)
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Không được để trống";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        final authState = context.read<AuthBloc>().state;
                        if(authState is AuthAuthenticated){
                          final job = JobEntity(
                            ownerId: authState.user.uid,
                            title: _titleCtrl.text,
                            description: _descCtrl.text,
                            price: double.tryParse(_priceCtrl.text),
                            // location: _locationCtrl.text,
                            applicants: [],
                            deadline: DateTime.now().add(const Duration(days: 7)),
                            status: 'open',
                          );
                          context.read<JobBloc>().add(AddJobEvent(job));
                        }
                      }
                    },
                    child: const Text('Đăng Job'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
