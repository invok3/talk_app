import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obs = true;

  String loginError = "";
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            //color: Colors.red,
            constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
            child: Column(
              children: [
                Spacer(),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                ),
                Spacer(),
                TextField(
                  controller: password,
                  obscureText: _obs,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obs = !_obs;
                        });
                      },
                      icon: Icon(
                        _obs ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                loginError.isEmpty
                    ? Container()
                    : Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          Text("Unauthorized!",
                              style: TextStyle(color: Colors.red[700]))
                        ],
                      ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loginError = "";
                    });
                    String? result = await login();
                    if (result != null) {
                      setState(() {
                        loginError = result;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Text("Login"),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> login() async {
    String? x = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        content: FutureBuilder(
          future: loginWithUserPass(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else {
              Navigator.of(context).pop(snapshot.data);
              return Container();
            }
          },
        ),
      ),
    );
    return x;
  }

  Future<String?> loginWithUserPass() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } catch (e) {
      return "Error: ${e.toString().split("]").last}";
    }
    return null;
  }
}
