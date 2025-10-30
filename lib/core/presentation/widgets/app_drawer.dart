import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Menu", style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.center,),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () {
              context.pop(context);
              context.go('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Hồ sơ của tôi'),
            onTap: () {
              context.pop(context);
              context.go('/profile');
            },
          ),
        ],
      ),
    );
  }
}