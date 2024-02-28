import 'dart:math';

import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "سامان خرید"),
      drawer: drawerWidget(context),
      body: Column(
        children: [
          billAndDateWidget(),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(defaultHorizontalPadding),
            padding: EdgeInsets.all(defaultPadding),
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
              children: [
                textFieldWidget(label: "نام", imgPath: "assets/icons/name.png"),
                textFieldWidget(label: "نوٹ", imgPath: "assets/icons/note.png",maxLine: 4),
                textFieldWidget(
                    label: "سامان نمبر", imgPath: "assets/icons/number.png"),
                textFieldWidget(
                    label: "جمله تعداد", imgPath: "assets/icons/total.png"),
                textFieldWidget(
                    label: "قیمت", imgPath: "assets/icons/price.png"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CustomButton(
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
            width: double.infinity,
            color: secondaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("ٹوٹل بل",style: primaryTextStyle(color: whiteColor),),
                Text("کارٹن تعداد",style: primaryTextStyle(color: whiteColor),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
