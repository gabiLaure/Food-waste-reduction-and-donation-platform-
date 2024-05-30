import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color color;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    required this.textColor,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
          child: MaterialButton(
            minWidth: 250,
            onPressed: onClicked,
            child: Container(
              alignment: Alignment.center,
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0)
                      .copyWith(color: textColor, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
}
