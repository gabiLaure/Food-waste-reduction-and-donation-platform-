import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key, this.text = ""}) : super(key: key);
  /*super.key, 
      this.text = "Loading"});*/

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                color: Colors.indigo,
              ),
              Text(
                'loading',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
    );
  }
}
