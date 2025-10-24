import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends State<RegisterScreen> with SingleTickerProviderStateMixin{
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  final passRepeat = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool hidePass = true, hidePassRepeat = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
          child: SlideTransition(
            position: _slideAnimation,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Đăng ký",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                       Shadow(
                         color: Colors.black,
                         offset: Offset(2, 2),
                         blurRadius: 2
                       )
                      ]
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder()
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Email không hợp lệ";
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: pass,
                    obscureText: hidePass,
                    decoration: InputDecoration(
                      label: Text("Mật khẩu"),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              hidePass = ! hidePass;
                            });
                          },
                          icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility)
                      )
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Mật khẩu không hợp lệ";
                      }
                      else{
                        if(value.length <= 6){
                          return "Mật khẩu phải có ít nhất 6 ký tự";
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: passRepeat,
                    obscureText: hidePassRepeat,
                    decoration: InputDecoration(
                        label: Text("Xác nhận lại mật khẩu"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.password_outlined),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                hidePassRepeat = !hidePassRepeat;
                              });
                            },
                            icon: Icon(hidePassRepeat ? Icons.visibility_off: Icons.visibility)
                        )
                    ),
                    validator: (value){
                      if( value==null || value.isEmpty){
                        return "Yêu cầu xác nhận lại mật khẩu";
                      }
                      else{
                        if(value != pass.text){
                          return "Xác nhận mật khẩu không chính xác";
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton.icon(
                    onPressed: (){
                      if(formKey.currentState!.validate()){

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12)
                      )
                    ),
                    label: Text("Đăng ký"),
                    icon: Icon(Icons.add_box),
                  ),
                  SizedBox(height: 10,),
                  TextButton.icon(
                      onPressed: (){

                      },
                      label: Text("Đã có tài khoản, đăng nhập"),
                      icon: Icon(Icons.login),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}