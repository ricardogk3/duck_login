import 'package:duck_gun/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool repet = true;

/// This is the stateful widget that the main application instantiates.
class SplashAnimation extends StatefulWidget {
  // const LogoFade2({Key? key}) : super(key: key);

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation> with TickerProviderStateMixin {
  late final AnimationController controller;
  late final AnimationController controller1;
  late final Animation<double> animationBomba;
  late final Animation<double> explosaoBomba;
  late final Animation<double> telablack;
  late final Animation<double> patofogo;
  late final Animation<double> telablackWidthAnimation;
  late final Animation<double> telablackHeightAnimation;

  @override
  void initState() {
    // var deviceData = MediaQuery.of(context);
    // var screen = deviceData.size;
    // print(screen);

    super.initState();
    controller =
        new AnimationController(duration: Duration(seconds: 6), vsync: this)
          ..addListener(() => setState(() {}));
    controller1 = new AnimationController(
        duration: Duration(milliseconds: 500), vsync: this)
      ..addListener(() => setState(() {}));
    animationBomba = Tween(begin: -500.0, end: 1200.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 0.5, curve: Curves.ease)));
    // animationBomba = Tween(begin: -500.0, end: 1200.0).animate(controller);
    // controller.forward();

    explosaoBomba = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: controller, curve: Interval(0.25, 0.35, curve: Curves.ease)),
    );

    telablack = Tween(begin: 0.0, end: 1.0).animate(
      // CurvedAnimation(
        // parent: controller1,
        // curve: Interval(0.5, 0.509, curve: Curves.easeOut))
        controller1
        );
    telablackWidthAnimation = Tween(begin: 1.0, end: 400.0).animate(
        // CurvedAnimation(parent: controller1, curve: Interval(0.60, 0.85))
        controller1
        );
    telablackHeightAnimation = Tween(begin: 5.0, end: 100.0).animate(
        // CurvedAnimation(parent: controller1, curve: Interval(0.1, 0.35))
        controller1
        );

    patofogo = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.35, 0.99, curve: Curves.ease)));


    controller.forward();
    Future.delayed(const Duration(milliseconds: 5000), () {
      
      print(repet);
      if (repet) {
        controller1.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controller1.reverse();
            repet = false;
          } else if (status == AnimationStatus.dismissed) {
            controller1.forward();
          }
        });
        controller1.forward();
      } else {
        controller1.stop();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 6050), () {
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          // since this triggers when the animation is done, no duration is needed
          builder: (context) => SplashPage()),
    );
    });
    
  }


  @override
  Widget build(BuildContext context) {
    var deviceData = (MediaQuery.of(context).size.width - 500) / 2;
    var screen = deviceData;
    // print(screen);
    // print(deviceData.runtimeType);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: Transform.translate(
              child: Image.asset('images/ms.png'),
              offset: Offset(0.0, animationBomba.value),
            ),
          ),
          Opacity(
            opacity: explosaoBomba.value,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/ex.gif",
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: patofogo.value,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/fogo.gif",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: patofogo.value,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/pato2.png",
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: telablack.value,
            child: Center(
              child: Container(
                width: telablackWidthAnimation.value,
                height: telablackHeightAnimation.value,
                child: Transform.translate(
                  child: Image.asset('images/brilho.png'),
                  offset: Offset(-5.0, -20.0),
                ),

                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage(
                //         "images/brilho.png",
                //       ),
                //       fit: BoxFit.scaleDown,
                //     ),
                //   ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
