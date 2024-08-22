import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import 'welcome_screen.dart';

class WalkthroughScreen extends StatefulWidget {
  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              buildPage(
                imagePath: 'assets/wk1.jpg',
                title: 'Home Basic Needs',
                text: 'We render quality and affordable service \n select from your services',
                showAppBarIcon: false,
                imageHeight: SizeConfig.height(35),
              ),
              buildPage(
                imagePath: 'assets/wk2.png',
                title: 'Book your appointment',
                text: 'We consider your scheduled book your \n desire date to get services rendered',
                showAppBarIcon: true,
                imageHeight: SizeConfig.height(35),
              ),
              buildPageWithButton(
                imagePath: 'assets/wk3.png',
                title: 'At your door at the correct\n             date and time',
                text: 'Yes! We offer services at your preferred date \n  and time',
                context: context,
                showAppBarIcon: true,
                imageHeight: SizeConfig.height(35),
              ),
            ],
          ),
          Positioned(
            bottom: SizeConfig.height(6),
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index ? 16 : 12,
                  height: _currentIndex == index ? 16 : 12,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentIndex == index ? Colors.yellow.shade700 : Colors.grey,
                      width: SizeConfig.width(0.5),
                    ),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required String imagePath,
    required String title,
    required String text,
    required bool showAppBarIcon,
    required double imageHeight,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showAppBarIcon
            ? IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primary1),
          onPressed: () {
            if (_currentIndex > 0) {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }
          },
        )
            : null,
        actions: [
          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                2,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: Text(
              "Skip",
              style: TextStyle(color: primary1, fontSize: 15, fontFamily: 'Lato'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.height(15)),
            Container(
              width: SizeConfig.width(60),
              height: imageHeight,
              child: Image.asset(imagePath),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 24, fontFamily: 'Lato', color: primary1, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: SizeConfig.height(1.2)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: 'Lato', color: primary1),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildPageWithButton({
    required String imagePath,
    required String title,
    required String text,
    required BuildContext context,
    required bool showAppBarIcon,
    required double imageHeight,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showAppBarIcon
            ? IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primary1),
          onPressed: () {
            if (_currentIndex > 0) {
              _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }
          },
        )
            : null,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.height(12)),
            Container(
              width: SizeConfig.width(60),
              height: SizeConfig.height(35),
              child: Image.asset(imagePath),
            ),
            SizedBox(height: SizeConfig.height(1),),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontFamily: 'Lato', fontWeight: FontWeight.bold),
            ),
            SizedBox(height: SizeConfig.height(1.2)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
            ),
            SizedBox(height: SizeConfig.height(2.0)),
            Myelavatedbutton(
              text: 'Get Started',
              ontap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              height: SizeConfig.height(5.5),
              width: SizeConfig.width(80),
              color: buttons,
              color2: secondary,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}




