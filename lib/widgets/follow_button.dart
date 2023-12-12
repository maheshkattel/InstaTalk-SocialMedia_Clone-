import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  const FollowButton(
      {Key? key,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        height: 33,
        width: 220,
        child: Center(
          child: Text(text,
              style: buildPoppinsTextStyle()
                  .copyWith(color: textColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// TextStyle(
// color: textColor,
// fontWeight: FontWeight.bold,
// ),
