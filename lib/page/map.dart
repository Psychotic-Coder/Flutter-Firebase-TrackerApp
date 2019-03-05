import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  @override
  _MapState createState() => new _MapState();
}

class _MapState extends State<MapPage> {
  StreamSubscription<DocumentSnapshot> subscription;
  StreamSubscription<QuerySnapshot> qSubscription;
  GoogleMapController mapController;
  final DocumentReference documentReference = Firestore.instance.document("sharedlocation/aEWIk3fE75WYi5pd9JZ4");
  final CollectionReference collectionReference = Firestore.instance.collection("sharedlocation");
  List<DocumentSnapshot> documents;
  int next=0;
  String userSearch;

  void _fetchLocation() {
    // var snapshot = collectionReference.snapshots().listen((data) =>
    //   data.documents.forEach((doc) => print(doc["displayName"])));
    for (var i = 0; i < documents.length; i++) {
      mapController.addMarker(
        MarkerOptions(
          position: LatLng(documents[i].data['Latitude'], documents[i].data['Longitude']),
          infoWindowText: InfoWindowText(documents[i].data['displayName'],"is here"),
          icon: BitmapDescriptor.defaultMarker
          //icon: BitmapDescriptor.fromAsset('images/flutter.png',),
        )
      );
    }
    // documentReference.get().then((datasnapshot) {
    //   if (datasnapshot.exists) {
    //     setState(() {
    //       name =datasnapshot.data['displayName'];
    //       lat = datasnapshot.data['Latitude'];
    //       lng = datasnapshot.data['Longitude'];
    //     });
    //   }
    // });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qSubscription = collectionReference.snapshots().listen((data){
      documents = data.documents;
    });
      
    // subscription = documentReference.snapshots().listen((datasnapshot) {
    //   if (datasnapshot.exists) {
    //     setState(() {
    //       lat = datasnapshot.data['Latitude'];
    //       lng = datasnapshot.data['Longitude'];
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
    qSubscription?.cancel();
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;     
    refresh();
  }
  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0.0, 0.0) : center, zoom: 15.0)));
    //getNearbyPlaces(center);
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sígueme"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (String choice){
              if(choice == Constants.Next){
                if(next < documents.length){
                  mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(documents[next].data['Latitude'], documents[next].data['Longitude']), zoom: 15.0)));
                  next ++;
                }
                else{
                  next = 0;
                  mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(documents[next].data['Latitude'], documents[next].data['Longitude']), zoom: 15.0)));
                  next ++;
                }
              }
              if(choice ==Constants.Search){
                showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    title: new Text("Enter Name"),
                    content: TextField(
                      onChanged: (value) {
                        userSearch = value;
                      },
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Search"),
                        onPressed: () {
                          var i;
                          for (i = 0; i < documents.length; i++) {
                            if(documents[i].data['displayName'] == userSearch){
                              print(i);
                              break;
                            }
                          }
                          Navigator.of(context).pop();
                          mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(documents[i].data['Latitude'], documents[i].data['Longitude']), zoom: 15.0)));
                        },
                      )
                    ],
                  )
                );
              }
              
              
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
        child: StreamBuilder(
          stream: Firestore.instance.collection('sharedlocation').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            else {
              // return MapView(documents: snapshot.data.documents);
              return Stack(
                children: <Widget>[
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      cameraPosition: CameraPosition(
                        target: LatLng(51.5160895, -0.1294527),
                        zoom: 17,
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Color.fromRGBO(36, 248, 229, 50),
        onPressed: () {
          _fetchLocation();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Constants{
  static const String Next = 'Next';
  static const String Search = 'Search';

  static const List<String> choices = <String>[
    Next,
    Search
  ];
}
