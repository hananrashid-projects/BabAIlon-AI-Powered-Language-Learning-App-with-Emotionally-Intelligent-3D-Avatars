import 'package:babellion/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class ShellScreen extends StatefulWidget {
  final Widget? child;

  const ShellScreen({super.key, this.child});

  @override
  _ShellScreenState createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      drawer: isWideScreen ? null : _buildDrawer(),
      body: Row(
        children: [
          // if (isWideScreen) _buildSideBar(),
          Expanded(
            child: widget.child ?? Container(),
          ),
        ],
      ),
      // backgroundColor: Color.fromARGB(255, 251, 250, 250),
      bottomNavigationBar: isWideScreen ? null : _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      // backgroundColor: Color.fromARGB(255, 251, 250, 250),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: const Color.fromARGB(255, 244, 243, 243),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Color.fromARGB(255, 97, 68, 68),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideBar() {
    return Container(
      width: 250,
      color: Color(0xFFEFD4D4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Quick Access',
              style: TextStyle(
                color: Color.fromARGB(255, 97, 68, 68),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              context.go(AppRouter.home.path);
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              context.go(AppRouter.dashboard.path);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Avatars'),
            onTap: () {
              context.go(AppRouter.avatars.path);
            },
          ),
          ListTile(
            leading: Icon(Icons.score),
            title: Text('Scoreboard'),
            onTap: () {
              context.go(AppRouter.scoreboard.path);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              context.go(AppRouter.profile.path);
            },
          ),
        ],
      ),
    );
  }

//   Widget _buildBottomNavigationBar() {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(20.0),
//         topRight: Radius.circular(20.0),
//       ),
//       child: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor:
//             const Color.fromARGB(255, 238, 218, 200), // Background color here
//         currentIndex: _currentIndex,
//         selectedItemColor: const Color.fromARGB(255, 74, 52, 52),
//         unselectedItemColor: Colors.black,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Avatars',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.score),
//             label: 'Scoreboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Profile',
//           ),
//         ],
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });

//           switch (index) {
//             case 0:
//               context.go(AppRouter.home.path);
//               break;
//             case 1:
//               context.go(AppRouter.dashboard.path);
//               break;
//             case 2:
//               context.go(AppRouter.avatars.path);
//               break;
//             case 3:
//               context.go(AppRouter.scoreboard.path);
//               break;
//             case 4:
//               context.go(AppRouter.profile.path);
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          const Color.fromARGB(255, 238, 218, 200), // Background color here
      // const Color.fromARGB(255, 245, 237, 198),
      currentIndex: _currentIndex,
      selectedItemColor: const Color.fromARGB(255, 74, 52, 52),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'Global',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.score),
          label: 'Scoreboard',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.account_circle),
        //   label: 'Profile',
        // ),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            context.go(AppRouter.home.path);
            break;
          case 1:
            context.go(AppRouter.dashboard.path);
            break;
          case 2:
            // context.go(AppRouter.avatars.path);
            String url = Uri.base.resolve("assets/web/index.html").toString();
            html.window.location.href = url; // Open as a full-page
            break;
          case 3:
            context.go(AppRouter.scoreboard.path);
            break;
          // case 4:
          //   context.go(AppRouter.profile.path);

          // break;
        }
      },
    );
  }
}
