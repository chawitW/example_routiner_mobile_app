import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:intl/date_symbol_data_local.dart';
// initializeDateFormatting('fr_FR', null) async .then((_) => runMyCode());

void main() {
  runApp(MaterialApp(home: SixJarsRoute()));
}

class SixJarsRoute extends StatefulWidget {
  @override
  _SixJarsRouteState createState() => _SixJarsRouteState();
}

class _SixJarsRouteState extends State<SixJarsRoute>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation degOneTranslationAnimation;
  Animation rotationAnimation;

  String details = "";
  String date = "";
  String time = "";
  bool _validate = false;
  final _text = TextEditingController();
  bool incomeDialog;

  // var now = new DateTime.now();
  // var berlinWallFell = new DateTime.utc(1989, 11, 9);
  // var moonLanding = DateTime.parse("1969-07-20 20:18:04Z");

  double getRadainsFormDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  // PageController pageController = PageController(initialPage: 0);
  // int _currentPage = 0;
  TabController jarController;
  int _currentJar = 0;
  List<int> _currentAmount = [0, 0, 0, 0, 0, 0];
  // var stmType_index = 0;
  String amount = "0.00";
  String stmType = "";
  bool autoJar = true;
  List jarIcon = [
    Icons.account_balance_wallet_rounded,
    Icons.school_rounded,
    Icons.account_balance_rounded,
    Icons.trending_up_rounded,
    Icons.card_travel_rounded,
    Icons.card_giftcard_rounded,
  ];
  List jarName = [
    "Need jar",
    "Education jar",
    "Long-term saving jar",
    "Investment jar",
    "Self reward jar",
    "Donation jar",
  ];
  List percentage = [
    "55",
    "10",
    "10",
    "10",
    "10",
    "5",
  ];

  // _asyncMethod() async {
  //   animationController = await AnimationController(vsync: this, duration: Duration(microseconds: 250));
  //   degOneTranslationAnimation =
  //       Tween(begin: 0.0, end: 1.0).animate(animationController);
  // }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    degOneTranslationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    jarController = TabController(vsync: this, length: 6, initialIndex: 0);

    animationController.addListener(() {
      setState(() {});
    });

    //  _asyncMethod();
  }

  @override
  void dispose() {
    jarController.dispose();
    animationController.dispose();
    _text.dispose();
    super.dispose();
  }

  createSixJars() {
    for (int i = 0; i < jarName.length; i++) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("Ledger").doc(jarName[i]);
      Map<String, String> amount = {
        "jarAmount": "0",
        "jarNumber": i.toString(),
      };
      documentReference.set(amount);
    }
  }

  _updateAmount(incomeDialog, autoJar) {
    if (autoJar && incomeDialog) {
      for (int i = 0; i < jarName.length; i++) {
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection("Ledger").doc(jarName[i]);

        documentReference.set({
          "jarAmount":
              ((int.parse(amount) * int.parse(percentage[i]) / 100).round() +
                      _currentAmount[i])
                  .toString(),
          "jarNumber": i.toString(),
        });
      }
    } else if (!autoJar && incomeDialog) {
    } else {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("Ledger")
          .doc(jarName[_currentJar]);

      documentReference.set({
        "jarAmount":
            (_currentAmount[_currentJar] - (int.parse(amount))).toString(),
        "jarNumber": _currentJar.toString(),
      });
    }
  }

  createLedgers(incomeDialog, autoJar) {
    if (incomeDialog && autoJar) {
      for (int i = 0; i < jarName.length; i++) {
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection("Ledger").doc(jarName[i]);

        documentReference.collection("statementList").doc().set({
          "ledgerDetails": details,
          "ledgerDate": date,
          "ledgerTime": time,
          "ledgerType": stmType,
          "ledgerAmount": (int.parse(amount) * int.parse(percentage[i]) / 100)
              .round()
              .toString(),
        });
      }
    } else if (incomeDialog && !autoJar) {
    } else {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("Ledger")
          .doc(jarName[_currentJar]);

      Map<String, String> statement = {
        "ledgerDetails": details,
        "ledgerDate": date,
        "ledgerTime": time,
        "ledgerType": stmType,
        "ledgerAmount": amount,
      };
      documentReference.collection("statementList").doc().set(statement);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff52575D),
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /*create initial amount btn*/
                        // Center(
                        //   child: IconButton(
                        //     icon: Text("create mock up"),
                        //     onPressed: () {
                        //       setState(() {
                        //         createSixJars();
                        //       });
                        //     },
                        //   ),
                        // ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 4, left: 8, right: 8),
                          color: Color(0xffF6F4E6),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title:
                                    Center(child: Text(jarName[_currentJar])),
                              ),
                              ListTile(
                                  title: Center(
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("Ledger")
                                              .orderBy("jarNumber")
                                              .snapshots(),
                                          builder: (context, snapshots) {
                                            if (snapshots.data == null)
                                              return CircularProgressIndicator();
                                            for (int i = 0; i < 6; i++) {
                                              _currentAmount[i] = int.parse(
                                                  snapshots.data.documents[i]
                                                      ["jarAmount"]);
                                              // print(_currentAmount[i]);
                                            }
                                            return Text(
                                              snapshots.data.documents[
                                                          _currentJar]
                                                      ["jarAmount"] +
                                                  ".00",
                                              style: TextStyle(fontSize: 36),
                                            );
                                          }))),
                              ListTile(title: Center(child: Text("Baht"))),
                              TabBar(
                                unselectedLabelColor: Color(0xFF41444B),
                                indicatorColor: Color(0xffFDDB3A),
                                controller: jarController,
                                tabs: <Tab>[
                                  for (int i = 0; i < jarIcon.length; i++)
                                    Tab(
                                        icon: Icon(jarIcon[i],
                                            color: _currentJar == i
                                                ? Color(0xffFDDB3A)
                                                : Color(0xFF41444B))),
                                ],
                                onTap: (index) {
                                  _currentJar = index;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 8, right: 8),
                          color: Color(0xffF6F4E6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 5),
                                      child: Text(
                                        "Statement",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Ledger")
                                    .doc(jarName[_currentJar])
                                    .collection("statementList")
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  if (snapshots.data == null) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Container(
                                      margin:
                                          EdgeInsets.only(bottom: 5, top: 10),
                                      child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshots.data.documents.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot documentSnapshot =
                                                snapshots.data.documents[index];
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Card(
                                                color: documentSnapshot[
                                                            "ledgerType"] ==
                                                        "Income"
                                                    ? Color(0xffADE498)
                                                    : Color(0xffFA7F72),
                                                // elevation: 4,
                                                margin: EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: ListTile(
                                                  dense: true,
                                                  title: Container(
                                                    child: Text(documentSnapshot[
                                                                "ledgerDetails"] ==
                                                            ""
                                                        ? documentSnapshot[
                                                            "ledgerType"]
                                                        : documentSnapshot[
                                                            "ledgerDetails"]),
                                                  ),
                                                  trailing: Container(
                                                    child: Text(documentSnapshot[
                                                                "ledgerType"] ==
                                                            "Income"
                                                        ? "+" +
                                                            documentSnapshot[
                                                                "ledgerAmount"] +
                                                            ".00"
                                                        : "-" +
                                                            documentSnapshot[
                                                                "ledgerAmount"] +
                                                            ".00"),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    IgnorePointer(
                      child: Container(
                        color: Colors.transparent,
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadainsFormDegree(270),
                          degOneTranslationAnimation.value * 80),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadainsFormDegree(rotationAnimation.value)),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Color(0xffFA7F72),
                          width: 50,
                          height: 50,
                          icon: Icon(
                            Icons.remove,
                            color: Color(0xffF6F4E6),
                          ),
                          onClick: () {
                            setState(() {
                              incomeDialog = false;
                              details = "";
                              _showDialog(incomeDialog);
                            });
                          },
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadainsFormDegree(180),
                          degOneTranslationAnimation.value * 80),
                      child: CircularButton(
                        color: Color(0xffADE498),
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.add,
                          color: Color(0xffF6F4E6),
                        ),
                        onClick: () {
                          details = "";
                          incomeDialog = true;
                          _showDialog(incomeDialog);
                        },
                      ),
                    ),
                    CircularButton(
                      color: Color(0xffFDDB3A),
                      width: 60,
                      height: 60,
                      icon: Icon(
                        Icons.attach_money_rounded,
                        color: Color(0xffF6F4E6),
                      ),
                      onClick: () {
                        animationController.isCompleted
                            ? animationController.reverse()
                            : animationController.forward();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _showDialog(incomeDialog) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              stmType = incomeDialog ? "Income" : "Outgo";
              animationController.reverse();
              return AlertDialog(
                backgroundColor: Color(0xffF6F4E6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Center(
                    child: incomeDialog ? Text("INCOME") : Text("OUTGO")),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText: 'amount statement',
                            labelText: 'Amount',
                          ),
                          onChanged: (String value) {
                            amount = value;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextField(
                          // controller: _text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText: 'amount statement',
                            labelText: 'Details',
                            // errorText:
                            //     _validate ? "Please enter some details" : null,
                          ),
                          onChanged: (String value) {
                            details = value;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText: 'amount statement',
                            labelText: 'Date',
                          ),
                          onChanged: (String value) {
                            date = value;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText: 'amount statement',
                            labelText: 'Time',
                          ),
                          onChanged: (String value) {
                            time = value;
                          },
                        ),
                      ),
                      if (incomeDialog)
                        ListTile(
                          // dense: true,
                          title: Text("Separate income"),
                          subtitle: autoJar
                              ? Text("Automatically")
                              : Text("Manually"),
                          trailing: Switch(
                            value: autoJar,
                            onChanged: (state) {
                              setState(() {
                                autoJar = !autoJar;
                              });
                            },
                          ),
                        ),
                      if (!autoJar)
                        Column(
                          children: [
                            for (int i = 0; i < jarName.length; i++)
                              listOfEachJar(jarName[i], percentage[i]),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  _updateAmount(incomeDialog, autoJar);
                                  createLedgers(incomeDialog, autoJar);
                                });
                              },
                              child: Container(
                                child: Icon(
                                  Icons.add_circle_rounded,
                                  color: Color(0xffFDDB3A),
                                  size: 50,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

Widget listOfEachJar(jarName, percentage) {
  return ListTile(
    title: Text(jarName),
    trailing: Container(
      width: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: percentage,
                    ),
                    onChanged: (input) {},
                  ),
                ),
              ],
            ),
          ),
          Container(margin: EdgeInsets.only(right: 10), child: Text("%")),
        ],
      ),
    ),
  );
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.width, this.height, this.color, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xffF6F4E6))),
      width: width,
      height: height,
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}
