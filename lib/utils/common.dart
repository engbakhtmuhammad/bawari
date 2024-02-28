import 'package:bawari/utils/colors.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'text_styles.dart';

class AppScaffoldKey {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
}

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
        SizedBox(
          height: 16,
        ),
        Text(text ?? "somethingWentWrong", style: primaryTextStyle()),
      ],
    ),
  );
}

Widget drawerWidget(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ), //BoxDecoration
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            accountName: Text(
              "Abhishek Mishra",
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text("abhishekm977@gmail.com"),
            currentAccountPictureSize: Size.square(50),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 165, 255, 137),
              child: Text(
                "A",
                style: TextStyle(fontSize: 30.0, color: Colors.blue),
              ), //Text
            ), //circleAvatar
          ), //UserAccountDrawerHeader
        ), //DrawerHeader
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text(' My Profile '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text(' My Course '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.workspace_premium),
          title: const Text(' Go Premium '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.video_label),
          title: const Text(' Saved Videos '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text(' Edit Profile '),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('LogOut'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

PreferredSizeWidget appBarWidget(
    {BuildContext? context, String? title, VoidCallback? onPressed}) {
  return AppBar(
      title: Text(
        title!,
        style: boldTextStyle(),
      ),
      centerTitle: true,
      backgroundColor: primaryColor,
      leading: IconButton(
          onPressed: () {
            print("Button Pressed");
            print(AppScaffoldKey.scaffoldKey.currentState); // Check i
            AppScaffoldKey.scaffoldKey.currentState?.openDrawer();
          },
          icon: Image.asset(
            "assets/icons/menu.png",
            width: 24,
          )),
      actions: [
        IconButton(
            onPressed: () => Navigator.pop(context!),
            icon: Image.asset(
              "assets/icons/back.png",
              width: 24,
            )),
      ]);
}


  Container billAndDateWidget({TextEditingController? billController, TextEditingController? dateController}) {
    return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(defaultRadius), bottomRight: Radius.circular(defaultRadius)),
            color: primaryColor,
          ),
          
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(defaultRadius * 2),
                  ),
                  child: TextField(
                    controller: billController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("بل نمبر"),
                            const SizedBox(
                              width: 3,
                            ),
                            Image.asset(
                              "assets/icons/invoice.png",
                              width: defaultIconsSize,
                              height: defaultIconsSize,
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
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
                SizedBox(height: defaultPadding,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(defaultRadius * 2),
                  ),
                  child: TextField(
                    controller: dateController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("تاريخ"),
                            const SizedBox(
                              width: 3,
                            ),
                            Image.asset(
                              "assets/icons/calendar.png",
                              width: defaultIconsSize,
                              height: defaultIconsSize,
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
    int? maxLine}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: defaultPadding/2.5),
    child: TextField(
      controller: controller,
      textAlign: TextAlign.right,
      maxLines: maxLine??1,
      decoration: InputDecoration(
        suffixIcon: Image.asset(
          imgPath,
          width: defaultIconsSize,
          height: defaultIconsSize,
        ),
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius * 2),
        ),
      ),
    ),
  );
}

// Widget loaderWidget() {
//   return Center(child: Lottie.asset(loader, height: 60, width: 60));
// }

