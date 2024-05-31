import 'package:flutter/material.dart';

class NotificationDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {},
          icon: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        )
      ],
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: Row(children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        SizedBox(
          width: 12,
        ),
        CircleAvatar(
          backgroundImage: AssetImage("assets/pp.jpeg"),
          maxRadius: 20,
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Laury',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(
                width: 12,
              ),
              Text('Active',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                  )),
            ],
          ),
        )
      ]),
    );
  }

//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => throw UnimplementedError();
// }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
