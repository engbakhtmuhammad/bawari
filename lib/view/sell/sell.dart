import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';
import '../widgets/sell_container.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "سامان فروخت"),
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
          const SellContainerWidget(btnTitle: "نقد وصولي",bill: 400,cortonCount: 2,remaining: 3,)
        ],
      ),
    );
  }
}

