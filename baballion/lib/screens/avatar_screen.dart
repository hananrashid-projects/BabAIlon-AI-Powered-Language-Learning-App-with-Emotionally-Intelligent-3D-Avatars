// import 'package:flutter/material.dart';

// class AvatarsScreen extends StatefulWidget {
//   const AvatarsScreen({super.key});

//   @override
//   _AvatarsScreenState createState() => _AvatarsScreenState();
// }

// class _AvatarsScreenState extends State<AvatarsScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<String> _names = ['Sam', 'Alice', 'David', 'Blair', 'Lexi'];
//   final List<String> _languages = [
//     'English',
//     'Arabic',
//     'Spanish',
//     'Korean',
//     'Japanese'
//   ];
//   List<int> _filteredIndexes = []; // Store filtered indexes

//   @override
//   void initState() {
//     super.initState();
//     _filteredIndexes = List.generate(_names.length, (index) => index);
//     _searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     String search = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredIndexes = List.generate(_names.length, (index) => index)
//           .where((index) => _languages[index].toLowerCase().contains(search))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFEFFF7),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Top header container with image and text
//             Container(
//               color: Colors.black,
//               height: MediaQuery.of(context).size.height / 3,
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: Image.asset(
//                       'assets/images/babailon_page3.jpg',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     left: 16.0,
//                     top: 70.0,
//                     child: Text(
//                       '     Welcome to the Babailon world!\n    Every avatar represents a language.\n Don\'t wait to learn the language you want.',
//                       style: const TextStyle(
//                         fontFamily: 'AptosNarrow',
//                         fontSize: 14,
//                         color: Colors.white,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 13),
//             // Search text field
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: _buildTextField(
//                 controller: _searchController,
//                 icon: Icons.search,
//                 hintText: 'Search Language',
//               ),
//             ),
//             SizedBox(height: 20),
//             // Grid of avatars
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: GridView.builder(
//                 shrinkWrap: true, // Ensure grid only takes the space it needs
//                 physics:
//                     NeverScrollableScrollPhysics(), // Disable scrolling here
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: _filteredIndexes.length,
//                 itemBuilder: (context, index) {
//                   int avatarIndex = _filteredIndexes[index];
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 75,
//                         backgroundImage: AssetImage(
//                             'assets/images/avatar${avatarIndex + 1}.PNG'),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.call,
//                             color: Colors.black,
//                           ),
//                           const SizedBox(width: 8),
//                           Column(
//                             children: [
//                               Text(
//                                 _names[avatarIndex],
//                                 style: const TextStyle(
//                                   color: Color(0xFF915050),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 _languages[avatarIndex],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build search text field with icons
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required IconData icon,
//     required String hintText,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Color(0xFF915050)),
//         hintText: hintText,
//         hintStyle: TextStyle(color: Color(0xFF915050)),
//         filled: true,
//         fillColor: Colors.brown[50],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';

class AvatarsScreen extends StatefulWidget {
  const AvatarsScreen({super.key});

  @override
  _AvatarsScreenState createState() => _AvatarsScreenState();
}

class _AvatarsScreenState extends State<AvatarsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _names = ['Sam', 'Alice', 'David', 'Blair', 'Lexi'];
  final List<String> _languages = [
    'English',
    'Arabic',
    'Spanish',
    'Korean',
    'Japanese'
  ];
  List<int> _filteredIndexes = []; // Store filtered indexes

  @override
  void initState() {
    super.initState();
    _filteredIndexes = List.generate(_names.length, (index) => index);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String search = _searchController.text.toLowerCase();
    setState(() {
      _filteredIndexes = List.generate(_names.length, (index) => index)
          .where((index) => _languages[index].toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFF7),
      body: Column(
        children: [
          SizedBox(height: 13),
          // Search text field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildTextField(
              controller: _searchController,
              icon: Icons.search,
              hintText: 'Search Language',
            ),
          ),
          SizedBox(height: 20),
          // Grid of avatars
          Flexible(
            child: GridView.builder(
              shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(), 
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filteredIndexes.length,
              itemBuilder: (context, index) {
                int avatarIndex = _filteredIndexes[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: AssetImage(
                          'assets/images/avatar${avatarIndex + 1}.PNG'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Text(
                              _names[avatarIndex],
                              style: const TextStyle(
                                color: Color(0xFF915050),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _languages[avatarIndex],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build search text field with icons
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF915050)),
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF915050)),
        filled: true,
        fillColor: Colors.brown[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
