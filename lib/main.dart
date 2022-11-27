import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController txtUserName = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  var sharedPref = null;
  bool isRemember = false;

  @override
  void initState() {
    super.initState();
    prepareSharedInstance();
  }

  Future<void> prepareSharedInstance() async {
    sharedPref = await SharedPreferences.getInstance();
    setState(() {
      isRemember = sharedPref.getBool("remember") ?? false;
      if (isRemember) {
        txtUserName.text = sharedPref.getString("username") ?? "";
        txtPassword.text = sharedPref.getString("pass") ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Text(
                'User',
                style: TextStyle(
                    color: Color.fromARGB(255, 28, 1, 59),
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 20, 30),
              alignment: Alignment.center,
              child: TextField(
                controller: txtUserName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 5, 20, 30),
              alignment: Alignment.center,
              child: TextField(
                obscureText: true,
                controller: txtPassword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 20),
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.green,
                onChanged: (newValue) {
                  setState(() {
                    isRemember = newValue!;
                    sharedPref.setBool("remember", newValue);
                  });
                },
                title: const Text(
                  "Remember me",
                  style: TextStyle(color: Colors.black),
                ),
                value: false,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  login();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() {
    if (isRemember) {
      sharedPref.setString("username", txtUserName.text.toString());
      sharedPref.setString("pass", txtPassword.text.toString());
    }
  }
}
