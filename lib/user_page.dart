import 'package:flutter/material.dart';

import 'model/user.dart';

class UserPage extends StatelessWidget {
  final List<User> userList;

  const UserPage({super.key, required this.userList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data User')),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return Card(
            child: ListTile(
              title: Text(user.nama),
              subtitle: Text('${user.email} | Role: ${user.role}'),
              leading: Text(user.id),
            ),
          );
        },
      ),
    );
  }
}
