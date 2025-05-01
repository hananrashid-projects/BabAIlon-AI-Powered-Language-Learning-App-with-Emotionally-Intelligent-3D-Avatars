import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:babellion/routes/app_route.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  int selectedButtonIndex = -1;

  final List<String> images = [
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/8.jpg',
  ];

  final List<Color> cardColors = [
    const Color.fromARGB(255, 241, 227, 226),
    const Color.fromARGB(255, 214, 228, 214),
    const Color.fromARGB(255, 226, 222, 216),
    const Color.fromARGB(255, 227, 218, 216),
  ];
  int currentIndex = 0;
  PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  int currentPage = 0;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> features = [
    {
      "text": "AI-Driven Avatar",
      "icon": "assets/images/icon1.png",
      "description":
          "Develop 3D avatars with emotional expressions and distinct personalities to simulate human-like interactions.",
      "color": Color(0xFFD8D6D6),
    },
    {
      "text": "Real-Time Feedback",
      "icon": "assets/images/icon2.png",
      "description":
          "Immediate AI feedback helps users refine language skills effectively.",
      "color": Color(0xFFC8B8AB),
    },
    {
      "text": "Adaptive Conversational Fluency",
      "icon": "assets/images/icon3.png",
      "description": "Dynamic conversations tailored to user progress.",
      "color": Color(0xFFDFDFC2),
    },
    {
      "text": "User Progress Tracking",
      "icon": "assets/images/icon4.png",
      "description":
          "A dashboard showing fluency metrics, history, and feedback with ranks.",
      "color": Color(0xFFE8D2DE),
    },
  ];

  final List<String> buttons = [
    'About BabAIlon',
    'Our Mission',
    'Features',
    'Team',
    'Contact Us',
    'Questions & Feedback',
  ];
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey missionKey = GlobalKey();
  final GlobalKey featuresKey = GlobalKey();
  final GlobalKey teamKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();
  final GlobalKey feedbackKey = GlobalKey();
  bool isLoading = true; // Page loading state

  late final Map<String, GlobalKey> sectionKeys;
  @override
  void initState() {
    super.initState();
    fetchUserName();
    startImageSlider();
    _scrollController.addListener(() {
      setState(() {});
    });
    _scrollController2.addListener(() {
      setState(() {});
    });
    sectionKeys = {
      'About BabAIlon': aboutKey,
      'Our Mission': missionKey,
      'Features': featuresKey,
      'Team': teamKey,
      'Contact Us': contactKey,
      'Questions & Feedback': feedbackKey,
    };
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['fullName'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    {
      setState(() {
        // isLoading = false;
      });
    }
  }

  void startImageSlider() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % images.length;
          _pageController.animateToPage(
            currentIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
        startImageSlider();
      }
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    context.go(AppRouter.login.path);
  }

  Future<void> profile() async {
    context.go(AppRouter.profile.path);
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    double cardWidth = 220;
    double horizontalPadding = 8.0;
    double cardTotalWidth = cardWidth + horizontalPadding * 2;
    double viewportWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logocropped.PNG', width: 60, height: 60),
            Expanded(
              child: Center(
                child: const Text(
                  'Home',
                  style: TextStyle(
                    color: Color(0xFF915050),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFEFFF7),
        actions: [
          IconButton(
            onPressed: profile,
            icon: const Icon(Icons.account_circle, color: Colors.brown),
            tooltip: 'profile',
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.brown),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Hello, ',
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins')),
                  userName.isNotEmpty
                      ? Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
              const Text(
                "Don't Wait, Babel Your Way to Fluency!",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                    fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  double sliderHeight;
                  if (constraints.maxWidth > 1200) {
                    // Desktop (large screens)
                    sliderHeight = 500;
                  } else if (constraints.maxWidth > 800) {
                    // Web (medium screens)
                    sliderHeight = 500;
                  } else if (constraints.maxWidth > 500) {
                    // Web (medium screens)
                    sliderHeight = 300;
                  } else {
                    // Mobile (small screens)
                    sliderHeight = 200;
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: sliderHeight,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.asset(
                                images[index],
                                width: double.infinity,
                                height: sliderHeight,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Row(
                            children: List.generate(
                              images.length,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: currentIndex == index ? 12 : 8,
                                height: currentIndex == index ? 12 : 8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButtonIndex = index;
                          });
                          GlobalKey key = sectionKeys[buttons[index]]!;
                          Scrollable.ensureVisible(
                            key.currentContext!,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: selectedButtonIndex == index
                              ? Colors.white
                              : Colors.brown,
                          backgroundColor: selectedButtonIndex == index
                              ? Colors.brown
                              : Colors.grey[200],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Text(
                          buttons[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // About BabAIlon Section
              Container(
                key: aboutKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('About BabAIlon ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 56, 56, 56),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: Image.asset(
                        'assets/images/aboutus.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Stack(
              //         children: [
              //           Center(
              //             child: Animate(
              //               effects: [ShakeEffect(duration: 2.seconds)],
              //               child: Image.asset('assets/images/mobileavatar.jpg',
              //                   width: 100, fit: BoxFit.cover),
              //             ),
              //           ),
              //           Positioned(
              //             top: 10,
              //             left: 0,
              //             child: Animate(
              //               effects: [FadeEffect(duration: 2.seconds)],
              //               child: const Text(
              //                 "BabAIlon is an\nAI-driven language \nlearning platform",
              //                 style: TextStyle(
              //                     color: Color.fromARGB(255, 74, 64, 64),
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //             top: 10,
              //             right: 0,
              //             child: Animate(
              //               delay: 2.seconds,
              //               effects: [FadeEffect(duration: 2.seconds)],
              //               child: const Text(
              //                 "Improve\nConversational\nskills",
              //                 style: TextStyle(
              //                     color: Color.fromARGB(255, 78, 63, 63),
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //             bottom: 10,
              //             left: 0,
              //             child: Animate(
              //               delay: 4.seconds,
              //               effects: [FadeEffect(duration: 2.seconds)],
              //               child: const Text(
              //                 "Interactive\nexperiences\nwith AI avatars",
              //                 style: TextStyle(
              //                     color: Color.fromARGB(255, 78, 63, 63),
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //             bottom: 10,
              //             right: 0,
              //             child: Animate(
              //               delay: 6.seconds,
              //               effects: [FadeEffect(duration: 2.seconds)],
              //               child: const Text(
              //                 "Personalized\nlessons to make\n learning fun\n and effective",
              //                 style: TextStyle(
              //                     color: Color.fromARGB(255, 78, 63, 63),
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                key: missionKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Our Mission ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 56, 56, 56),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 20),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    //   child: Image.asset(
                    //     'assets/images/aboutus2.jpg',
                    //     fit: BoxFit.cover,
                    //     width: double.infinity,
                    //     height: 200,
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                text: '"Our Mission ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    'is to transform language learning with AI-powered avatars, real-time feedback, and adaptive learning, helping users achieve fluency in multiple languages."',
                                style: TextStyle(color: Colors.brown),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(1.0),
              //   child: Center(
              //     child: const Text(
              //         'We aim to support multilingual proficiency aligning with Qatar National Vision 2030. ',
              //         style: TextStyle(
              //             color: Color.fromARGB(255, 134, 132, 132),
              //             // fontWeight: FontWeight.bold,
              //             fontSize: 13,
              //             fontFamily: 'Poppins')),
              //   ),
              // ),

              const SizedBox(height: 40),
              Container(
                key: featuresKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Features ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 56, 56, 56),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        controller: _scrollController2,
                        scrollDirection: Axis.horizontal,
                        physics: PageScrollPhysics(),
                        clipBehavior: Clip.none,
                        itemCount: features.length,
                        itemBuilder: (context, index) {
                          // Calculate the current scroll offset.
                          double currentOffset = _scrollController2.hasClients
                              ? _scrollController2.offset
                              : 0;
                          // Compute the center of this card.
                          double cardCenter =
                              index * cardTotalWidth + cardTotalWidth / 2;
                          // Compute the center of the viewport.
                          double viewportCenter =
                              currentOffset + viewportWidth / 2;
                          // Calculate the distance from this card's center to the viewport's center.
                          double distance = (viewportCenter - cardCenter).abs();
                          // Adjust the scale: full scale at center (1.0) and scaled down to 0.7 when far away.
                          double scale =
                              1.0 - (distance / cardTotalWidth) * 0.3;
                          scale = scale.clamp(0.7, 1.0);

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: Transform.scale(
                              scale: scale,
                              child: CardWidget(feature: features[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                key: teamKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Meet the Team ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 56, 56, 56),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: const [
                            MemberCircle(name: "Islam Hamdi"),
                            MemberCircle(name: "Hanan Rashid"),
                            MemberCircle(name: "Rain Alkai"),
                            MemberCircle(name: "Israa Demdoum"),
                            MemberCircle(name: "Leina Elsheiri"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Contact Us Section (No external launcher)
              Container(
                key: contactKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Us',
                      style: TextStyle(
                          color: Color.fromARGB(255, 56, 56, 56),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 20),
                    // Instagram Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt,
                            color: Color.fromARGB(255, 78, 65, 59)),
                        SizedBox(width: 10),
                        Text(
                          'Instagram: @babailon',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Phone Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone,
                            color: Color.fromARGB(255, 78, 65, 59)),
                        SizedBox(width: 10),
                        Text(
                          '+1234567890',
                          style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Email Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.email,
                            color: Color.fromARGB(255, 78, 65, 59)),
                        SizedBox(width: 10),
                        Text(
                          'contact@example.com',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                key: feedbackKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Questions & Feedback',
                      style: TextStyle(
                          color: Color.fromARGB(255, 56, 56, 56),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _fullNameController,
                      icon: Icons.person,
                      hintText: 'Full Name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      icon: Icons.email,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      icon: Icons.phone,
                      hintText: 'Phone Number',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _messageController,
                      icon: Icons.message,
                      hintText: 'Your Message',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Here you can add your logic to send this data via email
                          // For now, we'll just clear the fields and show a snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Feedback submitted!')),
                          );
                          _fullNameController.clear();
                          _emailController.clear();
                          _phoneController.clear();
                          _messageController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFFEFFF7),
    );
  }
}

class CardWidget extends StatelessWidget {
  final Map<String, dynamic> feature;
  const CardWidget({Key? key, required this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Fixed card width.
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.none, // Allow the overflowing image.
        child: Container(
          decoration: BoxDecoration(
            color:
                feature["color"], // Use the provided color as the background.
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none, // Allows the image to overflow.
            alignment: Alignment.topCenter,
            children: [
              // Overflowing image positioned above the card.
              Positioned(
                top: -75, // Adjust this value to control overflow.
                child: Image.asset(
                  feature["icon"],
                  width: 170,
                  height: 170,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                  ), // Space for the icon overflow.
                  Text(
                    feature["text"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 37, 36, 35),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      feature["description"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 41, 40, 39),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberCircle extends StatelessWidget {
  final String name;
  const MemberCircle({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the first letter from the name
    String initial = name[0];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color.fromARGB(255, 85, 76, 56),
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required IconData icon,
  required String hintText,
  bool isPassword = false,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    maxLines: maxLines,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 59, 47, 30)),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 59, 47, 30),
        fontSize: 14, // Smaller font size for hint text
      ),
      filled: true,
      fillColor: Colors.brown[50],
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10, // Reduce vertical padding to lower the height
        horizontal: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
