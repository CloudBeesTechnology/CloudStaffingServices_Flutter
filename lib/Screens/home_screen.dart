import 'package:carousel_slider/carousel_slider.dart';
import 'package:css_app/constants/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/height_width.dart';
import '../widgts/myslider.dart';
import '../widgts/mytextfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();
  int _selectedIndex = 0;
  List<Map<String, dynamic>> services = [
    {'text': 'Clean house', 'icon': Image.asset('assets/cleanhouse.png',color: primary1,)},
    {'text': 'Electrician', 'icon': Image.asset('assets/electrician (2).png',color: primary1,)},
    {'text': 'Cook', 'icon': Image.asset('assets/cook.png',color: primary1,)},
    {'text': 'Barber', 'icon': Image.asset('assets/barber.png',color: primary1,)},
    {'text': 'Nurse', 'icon': Image.asset('assets/nurse.png',color: primary1,)},
    {'text': 'Security', 'icon': Image.asset('assets/security (2).png',color: primary1,)},
    {'text': 'Advocate', 'icon': Image.asset('assets/advocate (2).png',color: primary1,)},
    {'text': 'Mechanic', 'icon': Image.asset('assets/mechanic.png',color: primary1,)},
    {'text': 'Plumber', 'icon': Image.asset('assets/plumber (2).png',color: primary1,)},
    {'text': 'Child care', 'icon': Image.asset('assets/child care (2).png',color: primary1,)},
    {'text': 'Patient care', 'icon': Image.asset('assets/patient care.png',color: primary1,)},
    {'text': 'Elder care', 'icon': Image.asset('assets/eldercare.png',color: primary1,)},
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(

                  children: [
                    SizedBox(width: SizeConfig.width(1.5),),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person, size: 40, color: Colors.grey.shade700,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kavitha M', style: TextStyle(
                              color: home, fontSize: 18,fontFamily: 'Inter',)),
                          Text('Puducherry', style: TextStyle(
                              color: Color(0xF757575).withOpacity(0.6), fontSize: 14,fontFamily: 'Inter')),
                        ],
                      ),
                    ),
                    Spacer(),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                      elevation: 2,
                      shadowColor: Colors.white,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: IconButton(
                            icon: FaIcon(FontAwesomeIcons.bell,color: Color(0xF818181).withOpacity(1.0),size: 18,),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8,),
                  child: Row(
                    children: [
                      SizedBox(width: SizeConfig.width(10),),
        Card(
          elevation: 2,
          shadowColor: textFieldColor,
          child: Container(
            height: SizeConfig.height(5.5),
            width: SizeConfig.width(80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color:Color(0xFF7BD00).withOpacity(0.2),
            ),
            child: Row(
              children: [
                SizedBox(width: SizeConfig.width(8),),
                Expanded(
                  child: TextField(
                    controller: search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'search your service',
                      isDense: true,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14,color: Color(0xF757575).withOpacity(1.0), fontFamily: 'Lato'),
                      contentPadding: EdgeInsets.symmetric(vertical: 3.5,horizontal: 15.0),
                    ),
                  ),

                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.search,size: 24,color: Color(0xF4B4B4B).withOpacity(0.8),))
              ],
            ),
          ),
        ),
                    ],
                  ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: SizeConfig.height(17),
                  child: MyCarouselSlider(),
                ),
              ),

              SizedBox(height: SizeConfig.height(0.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: SizeConfig.width(5)),
                  Text('Our Services', style: TextStyle(color: home,
                      fontSize: 18,
                    fontFamily: 'Inter'
                      )),
                ],
              ),
              SizedBox(height: SizeConfig.height(1.0)),
              Container(
                height: SizeConfig.height(9),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length, // Number of services
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ourService(
                          services[index]['text'], services[index]['icon']),
                    );
                  },
                ),
              ),

              SizedBox(height: SizeConfig.height(0.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: SizeConfig.width(5)),
                  Text('Recomended Services', style: TextStyle(
                      color: home,
                      fontSize: 18,
                    fontFamily: 'Inter',
                     )),
                ],
              ),
              SizedBox(height: SizeConfig.width(0.8)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    recomendService(
                        'assets/cleaning.jpg', 'House Cleaning', 'Vishnu', '4.5',
                        '110(reviews)'),
                    recomendService(
                        'assets/cooking.jpeg', 'Cooking Service', 'Krishna',
                        '4.2', '89(reviews)'),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.height(1.0)),
                  Container(
                    width: SizeConfig.width(90),
                    height: SizeConfig.height(9.2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFEAB571).withOpacity(0.2),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: SizeConfig.width(4.5),
                          top: SizeConfig.height(1),
                          child: Text(
                            'Refer and get your free',
                            style: TextStyle(
                              color:primary1,
                              fontSize: 18,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Positioned(
                          left: SizeConfig.width(4.5),
                          bottom: SizeConfig.height(1.8),
                          child: Text(
                            'Services',
                            style: TextStyle(
                              color: primary1,
                              fontSize: 18,
                             fontFamily: 'Inter'
                            ),
                          ),
                        ),
                        Positioned(

                          right: SizeConfig.width(5.5),
                          bottom: SizeConfig.height(1.2),
                          child: Container(
                            width: SizeConfig.width(15),
                            height: SizeConfig.height(6.0),
                            child: Image.asset('assets/gift[1].png'),
                          ),
                        ),
                      ],
                    ),
                  )



            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.black,
        buttonBackgroundColor: Colors.yellow.shade700,
        height: SizeConfig.height(6.5),
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          print(index);
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/home icon.png',width: 25,height: 25,),
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/call icon.png',width: 25,height: 25,),
              Text('Call', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/loc icon.png',width: 25,height: 25,),
              Text('Location',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_alt_rounded, color: Colors.white),
              Text('Save', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ],
      ),

    );
  }

  Widget ourService(String text, Image icon) {
    return Container(
      width: SizeConfig.width(25),
      height: SizeConfig.height(7),
      decoration: BoxDecoration(
        color: Color(0xFFBFBFB).withOpacity(1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: SizeConfig.width(11),
            child: icon,
          ),
          Text(
            text,
            style: TextStyle(color: Color(0xFEAB571).withOpacity(1.0,),fontFamily: 'Inter',fontSize: 12
          ),
          )
        ],
      ),
    );
  }



  Widget recomendService(String image, String text1, String text2, String no1,
      String no2,) {
    return Card(
      elevation: 2,
      shadowColor: secondary,
      child: Container(
        width: SizeConfig.width(50),
        height: SizeConfig.height(22.8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(height: 5),
            Container(
              width: SizeConfig.width(45),
              height: SizeConfig.height(13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(image, fit: BoxFit.fill),
            ),
            SizedBox(height: SizeConfig.height(0.5),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(text1,style: TextStyle(color: primary1,fontFamily: 'Inter',fontSize: 12),),
                FaIcon(FontAwesomeIcons.heart,size: 16,),
              ],
            ),
            Row(
              children: [
                SizedBox(width: SizeConfig.width(5)),
                Text(text2, style: TextStyle(color: Color(0xFAAA6A6).withOpacity(1.0),fontSize: 12,fontFamily: 'Inter')),
              ],
            ),
            SizedBox(height: SizeConfig.height(0.5),),
            Row(
              children: [
                SizedBox(width: SizeConfig.width(3)),
                Icon(Icons.star, color:Color(0xFFFC703).withOpacity(1.0), size: 18),
                SizedBox(width: SizeConfig.width(3)),
                Text(no1,
                    style: TextStyle(color: buttons, fontSize: 12,fontFamily: "Inter")),
                SizedBox(width: SizeConfig.width(10)),
                Text(no2, style: TextStyle(color: Color(0xF797777).withOpacity(1.0), fontSize: 12,fontFamily: 'Inter')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

