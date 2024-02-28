

import 'package:flutter/material.dart';

import 'text_styles.dart';


Widget emptyWidget({String? text}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("no_data", height: 100, width: 100),
        Text(text ?? "noDataFound", style: primaryTextStyle()),
      ],
    ),
  );
}

Widget errorWidget({String? text}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline),
        SizedBox(height: 16,),
        Text(text ?? "somethingWentWrong", style: primaryTextStyle()),
      ],
    ),
  );
}

// Widget loaderWidget() {
//   return Center(child: Lottie.asset(loader, height: 60, width: 60));
// }

