import 'package:flutter/material.dart';
import './user.dart';
import './map.dart';
import './auth.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // theme: ,
      // backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text("Sígueme"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (String choice){
              authService.signOut();
              Route route = MaterialPageRoute(builder: (context) => LoginButton());
              Navigator.pushReplacement(context, route);
            },
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },          
          ),
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Hero(
              tag: "Tracker",
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(36, 248, 229, 50),
                radius: 108.0,
                child: Image.asset('./assets/home.png'),
              ),
            ),
            SizedBox(height: 40.0,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  authService.shareLocation();
                },
                padding: EdgeInsets.all(12),
                color: Color.fromRGBO(36, 248, 229, 50),
                child: Text('Share Location', style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(height: 20.0,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (context) => MapPage());
                  Navigator.push(context, route);
                },
                padding: EdgeInsets.all(12),
                color: Color.fromRGBO(36, 248, 229, 50),
                child: Text('Track Location', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        )
      ),
    );
  }
}

class Constants{
  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[
    SignOut
  ];
}

// import 'package:flutter/material.dart';

// class Page extends StatelessWidget {

//   final String title;

//   Page(this.title);

//   @override

//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(title: new Text(title), backgroundColor: Colors.redAccent,),
//       body: new Center(
//         child: new Text('Feature Unavailable for Beta version'),
//       ),
//     );
//   }
// }