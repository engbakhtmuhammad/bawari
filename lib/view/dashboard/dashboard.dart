import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/constants.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/dashboard_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/common.dart';

class DashboardScrreen extends StatelessWidget {
  const DashboardScrreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context: context,title: "باوری زراعتی شرکت"),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(defaultHorizontalPadding),
          child: const Column(
            children: [
              DashboardWidget(title: "سامان خرید",imgPath: "assets/icons/sell.png",),
              DashboardWidget(title: "سامان فروخت",imgPath: "assets/icons/purchase.png",),
              DashboardWidget(title: "ورباندی کهاته",imgPath: "assets/icons/invoice.png",),
              DashboardWidget(title: "دوا لوم",imgPath: "assets/icons/bag.png",),
              DashboardWidget(title: "لوی گراک نوم",imgPath: "assets/icons/customer.png",),
              DashboardWidget(title: "خرچہ",imgPath: "assets/icons/expense.png",),
              DashboardWidget(title: "را باندی",imgPath: "assets/icons/dues.png",),
            ],
          ),
        ),
      ),
    );
  }
}

