// ignore_for_file: unused_element, dead_code, unused_field, prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapplication/Model/UserDetailsModel.dart';
import 'package:myapplication/pieChart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaiSanket Automation Privet Limited',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: const MyHomePage(title: 'User List'),
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
  List<UserDetailsModel>? _DisplayList = <UserDetailsModel>[];
  String? _search;
  bool? network;
  ConnectivityResult? _connectivityResult;

  @override
  void initState() {
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

  String selectedgender = 'Gender';

  // List of items in our dropdown menu
  var gender = [
    'Gender',
    'Male',
    'Female',
  ];
  String selectedstatus = 'Status';

  // List of items in our dropdown menu
  var status = [
    'Status',
    'Active',
    'InActive',
  ];

  Future<void> _handelRefresh() async {
    return await Future.delayed(Duration(seconds: 2)).whenComplete(() {
      _search = '';
      _firstLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => pieChartScreen()),
                    (Route route) => true);
              },
              icon: Icon(Icons.pie_chart_outline))
        ],
      ),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: true,
        backgroundColor: Colors.deepPurple[100],
        animSpeedFactor: 2,
        height: 300,
        color: Colors.deepPurple[200],
        onRefresh: _handelRefresh,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white
              //     gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   colors: [
              //     Colors.deepPurple.shade200,
              //     Colors.deepPurpleAccent.shade200,
              //   ],
              // )
              ),
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
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
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15),
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
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 150,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              // color: Color.fromARGB(255, 168, 211, 237),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton(
                            // isExpanded: true,
                            // Initial Value
                            value: selectedgender,
                            underline: Container(color: Colors.transparent),
                            isExpanded: true,
                            // Down Arrow Icon
                            icon: const Icon(Icons.arrow_drop_down_outlined),

                            // Array list of items
                            items: gender.map((String gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Center(
                                  child: Text(
                                    gender,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedgender = newValue!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40,
                          width: 150,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              // color: Color.fromARGB(255, 168, 211, 237),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton(
                            // isExpanded: true,
                            // Initial Value
                            value: selectedstatus,
                            underline: Container(color: Colors.transparent),
                            isExpanded: true,
                            // Down Arrow Icon
                            icon: const Icon(Icons.arrow_drop_down_outlined),

                            // Array list of items
                            items: status.map((String status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Center(
                                  child: Text(
                                    status,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedstatus = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _firstLoad(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == null || snapshot.data.isEmpty) {
                          return const Center(
                            child: Text("No data found!"),
                          );
                        }

                        // Filter the snapshot data based on the search query
                        List<UserDetailsModel> filteredData =
                            (snapshot.data as List<UserDetailsModel>)
                                .where((element) => element.name!
                                    .toLowerCase()
                                    .contains(_search!.toLowerCase()))
                                .toList();

                        if (filteredData.isEmpty) {
                          return const Center(
                            child: Text("No matching results!"),
                          );
                        }

                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredData.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = filteredData[index];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: getActiveStaus(item.status!),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Center(
                                            child: Image(
                                              image: AssetImage(
                                                  getUserAvatar(item.gender!)),
                                              height: 80,
                                              width: 80,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name.toString(),
                                          textScaleFactor: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            // fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            item.email
                                                .toString()
                                                .replaceAll('.example', '.com'),
                                            textScaleFactor: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              // fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: getActiveStaus(
                                                        item.status!)),
                                              ),
                                            ),
                                            item.status.toString() == 'active'
                                                ? const Text(
                                                    'Active',
                                                    textScaleFactor: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      // fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Non-Active',
                                                    textScaleFactor: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      // fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          "Something Went Wrong: " + snapshot.error.toString(),
                          textScaleFactor: 1,
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )

                  /*FutureBuilder(
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
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(color: getActiveStaus(snapshot.data[index].status),borderRadius: BorderRadius.circular(100)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Center(
                                            child: Image(image: AssetImage(getUserAvatar(snapshot.data[index].gender)),height: 80,width: 80,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, bottom: 5),
                                              child: Text(
                                                snapshot.data[index].name
                                                    .toString(),
                                                textScaleFactor: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  // fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, bottom: 5),
                                          child: FittedBox(
                                            child: Text(
                                              snapshot.data[index].email
                                                  .toString().replaceAll('.example','.com'),
                                              textScaleFactor: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                // fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: getActiveStaus(snapshot.data[index].status)
                                                ),
                                              ),
                                            ),
                                            snapshot.data[index].status
                                                        .toString() ==
                                                    'active'
                                                ? const Text(
                                                    'Active',
                                                    textScaleFactor: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      // fontFamily: 'Inter',
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
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      // fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
            */ //list view
                ],
              )),
        ),
      ),
    );
  }

  getActiveStaus(String status) {
    if (status == 'active') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  getUserAvatar(String gender) {
    var path;
    try {
      if (gender == 'male') {
        path = 'assets/images/man.png';
      } else if (gender == 'female') {
        path = 'assets/images/woman.png';
      } else {
        path = 'assets/images/man.png';
      }
    } catch (ex, _) {
      path = 'assets/images/man.png';
    }
    return path;
  }

  Future<List<UserDetailsModel>> _firstLoad() async {
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

      List<UserDetailsModel> fetchedData = json['data']
          .map<UserDetailsModel>((e) => UserDetailsModel.fromJson(e))
          .toList();

      setState(() {
        /*if (_search!.isNotEmpty) {
        _DisplayList = fetchedData
            .where((element) =>
                element.name!.toLowerCase().contains(_search!.toLowerCase()))
            .toList();
      } else*/
        if (selectedgender != 'Gender' && selectedstatus != 'Status') {
          _DisplayList = fetchedData
              .where((element) =>
                  element.gender == selectedgender.toLowerCase() &&
                  element.status == selectedstatus.toLowerCase())
              .toList();
        } else if (selectedgender != 'Gender') {
          _DisplayList = fetchedData
              .where(
                  (element) => element.gender == selectedgender.toLowerCase())
              .toList();
        } else if (selectedstatus != 'Status') {
          _DisplayList = fetchedData
              .where(
                  (element) => element.status == selectedstatus.toLowerCase())
              .toList();
        } else {
          _DisplayList = fetchedData;
        }
      });

      return _DisplayList!;
    } catch (err) {
      throw Exception("Something went wrong while fetching data");
    }
  }

  /* Future <List<UserDetailsModel>> _firstLoad() async {
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
      List<UserDetailsModel> fetchedData = <UserDetailsModel>[];
      json['data'].forEach((e) => fetchedData.add(UserDetailsModel.fromJson(e)));
      _DisplayList = [];
      setState(() {
        if( selectedgender!='Gender' || selectedstatus!='Status' )
        {
          _DisplayList=fetchedData.where((element) => element.gender==selectedgender.toLowerCase() || element.status==selectedstatus.toLowerCase()  ).toList();        
        }
        else if(_search!.isNotEmpty)
        {
          _DisplayList=fetchedData.where((element) => element.name!.toLowerCase().contains(_search!.toLowerCase())).toList();
        }
        else
        {
          _DisplayList=fetchedData;
        }
      });
      return _DisplayList!.toList();
    } catch (err) {
      throw Exception("Something went wrong while fetching data");
    }
  }*/
}



/*
Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: getActiveStaus(snapshot.data![index].status),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image(image: AssetImage(getUserAvatar(snapshot.data[index].gender)),height: 80,width: 80,),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, bottom: 5),
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
                                                  left: 5, bottom: 5),
                                              child: Text(
                                                snapshot.data[index].email
                                                    .toString(),
                                                textScaleFactor: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, bottom: 5),
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
                                                  left: 5, bottom: 8),
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
                                                        color: Colors.white,
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
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          */