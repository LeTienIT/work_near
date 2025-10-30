import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_event.dart';
import 'package:work_near/features/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}
class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  final _form = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool hidePass = true;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );

    _controller.forward();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state){
          if(state is AuthLoading){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade50, Colors.green]
                  ),
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)]
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Đăng nhập",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 3
                                )
                              ]
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              label: Text('Email'),
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: pass,
                          textInputAction: TextInputAction.next,
                          obscureText: hidePass,
                          decoration: InputDecoration(
                              label: Text("Mật khẩu"),
                              prefixIcon: Icon(Icons.password_outlined),
                              suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },
                                  icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility)
                              ),
                              border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton.icon(
                          onPressed: (){
                            if(_form.currentState!.validate()){
                              context.read<AuthBloc>().add(LoginRequested(email.text, pass.text));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4
                          ),
                          label: Text("Đăng nhập"),
                          icon: Icon(Icons.login),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                context.go('/register');
                              },
                              icon: Icon(Icons.app_registration_outlined, size: 18),
                              label: Text("Đăng ký"),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black, // màu chữ & icon
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.lock_reset, size: 18),
                              label: Text("Quên mật khẩu"),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state){
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message, style: TextStyle(color: Colors.red),)),
            );
          } else if (state is AuthAuthenticated) {
            context.go('/home');
          }
        }
    );
  }

}