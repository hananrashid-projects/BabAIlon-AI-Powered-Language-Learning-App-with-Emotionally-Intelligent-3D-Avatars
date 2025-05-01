import 'package:babellion/providers/user_provider.dart';
import 'package:babellion/routes/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light brownish background
      appBar: AppBar(
        title: Center(
          child: const Text(
            'My Profile',
            style: TextStyle(
              color: Color.fromARGB(255, 92, 57, 11),
              fontWeight: FontWeight.bold, // This makes the text bold
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 243, 242, 241), // Light brown app bar
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 102, 76, 3)),
      ),
      body: SingleChildScrollView(  // Make the screen scrollable
        child: Center(
          child: userState.when(
            data: (userData) {
              final email = userData?['email'] ?? 'No email provided';
              final fullName = userData?['fullName'] ?? 'No full name provided';
              final dateOfBirth = userData?['dateOfBirth'] ?? 'No date of birth provided';
              final bio = userData?['bio'] ?? 'This user hasn\'t added a bio yet'; // Default bio text

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 230, 171, 11), // Light brown app bar

                      radius: 50,
                      backgroundImage: AssetImage('assets/images/icon2.png'), // Replace with real path or use NetworkImage
                    ),
                    const SizedBox(height: 20),
                    Text(
                      fullName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6E4B3A)), // Dark brown text color
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _infoTile(title: "Bio", value: "passionate about learning!"),
                    _infoTile(title: "Date of Birth", value: dateOfBirth),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Edit Profile or Settings screen
                      },
                      child: const Text('Edit Profile',    style: TextStyle(color: Colors.white), // Set text color to white
),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 230, 171, 11), // Button color
                        // textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Skills Section (Replacing Recent Activities)
                    _sectionTitle('Skills'),
                    _skillsTile('English', 'Intermediate'),
                    _skillsTile('Japanese', 'Advanced'),
                    _skillsTile('Russian', 'Beginner'),
                    const SizedBox(height: 30),
                    // Stats Section
                    // _sectionTitle('Profile Stats'),
                    // _statsTile('Achievements', '5'),
                    // _statsTile('Followers', '120'),
                    // _statsTile('Following', '80'),
                    const SizedBox(height: 10),
                    // Sign Out Button
                    ElevatedButton(
                      onPressed: () async {
await FirebaseAuth.instance.signOut();
    context.go(AppRouter.login.path);                      },
                      child: const Text('Sign Out',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 230, 171, 11), // Red button for sign-out
                        // textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                                        const SizedBox(height: 30),

                  ],
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => const Text('Error loading user data'),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 221, 218, 213), // Lighter brown for info tiles
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6E4B3A)), // Dark brown text for title
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF6E4B3A)), // Dark brown text for value
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6E4B3A)),
      ),
    );
  }

  Widget _skillsTile(String skill, String level) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 221, 218, 213), // Lighter brown for skills tiles
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.star_border, color: Color(0xFF6E4B3A)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                skill,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6E4B3A)),
              ),
              Text(
                level,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statsTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 221, 218, 213), // Lighter brown for stats tiles
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6E4B3A)),
          ),
          Text(
            value,
            style: const TextStyle(color: Color(0xFF6E4B3A)),
          ),
        ],
      ),
    );
  }
}
