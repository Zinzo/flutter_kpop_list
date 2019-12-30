
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kpoplist/data/join_or_login.dart';
import 'package:kpoplist/helper/login_background.dart';
import 'package:kpoplist/screens/forget_password.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold (
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              size: size,
              painter: LoginBackground(isJoin: Provider.of<JoinOrLogin>(context).isJoin),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _logoImage,
                Stack(
                  children: <Widget>[
                    _inputForm(size),
                    _authButton(size)
                  ],
                ),

                Container(height: size.height * 0.10),
                Consumer<JoinOrLogin>(
                  builder: (BuildContext context, JoinOrLogin joinOrLogin, Widget child) => GestureDetector(
                    onTap: () {joinOrLogin.toggle();},
                    child: Text(
                      joinOrLogin.isJoin?
                      "Already Have an Account? Sign in":
                      "Don't Have an Accoutn? Create One",
                      style: TextStyle(color: joinOrLogin.isJoin? Colors.red:Colors.blue)
                    ),
                  ),
                ),
                Container(height: size.height * 0.05)
              ],
            )
          ],
        )
      );
  }

  void _register(BuildContext context) async{
    final AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text,password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null) {
      final snackBar = SnackBar(content: Text('Please try again later'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _login(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email:_emailController.text,password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null) {
      final snackBar = SnackBar(content: Text('Please try again later'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Widget get _logoImage => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top:40, left: 24, right: 24),
      child: FittedBox(
      fit: BoxFit.contain,
      child: CircleAvatar(
          backgroundImage: NetworkImage("https://i3.wp.com/i.gifer.com/7pv.gif"),
        ),
      ),
    )
  );

  Widget _authButton(Size size) {
    return Positioned(
      left: size.width*0.15,
      right: size.width*0.15,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: 
        Consumer<JoinOrLogin> (
          builder: (BuildContext context, JoinOrLogin joinOrLogin, Widget child) => RaisedButton(
            color: joinOrLogin.isJoin?Colors.red : Colors.blue,
            child:Text(
              joinOrLogin.isJoin?"Join":"Login",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              if(_formKey.currentState.validate()) {
                joinOrLogin.isJoin?_register(context):_login(context);
              }
            }
          ), 
        )
       
      )
    );
  }

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child:
        Padding(
          padding: const EdgeInsets.only(left: 12.0,right: 12.0, top: 12.0, bottom: 32.0),
          child: 
            Form(
              key: _formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(icon: Icon(Icons.lock),labelText: "password"),
                  validator: (String value) {
                    if( value.isEmpty) {
                      return "Please input correct Password";
                    } else {
                      return null;
                    }
                  },
                ),
                Container(height: size.height * 0.008),
                Consumer<JoinOrLogin>(
                  builder: (BuildContext context, JoinOrLogin joinOrLogin, Widget child) => Opacity(
                    opacity: joinOrLogin.isJoin?0:1,
                    child: GestureDetector(
                      onTap: joinOrLogin.isJoin? null : (){goToForgetPw(context);},child: Text("Forgot Password"),
                    )
                  ),
                )
              ],
            )
          ),
        )
        // Container(width: 200, height: 200, color: Colors.black)
    )
    );
  }
  goToForgetPw(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));
  }
}