import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int index = 0;
  List<String> navbarTitle = ['Home', 'Explore', 'Membership'];
  List<String> navbarBody = [
    'View all your Registration QRs for the upcoming events.\n\nand 3 Info-Cards which show Information about the events.',
    'Find all the Upcoming Events in the Explore section, and all the Events in the All Events section.',
    'Join CSI to Get Free access to CSI events through out India, Access to Exclusive Resources by CSI, and an official CSI ID card from Chennai.',
  ];
  void _onIntroEnd(context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed('/user-home');
  }

  // Widget _buildFullscreenImage() {
  //   return Image.asset(
  //     Theme.of(context).brightness == Brightness.light
  //         ? 'assets/CSI-MJCET black.png'
  //         : 'assets/CSI-MJCET white.png',
  //     fit: BoxFit.cover,
  //     height: double.infinity,
  //     width: double.infinity,
  //     alignment: Alignment.center,
  //   );
  // }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: IntroductionScreen(
        key: introKey,
        // globalBackgroundColor: Colors.white,
        controlsPosition: Position.fromLTRB(
            0, MediaQuery.of(context).size.height / 1.2, 0, 0),
        allowImplicitScrolling: true,
        autoScrollDuration: 10000,
        infiniteAutoScroll: false,
        globalHeader: Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: _buildImage(
                  Theme.of(context).brightness == Brightness.light
                      ? 'assets/CSI-MJCET black.png'
                      : 'assets/CSI-MJCET white.png',
                  100),
            ),
          ),
        ),

        pages: [
          PageViewModel(
            title: "Event Card",
            body:
                "View the details of an event, and register for an upcoming event by tapping on this card.\n\nFind all the upcoming events in the Explore Section.",
            image: Card(
              child: SizedBox(
                height: 150,
                width: 310,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          showDragHandle: true,
                          context: context,
                          builder: ((context) => FractionallySizedBox(
                                heightFactor: 0.8,
                                widthFactor: 1,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InteractiveViewer(
                                          maxScale: 5,
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                (4 *
                                                    (AppBar()
                                                        .preferredSize
                                                        .height)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Card(
                                                  elevation: 25,
                                                  child: Container(
                                                    height: 300,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(13)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: 125,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(13)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 20, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Event Date',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    // fontSize:
                                    //     20,
                                    fontWeight: FontWeight.bold,
                                  )
                              //     const TextStyle(
                              //   fontSize: 20,
                              //   fontWeight:
                              //       FontWeight
                              //           .bold,
                              // ),
                              ),
                          Text(
                            'Event Date',
                            style: Theme.of(context).textTheme.titleMedium!,
                            // const TextStyle(
                            //     fontSize: 16,
                            //     fontWeight:
                            //         FontWeight
                            //             .w600),
                          ),
                          Text(
                            'Event Time',
                            style: Theme.of(context).textTheme.titleMedium!,
                            // const TextStyle(
                            //     fontSize: 16,
                            //     fontWeight:
                            //         FontWeight
                            //             .w600),
                          ),
                          Text(
                            'Event Location',
                            style: Theme.of(context).textTheme.titleMedium!,
                            // const TextStyle(
                            //     fontSize: 17,
                            //     fontWeight:
                            //         FontWeight
                            //             .w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Registration QR",
            body:
                "Get a Registration QR when you register for an event.\n\nShow this QR at the HR desk, to mark your attendance.",
            image: Card(
              child: SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PrettyQrView.data(
                      data: 'Registration QR',
                      decoration: PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      )),
                ),
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: navbarTitle[index],
            body: navbarBody[index],
            image: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: BottomNavigationBar(
                  elevation: 10,
                  currentIndex: index,
                  showUnselectedLabels: true,
                  selectedItemColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.grey,
                  selectedLabelStyle: GoogleFonts.poppins(),
                  unselectedLabelStyle: GoogleFonts.plusJakartaSans(),
                  unselectedItemColor: Colors.blue.shade800,
                  onTap: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.explore), label: 'Explore'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.card_membership_rounded),
                        label: 'Membership'),
                  ]),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Payments',
            body:
                'RazorPay is used to make secured payments throughout the app.\n\nPayments are used to register for events and get CSI membership.',
            image: _buildImage('assets/razorpay.png', 150),
            decoration: pageDecoration,
          ),
          // PageViewModel(
          //   title: "Full Screen Page",
          //   body:
          //       "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          //   image: _buildFullscreenImage(),
          //   decoration: pageDecoration.copyWith(
          //     contentMargin: const EdgeInsets.symmetric(horizontal: 16),
          //     fullScreen: true,
          //     bodyFlex: 2,
          //     imageFlex: 3,
          //     safeArea: 100,
          //   ),
          // ),
          // PageViewModel(
          //   title: "Another title page",
          //   body: "Another beautiful body text for this example onboarding",
          //   image: _buildImage(Theme.of(context).brightness == Brightness.light
          //       ? 'assets/CSI-MJCET black.png'
          //       : 'assets/CSI-MJCET white.png'),
          //   footer: ElevatedButton(
          //     onPressed: () {
          //       introKey.currentState?.animateScroll(0);
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.lightBlue,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //     child: const Text(
          //       'FooButton',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          //   decoration: pageDecoration.copyWith(
          //     bodyFlex: 6,
          //     imageFlex: 6,
          //     safeArea: 80,
          //   ),
          // ),
          // PageViewModel(
          //   title: "Title of last page - reversed",
          //   bodyWidget: const Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text("Click on ", style: bodyStyle),
          //       Icon(Icons.edit),
          //       Text(" to edit a post", style: bodyStyle),
          //     ],
          //   ),
          //   decoration: pageDecoration.copyWith(
          //     bodyFlex: 2,
          //     imageFlex: 4,
          //     bodyAlignment: Alignment.bottomCenter,
          //     imageAlignment: Alignment.topCenter,
          //   ),
          //   image: _buildImage(Theme.of(context).brightness == Brightness.light
          //       ? 'assets/CSI-MJCET black.png'
          //       : 'assets/CSI-MJCET white.png'),
          //   reverse: true,
          // ),
        ],
        onDone: () => _onIntroEnd(context),
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onBackToIntro(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnBoardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("This is the screen after Introduction"),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _onBackToIntro(context),
              child: const Text('Back to Introduction'),
            ),
          ],
        ),
      ),
    );
  }
}
