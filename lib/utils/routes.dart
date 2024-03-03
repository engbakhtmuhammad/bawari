
import 'package:bawari/view/Expense/expense.dart';
import 'package:bawari/view/auth/forgot_password.dart';
import 'package:bawari/view/auth/login.dart';
import 'package:bawari/view/auth/signup.dart';
import 'package:bawari/view/credit/credit.dart';
import 'package:bawari/view/customer/customer.dart';
import 'package:bawari/view/dashboard/dashboard.dart';
import 'package:bawari/view/dues/dues.dart';
import 'package:bawari/view/goods/goods.dart';
import 'package:bawari/view/loan/loan_info.dart';
import 'package:bawari/view/loan/on_people_Loan.dart';
import 'package:bawari/view/purchase/purchase.dart';
import 'package:bawari/view/purchase/purchase_info.dart';
import 'package:bawari/view/sell/sell.dart';
import 'package:bawari/view/sell/sell_info.dart';
import 'package:bawari/view/stock/stock.dart';
import 'package:get/get.dart';

var pages = [
  GetPage(
    name: "/login",
    page: () => LoginScreen(),
  ),
  GetPage(
    name: "/signup",
    page: () => SignupScreen(),
  ),
  GetPage(
    name: "/forgot",
    page: () => ForgotPasswordScreen(),
  ),
  GetPage(
    name: "/credit",
    page: () => CreditScreen(),
  ),
  GetPage(
    name: "/customer",
    page: () => CustomerScreen(),
  ),
  GetPage(
    name: "/dashboard",
    page: () => DashboardScrreen(),
  ),
  GetPage(
    name: "/dues",
    page: () => DueScreen(),
  ),
  GetPage(
    name: "/expense_info",
    page: () => ExpenseInfoScreen(),
  ),
  GetPage(
    name: "/goods",
    page: () => GoodsScreen(),
  ),
  GetPage(
    name: "/loan",
    page: () => LoanScreen(),
  ),
  GetPage(
    name: "/loan_info",
    page: () => LoanInfoScreen(),
  ),
  GetPage(
    name: "/purchase",
    page: () => PurchaseScreen(),
  ),
  GetPage(
    name: "/purchase_info",
    page: () => PurchaseInfoScreen(),
  ),
  GetPage(
    name: "/sell",
    page: () => SellScreen(),
  ),
  GetPage(
    name: "/sell_info",
    page: () => SellInfoScreen(),
  ),
  GetPage(
    name: "/stock",
    page: () => StockScreen(),
  ),
];