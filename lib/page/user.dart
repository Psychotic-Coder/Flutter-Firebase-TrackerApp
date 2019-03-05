import 'package:flutter/material.dart';
import 'auth.dart';
import './menu.dart';
import 'dart:async';

// class User extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Tracker',
//         home: Scaffold(
//             // appBar: AppBar(
//             //   title: Text('L'),
//             //   backgroundColor: Colors.amber,
//             // ),
//             body: Center(
//               child: Column(
//                 children: <Widget>[
//                     LoginButton(), // <-- Built with StreamBuilder
//                     //UserProfile() // <-- Built with StatefulWidget
//                 ],
//               ),
//             )
//         )
//     );
//   }
// }

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  initState() {
    super.initState();

    // Subscriptions are created here
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
      Text(_loading.toString())
    ]);
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Timer(
                Duration(seconds: 1),
                    () {
                    Route route = MaterialPageRoute(builder: (context) => HomePage());
                    Navigator.pushReplacement(context, route);
                }
            );
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child:ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  Hero(
                    tag: "Tracker",
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 148.0,
                      child: Image.asset('./assets/home.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        authService.googleSignIn();
                        Route route = MaterialPageRoute(builder: (context) => HomePage());
                        Navigator.pushReplacement(context, route);
                      },
                      padding: EdgeInsets.all(12),
                      color: Colors.redAccent,
                      child: Text('Login with Google', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
              
              // child: MaterialButton(
              //   onPressed: () {
              //     authService.googleSignIn();
              //     Route route = MaterialPageRoute(builder: (context) => HomePage());
              //     Navigator.pushReplacement(context, route);
              //   },
              //   color: Colors.redAccent,
              //   textColor: Colors.white,
              //   child: Text('Login with Google'),
              // ),
            );
          }
        }
      )
    );
    
  }
}