import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/text_styles.dart';

class DashboardWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final String? imgPath;
  const DashboardWidget({
    super.key,
    this.onPressed,this.title,this.imgPath
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: defaultPadding-2),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(defaultRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: defaultSpreadRadius,
              blurRadius: defaultBlurRadius,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imgPath!,fit: BoxFit.cover,height: 35,width: 35,),
            const SizedBox(height: 3,),
            Text(title!,style: boldTextStyle(),)
          ],
        ),
      ),
    );
  }
}

