
import 'package:bawari/utils/constants.dart';
import 'package:bawari/view/Expense/expense.dart';
import 'package:bawari/view/credit/credit.dart';
import 'package:bawari/view/customer/customer.dart';
import 'package:bawari/view/dues/dues.dart';
import 'package:bawari/view/goods/goods.dart';
import 'package:bawari/view/loan/on_people_Loan.dart';
import 'package:bawari/view/purchase/purchase.dart';
import 'package:bawari/view/sell/sale.dart';
import 'package:bawari/view/stock/stock.dart';
import 'package:bawari/view/widgets/dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/common.dart';

class DashboardScrreen extends StatelessWidget {
  const DashboardScrreen({super.key});
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(title: "باوری زراعتی شرکت",isDashboard: true,openDrawer: () => scaffoldKey.currentState?.openDrawer(),),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(defaultHorizontalPadding),
          child:  Column(
            children: [
              DashboardWidget(title: "سامان خرید",imgPath: "assets/icons/purchase.png",onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseScreen())),),
              DashboardWidget(title: "سامان فروخت",imgPath: "assets/icons/sell.png",onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>SellScreen())),),
              DashboardWidget(title: "گودام سٹاک",imgPath: "assets/icons/cortons.png",onPressed: () => Get.to(StockScreen())),
              DashboardWidget(title: "ورباندی کهاته",imgPath: "assets/icons/recieve.png",onPressed: () => Get.to(CreditScreen())),
              DashboardWidget(title: "دوا نوم",imgPath: "assets/icons/bag.png",onPressed: ()=>Get.to(GoodsScreen()),),
              DashboardWidget(title: "لوی گراک نوم",imgPath: "assets/icons/customer.png",onPressed: () => Get.to(CustomerScreen()),),
              DashboardWidget(title: "خرچہ",imgPath: "assets/icons/expense.png",onPressed: () => Get.to(ExpenseInfoScreen()),),
              DashboardWidget(title: "را باندی",imgPath: "assets/icons/dues.png",onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DueScreen())),),
            ],
          ),
        ),
      ),
    );
  }
}

