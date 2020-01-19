//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:wakala/ui/viewpost.dart';
import 'package:wakala/ui/widgets/slide_item.dart';
import 'Data/posts.dart';
import 'package:html/parser.dart';

class Wakala extends StatefulWidget {
  final int id;

  const Wakala({Key key, this.id}) : super(key: key);

  @override
  _WakalaState createState() => _WakalaState();
}

class _WakalaState extends State<Wakala> {
  String imgurl =
      'http://w.almustaqbal.ly/wp-content/uploads/2019/06/64627701_442078543247525_3828041687351951360_n.png';
  List postsLenght = new List();

  Future<void> getLenght() async {
    postsLenght = await fetchByCat(widget.id);
  }

//   FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    this.getLenght();
//   firebaseMessaging.configure(
//     onMessage: (Map<String, dynamic> message) {
//       print('onMessage called: $message');
//        showDialog(
//                context: context,
//                builder: (context) => AlertDialog(
//                        content: ListTile(
//                        title: Text(message['notification']['title']),
//                        subtitle: Text(message['notification']['body']),
//                        ),
//                        actions: <Widget>[
//                        FlatButton(
//                            child: Text('Ok'),
//                            onPressed: () => Navigator.of(context).pop(),
//                        ),
//                    ],
//                ),
//            );
//
//     },
//     onResume: (Map<String, dynamic> message) {
//       print('onResume called: $message');
//     },
//     onLaunch: (Map<String, dynamic> message) {
//       print('onLaunch called: $message');
//     },
//   );
//   firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));
//   firebaseMessaging.getToken().then((token){
//   print('FCM Token: $token');
// });
  }

  @override
  Widget build(BuildContext cntx) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Container(
          height: MediaQuery.of(cntx).size.height,
          width: MediaQuery.of(cntx).size.width,
          child: FutureBuilder(
              future: fetchByCat(widget.id),
              builder: (cntx, snapshot) {
                if (snapshot.hasData) {
                  print(postsLenght.length);
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount:
                        postsLenght.length == 0 ? 12 : postsLenght.length,
                    itemBuilder: (BuildContext cntx, int index) {
                      Map trend = snapshot.data[index];
                      String title = snapshot.data[index]['title']['rendered'];
                      String image =
                          snapshot.data[index]['jetpack_featured_media_url'];
                      String content =
                          snapshot.data[index]['content']['rendered'];
                      return InkWell(
                        onTap: () => {
                          Navigator.push(
                              cntx,
                              MaterialPageRoute(
                                  builder: (cntx) => ViewPost(
                                        title: title,
                                        content: content,
                                        image: image,
                                      )))
                        },
                        child: SlideItem(
                          title: parse(trend['title']['rendered'].toString())
                              .documentElement
                              .text,
                          img: trend['jetpack_featured_media_url'] == ''
                              ? imgurl
                              : trend['jetpack_featured_media_url'],
                        ),
                      );
                    },
                  );
                }
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(212, 175, 55, 1),
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(27, 38, 50, 1)),
                ));
              }),
        ),
      ),
    );
  }
}