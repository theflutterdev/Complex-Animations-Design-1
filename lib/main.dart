import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
    title: 'Material App Complex Animation',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<String> imgUrls = [
    './images/noodles.jpg',
    './images/pancakes.jpg',
    './images/salad.jpg'
  ];
  List<String> names = ['London', 'New York', 'Sydney'];
  List<int> pricing = [2050, 3010, 1999];
  int currInd = 0;
  final PageController pctrl = PageController();

  //Rotation Animation
  Animation rotAnimfor;
  AnimationController rotCtrlfor;
  Animation rotAnimback;
  AnimationController rotCtrlback;
  double animVal = 0.0;

  //Opacity Anim
  Animation opcAnim;
  AnimationController opcAnimCtrl;

  @override
  void initState() {
    //Rotation Anim
    rotCtrlfor =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    rotAnimfor = Tween(begin: -0.0, end: -2.0).animate(rotCtrlfor)
      ..addListener(() {
        setState(() {
          animVal = rotAnimfor.value;
        });
      });
    rotCtrlback =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    rotAnimback = Tween(begin: 0.0, end: 2.0).animate(rotCtrlback)
      ..addListener(() {
        setState(() {
          animVal = rotAnimback.value;
        });
      });

    //Opacity Anim
    opcAnimCtrl =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    opcAnim = Tween(begin: 0.2, end: 1.0).animate(opcAnimCtrl)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Scaffold(
          body: Container(
            child: Stack(
            children: <Widget>[
              Transform.rotate(
                alignment: Alignment.bottomCenter,
                origin: Offset(0.0, 500.0),
                angle: animVal,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(imgUrls[currInd]),
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 0.0,
                      sigmaY: 0.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(opcAnim.value)),
                    ),
                  ),
                ),
              ),
              
              PageView.builder(
                onPageChanged: (i) {
                  opcAnimCtrl.forward().then((E) {
                    opcAnimCtrl.reverse();
                  });
                  if (i > currInd) {
                    //forward tween
                    rotCtrlfor.forward().then((E) {
                      rotCtrlfor.reset();
                      setState(() {
                        currInd = i;
                        //print("Curr Page : "+i.toString());
                      });
                    });
                  } else {
                    //backward tween
                    rotCtrlback.forward().then((E) {
                      rotCtrlback.reset();
                      setState(() {
                        currInd = i;
                        //print("Curr Page : "+i.toString());
                      });
                    });
                  }
                },
                controller: pctrl,
                itemCount: imgUrls.length,
                itemBuilder: (context, i) {
                  return Center(
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: 100
                      ),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.only(top: 200.0),
                      alignment: Alignment.topCenter,
                      height: currInd == i ? 550.0 : 400.0,
                      width: currInd == i ? 300.0 : 250.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20.0,
                              color: Colors.grey,
                            )
                          ],
                          image: DecorationImage(
                            image: AssetImage(imgUrls[currInd]),
                            fit: BoxFit.cover,
                          )),
                      
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(names[currInd], style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.white,
                      ),),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Travel for \$"+pricing[currInd].toString(), style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                      SizedBox(
                        height: 30.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        color: Colors.black,
                        padding: EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
                        child: Text("Add to Cart", style: TextStyle(
                          color: Colors.white,
                        ),),
                        onPressed: (){

                        },
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                  
                ),
              )
            ],
          ),
          )
        ));
  }

  @override
  void dispose() {
    rotCtrlfor.dispose();
    rotCtrlback.dispose();
    super.dispose();
  }
}
