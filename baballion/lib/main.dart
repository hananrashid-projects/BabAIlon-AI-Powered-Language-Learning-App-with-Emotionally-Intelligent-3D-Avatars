import 'package:babellion/3D_AI_Avatar_frontend/src/games/sentence_scramble.dart';
import 'package:babellion/firebase_options.dart';
import 'package:babellion/routes/app_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const apiKey = 'AIzaSyD8l5nDB8hUD83Ot8wVvxZTLQeazFHLmEE';

void main() async {
  Gemini.init(apiKey: apiKey);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Babailon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
// import 'package:flutter/material.dart';
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // Later you can add Firebase initialization and ProviderScope if needed.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Babellion',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // ScrollController to track the horizontal scroll offset.
//   final ScrollController _scrollController = ScrollController();

//   // List of features used to build cards.
//   final List<Map<String, dynamic>> features = [
//     {
//       "text": "AI-Driven Avatar",
//       "icon": "assets/images/icon1.png",
//       "description":
//           "Develop 3D avatars with emotional expressions and distinct personalities to simulate human-like interactions.",
//       "color": Color(0xFFD8D6D6),
//     },
//     {
//       "text": "Real-Time Feedback",
//       "icon": "assets/images/icon2.png",
//       "description":
//           "Immediate AI feedback helps users refine language skills effectively.",
//       "color": Color(0xFFC8B8AB),
//     },
//     {
//       "text": "Adaptive Conversational Fluency",
//       "icon": "assets/images/icon3.png",
//       "description": "Dynamic conversations tailored to user progress.",
//       "color": Color(0xFFDFDFC2),
//     },
//     {
//       "text": "User Progress Tracking",
//       "icon": "assets/images/icon4.png",
//       "description":
//           "A dashboard showing fluency metrics, history, and feedback with ranks.",
//       "color": Color(0xFFE8D2DE),
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // Rebuild widget on scroll updates to update scale factors.
//     _scrollController.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Define card width and horizontal padding.
//     double cardWidth = 220;
//     double horizontalPadding = 8.0;
//     double cardTotalWidth = cardWidth + horizontalPadding * 2;
//     double viewportWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Babellion Home'),
//       ),
//       backgroundColor: Color(0xFFFEFFF7),
//       body: Center(
//         child: SizedBox(
//           height: 280,
//           child: ListView.builder(
//             controller: _scrollController,
//             scrollDirection: Axis.horizontal,
//             physics: PageScrollPhysics(), // Provides a snapping effect.
//             clipBehavior: Clip.none, // Allow card overflow.
//             itemCount: features.length,
//             itemBuilder: (context, index) {
//               // Calculate the current scroll offset.
//               double currentOffset =
//                   _scrollController.hasClients ? _scrollController.offset : 0;
//               // Compute the center of this card.
//               double cardCenter = index * cardTotalWidth + cardTotalWidth / 2;
//               // Compute the center of the viewport.
//               double viewportCenter = currentOffset + viewportWidth / 2;
//               // Calculate the distance from this card's center to the viewport's center.
//               double distance = (viewportCenter - cardCenter).abs();
//               // Adjust the scale: full scale at center (1.0) and scaled down to 0.7 when far away.
//               double scale = 1.0 - (distance / cardTotalWidth) * 0.3;
//               scale = scale.clamp(0.7, 1.0);

//               return Padding(
//                 padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                 child: Transform.scale(
//                   scale: scale,
//                   child: CardWidget(feature: features[index]),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CardWidget extends StatelessWidget {
//   final Map<String, dynamic> feature;
//   const CardWidget({Key? key, required this.feature}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 250, // Fixed card width.
//       child: Card(
//         elevation: 8.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         clipBehavior: Clip.none, // Allow the overflowing image.
//         child: Container(
//           decoration: BoxDecoration(
//             color:
//                 feature["color"], // Use the provided color as the background.
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 blurRadius: 10,
//                 offset: Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Stack(
//             clipBehavior: Clip.none, // Allows the image to overflow.
//             alignment: Alignment.topCenter,
//             children: [
//               // Overflowing image positioned above the card.
//               Positioned(
//                 top: -75, // Adjust this value to control overflow.
//                 child: Image.asset(
//                   feature["icon"],
//                   width: 170,
//                   height: 170,
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 70,
//                   ), // Space for the icon overflow.
//                   Text(
//                     feature["text"],
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 37, 36, 35),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Text(
//                       feature["description"],
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Color.fromARGB(255, 41, 40, 39),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
