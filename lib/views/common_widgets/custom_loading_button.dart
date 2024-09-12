import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: ColorManager.primary,
    );
  }
}
