import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/pages/registor.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/pages/showtrip.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/holymoly.png',
                    width: 350,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 20)),
              TextField(
                controller: phoneCtl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              const Text('รหัสผ่าน', style: TextStyle(fontSize: 20)),
              TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: register,
                    child: const Text(
                      'ลงทะเบียนใหม่',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  FilledButton(
                    onPressed: login,
                    style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneCtl.text,
      password: passwordCtl.text,
    );
    http
        .post(
          Uri.parse("$url/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          if (customerLoginPostResponse.customer != null) {
            log(customerLoginPostResponse.customer.fullname);
            log(customerLoginPostResponse.customer.email);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShowTripPage(cid: customerLoginPostResponse.customer.idx),
              ),
            );
          } else {
            // ถ้า login ผิดพลาด
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed. Please check your credentials."),
              ),
            );
          }
        })
        .catchError((error) {
          log('Error $error');
        });
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
}