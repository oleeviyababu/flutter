import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http; // add dependency => http: ^0.12.0+4

import 'dart:async';

void main() {
  runApp(
      MaterialApp(
        home: MessageDatas(),
      )

  );
}

class MessageDatas extends StatefulWidget {
  @override
  _MessageDatasState createState() => _MessageDatasState();
}

class _MessageDatasState extends State<MessageDatas> {

  Future<List<User>> _fetchusers() async{
    var data = await http.get('http://www.json-generator.com/api/json/get/cflpvZLaHm?indent=2');

    var jsonData = jsonDecode(data.body);

    List<User> users = [];

    for(var i in jsonData){
      User user = User(i['index'], i['imgurl'], i['name'], i['bio']);

      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
              "FEED",
            style:TextStyle(fontSize:32.0),
      ),
        backgroundColor: Colors.teal,

      ),
      body: Container(
        child: FutureBuilder(
          future: _fetchusers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null) {
              return Container (
                child: Center(
                  child: Text(''),
                ),
              );
            }
            else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Image.network(snapshot.data[index].imgurl),
                        radius: 30.0,
                      ),

                      title: Text(snapshot.data[index].name),
                      trailing:IconButton(
                      icon:Icon(Icons.arrow_forward),
                      ),

                         onTap: (){
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Detailpage(snapshot.data[index])));

                      },

                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
class Detailpage extends StatelessWidget {

  final User user;

  Detailpage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),

    body:SafeArea(
      child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),




                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Image.network(user.imgurl),
                      radius: 100.0,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: Text(
                        user.name,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w300),
                      )),

                  Padding(
                    padding: EdgeInsets.only(
                      top: 50.0,
                    ),
                    child: Text(
                      user.bio,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                ],

              ),
            ),
          ),
        ),
       ),

      );





  }
}

class User {
  final int index;
  final String imgurl;
  final String name;
  final String bio;
  User(this. index,this.imgurl,this.name,this.bio);
}

