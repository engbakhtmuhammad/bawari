import 'package:bawari/utils/colors.dart';
import 'package:bawari/view/Expense/expense.dart';
import 'package:bawari/view/dashboard/dashboard.dart';
import 'package:bawari/view/dues/dues.dart';
import 'package:bawari/view/loan/loan_info.dart';
import 'package:bawari/view/purchase/purchase_info.dart';
import 'package:bawari/view/sell/sale.dart';
import 'package:bawari/view/sell/sale_info.dart';
import 'package:bawari/view/stock/stock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'constants.dart';
import 'text_styles.dart';

int autoBillNo = 1;

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
        const Icon(Icons.error_outline),
        const SizedBox(
          height: 16,
        ),
        Text(text ?? "somethingWentWrong", style: primaryTextStyle()),
      ],
    ),
  );
}

Widget drawerWidget() {
  return Drawer(
    child: Column(
      children: [
        Container(
          height: 80,
          width: double.infinity,
          color: primaryColor,
          child: Center(
            child: Text(
              "Logo Here",
              style: boldTextStyle(size: 24, color: whiteColor),
            ),
          ),
        ),
        ListTile(
            trailing: Image.asset(
              "assets/icons/cortons.png",
              width: 35,
              height: 35,
            ),
            title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "گودام سٹاک",
                  style: boldTextStyle(),
                )),
            onTap: () {
              Get.back();
              Get.to(StockScreen());
            }),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/recieve.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "پہ خلکو باندے",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(DueScreen());
          },
        ),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/expense.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "ده خرچے معلومات",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(ExpenseInfoScreen());
          },
        ),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/profits.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "منافع / بچت",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(SellScreen());
          },
        ),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/discount.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "خریداری معلومات",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(PurchaseInfoScreen());
          },
        ),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/sell_info.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "فروخت معلومات",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(SaleInfoScreen());
          },
        ),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/budget.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "نقد ريو معلومات",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(SellScreen());
          },
        ),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/search.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "پور معلومات",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(LoanInfoScreen());
          },
        ),
        const Divider(),
        ListTile(
          trailing: Image.asset(
            "assets/icons/purchase.png",
            width: 35,
            height: 35,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "اصلي ډشبورډ",
                style: boldTextStyle(),
              )),
          onTap: () {
            Get.back();
            Get.to(DashboardScrreen());
          },
        ),
        const Divider(),
      ],
    ),
  );
}

PreferredSizeWidget appBarWidget(
    {String? title,
    VoidCallback? onPressed,
    VoidCallback? openDrawer,
    bool? isDashboard = false}) {
  return AppBar(
      title: Text(
        title!,
        style: boldTextStyle(),
      ),
      centerTitle: true,
      backgroundColor: primaryColor,
      leading: IconButton(
          onPressed: openDrawer,
          icon: Image.asset(
            "assets/icons/menu.png",
            width: 24,
          )),
      actions: [
        IconButton(
            onPressed: () => isDashboard!
                ? showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'ایا تاسو ډاډه یاست چې بهر شئ؟',
                          textAlign: TextAlign.right,
                          style: boldTextStyle(size: 24),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // User does not want to exit
                            },
                            child: Text('نه',
                                style: boldTextStyle(color: primaryColor)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // User wants to exit
                            },
                            child: Text('هو',
                                style: boldTextStyle(color: primaryColor)),
                          ),
                        ],
                      );
                    },
                  )
                : Get.to(DashboardScrreen()),
            icon: Image.asset(
              "assets/icons/back.png",
              width: 24,
            )),
      ]);
}

alertDialog({required String title,VoidCallback? onPressed}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: boldTextStyle(size: 24),
        ),
        actions: <Widget>[
          TextButton(
            onPressed:()=> Get.back(),
            child: Text('نه', style: boldTextStyle(color: primaryColor)),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text('هو', style: boldTextStyle(color: primaryColor)),
          ),
        ],
      );
    },
  );
}

Widget backContainerWidget({required Widget child}) {
  return Container(
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
    child: child,
  );
}

Container billAndDateWidget(
    {TextEditingController? billController,
    TextEditingController? dateController,
    String? imgPath,
    String? imgPath2,
    String? title,
    String? title2,
    VoidCallback? onPressed,
    VoidCallback? onPressed2,
    TextInputType? inputType,
    TextInputType? inputType2}) {
  return Container(
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(defaultRadius),
          bottomRight: Radius.circular(defaultRadius)),
      color: primaryColor,
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(defaultRadius * 2),
            ),
            child: TextField(
              keyboardType: inputType ?? TextInputType.number,
              controller: billController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                suffixIcon: SizedBox(
                  width: 100,
                  child: GestureDetector(
                    onTap: onPressed ?? () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(title ?? "بل نمبر"),
                        const SizedBox(
                          width: 3,
                        ),
                        Image.asset(
                          imgPath ?? "assets/icons/invoice.png",
                          width: defaultIconsSize,
                          height: defaultIconsSize,
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultRadius * 2),
                ),
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(defaultRadius * 2),
            ),
            child: TextField(
              keyboardType: inputType2 ?? TextInputType.datetime,
              controller: dateController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                suffixIcon: SizedBox(
                  width: 100,
                  child: GestureDetector(
                    onTap: onPressed2 ?? () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(title2 ?? "تاريخ"),
                        const SizedBox(
                          width: 3,
                        ),
                        Image.asset(
                          imgPath ?? "assets/icons/calendar.png",
                          width: defaultIconsSize,
                          height: defaultIconsSize,
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultRadius * 2),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget textFieldWidget(
    {TextEditingController? controller,
    required String label,
    required String imgPath,
    bool? isSearch = false,
    TextInputType? inputType,
    Function(String)? onChange,
    VoidCallback? onPressed,
    String? prefixText,
    bool? isReadOnly,
    int? maxLine}) {
  return Padding(
    padding:
        EdgeInsets.symmetric(vertical: isSearch! ? 0 : defaultPadding / 2.5),
    child: TextField(
      readOnly: isReadOnly??false,
      controller: controller,
      onChanged: onChange ?? (value) {},
      textAlign: TextAlign.right,
      maxLines: maxLine ?? 1,
      keyboardType: inputType ?? TextInputType.text,
      decoration: InputDecoration(
        suffixIcon: isSearch
            ? const Icon(Icons.search)
            : GestureDetector(
                onTap: onPressed ?? () {},
                child: Image.asset(
                  imgPath,
                  width: defaultIconsSize,
                  height: defaultIconsSize,
                ),
              ),
        prefix: Text(prefixText ?? ''),
        hintText: label,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
      ),
    ),
  );
}

Widget dropDownTextFieldWidget({
  required String label,
  required String imgPath,
  required List<DropdownMenuItem<String>> dropDownList,
  Function(String)? onChanged, // Pass a callback function
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: defaultPadding / 2.5),
    child: DropdownButtonFormField(
      alignment: Alignment.centerRight,
      decoration: InputDecoration(
        suffixIcon: Image.asset(
          imgPath,
          width: defaultIconsSize,
          height: defaultIconsSize,
        ),
        alignLabelWithHint: true,
        hintText: label,
        // hintTextDirection: TextDirection.rtl,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
      ),
      items: dropDownList,
      onChanged: (Object? value) {
        // Call the callback function with the selected value
        onChanged!(value.toString());
      },
    ),
  );
}

void log(Object? value) {
  if (!kReleaseMode || forceEnableDebug) print(value);
}

Widget loaderWidget(bool isLoad) {
  return isLoad
      ? const Center(child: CircularProgressIndicator())
      : const SizedBox();
}

Future<bool?> selectDate(TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null && picked != controller) {
    controller.text = intl.DateFormat('dd MMM yyyy').format(picked);
  }
  return true;
}
