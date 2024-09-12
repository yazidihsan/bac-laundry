import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(
      {Key? key, required this.onTap, required this.title, required this.icon})
      : super(key: key);

  final VoidCallback onTap;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      // clipBehavior is necessary because, without it, the InkWell's animation
      // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
      // This comes with a small performance cost, and you should not set [clipBehavior]
      // unless you need it.
      color: ColorManager.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: ColorManager.primary,
        onTap: onTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Center(
                  child: Text(
                '${title.toString()}',
                style: TextStyle(color: Colors.white),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
