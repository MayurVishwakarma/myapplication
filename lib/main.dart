import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapplication/Model/AnjitaapiModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anjita IT Solutions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<anjitaapiModel>? _DisplayList = <anjitaapiModel>[];
  String? _search;
  bool? network;
  ConnectivityResult? _connectivityResult;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnectivityState();
    setState(() {
      _search = '';
      network = false;
    });
  }

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      setState(() {
        network = true;
      });
    } else {
      setState(() {
        network = false;
      });
    }

    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.deepPurple.shade200,
            Colors.deepPurpleAccent,
          ],
        )
            // image: DecorationImage(
            //     image: AssetImage('assets/images/AppBackgroound.jpg'),
            //     fit: BoxFit.cover),
            ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            //search bar
            Stack(
              children: [
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) async {
                                setState(() {
                                  _search = value;
                                });
                              },
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  hintText: "Search"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _firstLoad(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25, bottom: 10),
                                          child: Text(
                                            snapshot.data[index].name
                                                .toString(),
                                            textScaleFactor: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25, bottom: 10),
                                          child: Text(
                                            snapshot.data[index].email
                                                .toString(),
                                            textScaleFactor: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25, bottom: 10),
                                          child: Text(
                                            snapshot.data[index].gender
                                                .toString(),
                                            textScaleFactor: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25, bottom: 8),
                                          child: snapshot.data[index].status
                                                      .toString() ==
                                                  'active'
                                              ? const Text(
                                                  'Active',
                                                  textScaleFactor: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : const Text(
                                                  'Non-Active',
                                                  textScaleFactor: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("No data found !"),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text(
                    "Something Went Wrong: " + snapshot.error.toString(),
                    textScaleFactor: 1,
                  );
                } else {
                  return Center(child: Container());
                }
              },
            ),
            //list view
          ],
        )),
      ),
    );
  }

  Future _firstLoad() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      dynamic json;
      if (network == true) {
        final res =
            await http.get(Uri.parse('https://gorest.co.in/public-api/users'));
        json = jsonDecode(res.body);
        preferences.setString('Jsonbody', res.body);
      } else {
        String? jsonData = preferences.getString('Jsonbody');
        json = jsonDecode(jsonData!);
      }
      List<anjitaapiModel> fetchedData = <anjitaapiModel>[];
      json['data'].forEach((e) => fetchedData.add(anjitaapiModel.fromJson(e)));
      _DisplayList = [];

      return _search!.isNotEmpty
          ? fetchedData
              .where((element) =>
                  element.name!.toLowerCase().contains(_search!.toLowerCase()))
              .toList()
          : fetchedData;
    } catch (err) {
      throw Exception("Something went wrong while fetching data");
    }
  }
}
