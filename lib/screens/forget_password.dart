import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kpoplist/screens/main_page.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password')
      ),
      body: Form(
        key: _formKey,
        child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(icon: Icon(Icons.account_circle),labelText: "Email"),
            validator: (String value) {
              if(value.isEmpty) {
                return "Please input correct Email";
              } else {
                return null;
              }
            },
          ),
          FlatButton(onPressed: () async{
            await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
            SnackBar snackBar = SnackBar (
              content: Text("Check your Email for password")
            );
            Scaffold.of(_formKey.currentContext).showSnackBar(snackBar);
            Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=>MainPage(email: '')));
          }, child: Text('Reset Password'))
        ],
      )
      )
    );
  }
}