

import 'package:bawari/utils/colors.dart';
import 'package:flutter/material.dart';

import 'text_styles.dart';

class AppScaffoldKey {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
        SizedBox(height: 16,),
        Text(text ?? "somethingWentWrong", style: primaryTextStyle()),
      ],
    ),
  );
}

Widget drawerWidget(BuildContext context){
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
PreferredSizeWidget appBarWidget({BuildContext? context, String? title, VoidCallback? onPressed}){
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
              onPressed: ()=>Navigator.pop(context!),
              icon: Image.asset(
                "assets/icons/back.png",
                width: 24,
              )),
        ]);
}

// Widget loaderWidget() {
//   return Center(child: Lottie.asset(loader, height: 60, width: 60));
// }

