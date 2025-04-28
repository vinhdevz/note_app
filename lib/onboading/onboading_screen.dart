import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/welcome/welcom_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              OnboardingPage(
                image: 'assets/images/page1.png',
                title: 'Manage your tasks',
                description:
                    'You can easily manage all of your daily tasks in DoMe for free',
                currentPage: _currentPage,
                index: 0,
              ),
              OnboardingPage(
                image: 'assets/images/page2.png',
                title: 'Create daily routine',
                description:
                    'In Uptodo  you can create your personalized routine to stay productive',
                currentPage: _currentPage,
                index: 1,
              ),
              OnboardingPage(
                image: 'assets/images/page3.png',
                title: 'Orgonaize your tasks',
                description:
                    'You can organize your daily tasks by adding your tasks into separate categories',
                currentPage: _currentPage,
                index: 2,
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 20,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Text(
                'SKIP',
                style: TextStyle(
                  color: _currentPage > 0 ? tdWhite : tdGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: Duration(microseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: Text(
                    'BACK',
                    style: TextStyle(
                      color: _currentPage > 0 ? tdWhite : tdGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentPage < 2) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: tdDarkPurple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      )),
                  child: Text(
                    _currentPage == 2 ? 'GET STARTED' : 'NEXT',
                    style: TextStyle(
                      color: tdWhite,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final int currentPage;
  final int index;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tdBlack,
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40), 
          Image.asset(
            image,
            height: 350,
            width: 230,
          ),
          SizedBox(height: 40), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (dotIndex) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: currentPage == dotIndex ? tdWhite : tdGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          SizedBox(height: 50),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tdWhite,
              fontSize: 32,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 80), 
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tdWhite,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Lato',
            ),
          ),
          Spacer(), 
        ],
      ),
    );
  }
}
