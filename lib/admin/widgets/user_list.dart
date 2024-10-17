import 'package:flutter/material.dart';
import '../models/user.dart';

class UserList extends StatelessWidget {
  final List<User> users;

  UserList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(users[index].name),
          subtitle: Text(users[index].email),
        );
      },
    );
  }
}
