
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/text_styles.dart';

class SellContainerWidget extends StatelessWidget {
  final int? cortonCount;
  final int? bill;
  final int? remaining;
  final bool? isBaqaya;
  const SellContainerWidget(
      {super.key, this.bill, this.cortonCount, this.remaining,this.isBaqaya});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultRadius),
        color: primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                cortonCount.toString(),
                style: primaryTextStyle(color: whiteColor),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      isBaqaya!?"سابقا بقايا": "کارٹن تعداد",
                      style: boldTextStyle(color: whiteColor),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                bill.toString(),
                style: primaryTextStyle(color: whiteColor),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      isBaqaya!?"بل بقايا":"ٹوٹل بل",
                      style: boldTextStyle(color: whiteColor),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                remaining.toString(),
                style: primaryTextStyle(color: whiteColor),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      isBaqaya!?"توتل":"بقايا",
                      style: boldTextStyle(color: whiteColor),
                    ),
                  )),
              
            ],
          ),
        ],
      ),
    );
  }
}
