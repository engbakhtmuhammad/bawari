import 'package:bawari/controller/customer_controller.dart';
import 'package:bawari/model/dues_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class AddDueScreen extends StatefulWidget {
  const AddDueScreen({super.key});

  @override
  State<AddDueScreen> createState() => _AddDueScreenState();
}

class _AddDueScreenState extends State<AddDueScreen> {
  DuesController duesController = Get.put(DuesController());
  CustomerController customerController = Get.put(CustomerController());
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "پیس تعداد",
    "کارتن تعداد",
    "في كارتن تعداد",
    "مکمل تعداد",
    "في تعدادقيمت",
  ];
  List<List<String>> tableRows = [
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
  ];
  List<DropdownMenuItem<String>> dropDownList = [];

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchCustomers();
  });
}


// Inside a method where you fetch customers, such as in the initState method
  void fetchCustomers() async {
    List<String?> customerNames = await customerController.getCustomerNames();
    print('Customer Names: $customerNames');

    // Update the dropDownList based on the fetched customer names
    dropDownList = customerNames.map((customerName) {
      return DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: customerName,
        child: Text(customerName!),
      );
    }).toList();
    print(dropDownList.length);

    // Ensure to update the state to reflect changes in the UI
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchCustomers();
    return Scaffold(
      appBar: appBarWidget(
        title: "را باندی",
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "تاریخ",
                    imgPath: "assets/icons/calendar.png",
                    controller: duesController.date,
                    onPressed: () => selectDate(duesController.date),
                    inputType: TextInputType.datetime),
                dropDownTextFieldWidget(
                  label: "گراک نوم غوره کړئ",
                  imgPath: "assets/icons/id.png",
                  dropDownList: dropDownList,
                  onChanged: (value) {
                    // Update the expenseType in the ExpenseController
                    duesController.customerName = value;
                    duesController.customerId.text=customerController.getCustomerIdByName(value)!;
                  },
                ),
                textFieldWidget(
                    label: "حوالا ادرس",
                    imgPath: "assets/icons/price.png",
                    controller: duesController.address),
                textFieldWidget(
                    label: "را باندی",
                    imgPath: "assets/icons/dues.png",
                    inputType: TextInputType.number,
                    controller: duesController.dues),
                SizedBox(
                  height: defaultPadding,
                ),
                CustomButton(
                  onPressed: () {
                    duesController.addDuesEntry();
                  },
                ),
              ],
            )),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding),
                  child: Text(
                    "راناندی کهاته",
                    style: boldTextStyle(),
                  ),
                )),
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
          ],
        ),
      ),
    );
  }
}
