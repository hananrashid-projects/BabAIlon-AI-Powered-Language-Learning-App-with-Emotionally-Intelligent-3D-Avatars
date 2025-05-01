// // import 'package:babellion/routes/app_route.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';

// // class SignUpScreen extends StatefulWidget {
// //   SignUpScreen({super.key});

// //   @override
// //   _SignUpScreenState createState() => _SignUpScreenState();
// // }

// // class _SignUpScreenState extends State<SignUpScreen> {
// //   final TextEditingController _fullNameController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _confirmPasswordController =
// //       TextEditingController();
// //   DateTime? _selectedDate;

// //   Future<void> _signUp(BuildContext context) async {
// //     final fullName = _fullNameController.text;
// //     final email = _emailController.text + '@babailon.com';
// //     final password = _passwordController.text;
// //     final confirmPassword = _confirmPasswordController.text;

// //     if (fullName.isEmpty ||
// //         email.isEmpty ||
// //         password.isEmpty ||
// //         confirmPassword.isEmpty ||
// //         _selectedDate == null) {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text('All fields must be filled.')));
// //       return;
// //     }

// //     if (password != confirmPassword) {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text('Passwords do not match')));
// //       return;
// //     }

// //     try {
// //       UserCredential userCredential = await FirebaseAuth.instance
// //           .createUserWithEmailAndPassword(email: email, password: password);

// //       if (userCredential.user != null) {
// //         await FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(userCredential.user!.uid)
// //             .set({
// //           'fullName': fullName,
// //           'email': email,
// //           'dateOfBirth': _selectedDate?.toIso8601String(),
// //         });

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //               content:
// //                   Text('Congratulations! You have successfully signed up!')),
// //         );

// //         context.go(AppRouter.login.path);
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Sign-up failed: ${e.toString()}')));
// //     }
// //   }

// //   void _selectDate(BuildContext context) async {
// //     DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(1900),
// //       lastDate: DateTime.now(),
// //       builder: (BuildContext context, Widget? child) {
// //         return Theme(
// //           data: ThemeData.light().copyWith(
// //             colorScheme: ColorScheme.light(
// //               primary: Color(0xFF915050),
// //               onPrimary: Colors.white,
// //               surface: Color(0xFFFEFFF7),
// //               onSurface: Color(0xFF915050),
// //             ),
// //             dialogBackgroundColor: Color(0xFFFEFFF7),
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //     if (pickedDate != null && pickedDate != _selectedDate) {
// //       setState(() {
// //         _selectedDate = pickedDate;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xFFFEFFF7),
// //       body: SingleChildScrollView(
// //         child: Center(
// //           child: ConstrainedBox(
// //             constraints: BoxConstraints(maxWidth: 500),
// //             child: Container(
// //               color: Color(0xFFFEFFF7),
// //               padding: EdgeInsets.all(30),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Image.asset(
// //                     'assets/images/logo.PNG',
// //                     width: 200,
// //                     height: 200,
// //                   ),
// //                   SizedBox(height: 20),
// //                   Text(
// //                     'Sign Up',
// //                     style: TextStyle(
// //                       fontSize: 24,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF915050),
// //                     ),
// //                   ),
// //                   SizedBox(height: 20),
// //                   _buildTextField(
// //                     controller: _fullNameController,
// //                     icon: Icons.person,
// //                     hintText: 'Full Name',
// //                   ),
// //                   SizedBox(height: 20),
// //                   _buildEmailField(),
// //                   SizedBox(height: 20),
// //                   _buildTextField(
// //                     controller: _passwordController,
// //                     icon: Icons.lock,
// //                     hintText: 'Password',
// //                     isPassword: true,
// //                   ),
// //                   SizedBox(height: 20),
// //                   _buildTextField(
// //                     controller: _confirmPasswordController,
// //                     icon: Icons.lock,
// //                     hintText: 'Confirm Password',
// //                     isPassword: true,
// //                   ),
// //                   SizedBox(height: 20),
// //                   GestureDetector(
// //                     onTap: () => _selectDate(context),
// //                     child: Container(
// //                       padding:
// //                           EdgeInsets.symmetric(vertical: 15, horizontal: 20),
// //                       decoration: BoxDecoration(
// //                         color: Colors.brown[50],
// //                         borderRadius: BorderRadius.circular(30),
// //                       ),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Text(
// //                             _selectedDate == null
// //                                 ? 'Select Date of Birth'
// //                                 : _selectedDate!
// //                                     .toLocal()
// //                                     .toString()
// //                                     .split(' ')[0],
// //                             style: TextStyle(color: Color(0xFF915050)),
// //                           ),
// //                           Icon(Icons.calendar_today, color: Color(0xFF915050)),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(height: 20),
// //                   ElevatedButton(
// //                     onPressed: () => _signUp(context),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.brown[400],
// //                       padding:
// //                           EdgeInsets.symmetric(horizontal: 100, vertical: 15),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(30),
// //                       ),
// //                     ),
// //                     child: Text(
// //                       'Sign Up',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(height: 20),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         "Already have an account? ",
// //                         style: TextStyle(
// //                           color: Color(0xFF915050),
// //                         ),
// //                       ),
// //                       GestureDetector(
// //                         onTap: () => context.go(AppRouter.login.path),
// //                         child: Text(
// //                           'Log in',
// //                           style: TextStyle(
// //                             color: Color(0xFF915050),
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEmailField() {
// //     return TextField(
// //       controller: _emailController,
// //       decoration: InputDecoration(
// //         prefixIcon: Icon(Icons.email, color: Color(0xFF915050)),
// //         hintText: 'email',
// //         suffixText: '@babailon.com',
// //         hintStyle: TextStyle(color: Color(0xFF915050)),
// //         filled: true,
// //         fillColor: Colors.brown[50],
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(30),
// //           borderSide: BorderSide.none,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // Widget _buildTextField({
// //   required TextEditingController controller,
// //   required IconData icon,
// //   required String hintText,
// //   bool isPassword = false,
// // }) {
// //   return TextField(
// //     controller: controller,
// //     obscureText: isPassword,
// //     decoration: InputDecoration(
// //       prefixIcon: Icon(
// //         icon,
// //         color: Color(0xFF915050),
// //       ),
// //       hintText: hintText,
// //       hintStyle: TextStyle(color: Color(0xFF915050)),
// //       filled: true,
// //       fillColor: Colors.brown[50],
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(30),
// //         borderSide: BorderSide.none,
// //       ),
// //     ),
// //   );
// // }
// import 'package:babellion/models/dashboard_data.dart';
// import 'package:babellion/routes/app_route.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class SignUpScreen extends StatefulWidget {
//   SignUpScreen({super.key});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   DateTime? _selectedDate;

//   Future<void> _signUp(BuildContext context) async {
//     final fullName = _fullNameController.text;
//     final email = _emailController.text + '@babailon.com';
//     final password = _passwordController.text;
//     final confirmPassword = _confirmPasswordController.text;

//     if (fullName.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty ||
//         _selectedDate == null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('All fields must be filled.')));
//       return;
//     }

//     if (password != confirmPassword) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Passwords do not match')));
//       return;
//     }

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       if (userCredential.user != null) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .set({
//           'fullName': fullName,
//           'email': email,
//           'dateOfBirth': _selectedDate?.toIso8601String(),
//         });
//         final dashboardName = fullName;
//         final dashboardEmail = email;
//         List<String> languages = ['English', 'Spanish', 'Korean', 'Japanese'];

//         List<DashboardData> dashboardDataList = languages.map((language) {
//           return DashboardData(
//             "",
//             email,
//             language,
//             [],
//           );
//         }).toList();

//         var dashboardDataRef =
//             FirebaseFirestore.instance.collection('dashboardDatas');

//         // for (var dashboardData in dashboardDataList) {
//         //   await dashboardDataRef.add(dashboardData.toMap());
//         // }

//         for (var dashboardData in dashboardDataList) {
//           var docRef = await dashboardDataRef.add(dashboardData.toMap());
//           await docRef.update({'id': docRef.id});
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text('Congratulations! You have successfully signed up!')),
//         );

//         context.go(AppRouter.login.path);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Sign-up failed: ${e.toString()}')));
//     }
//   }

//   void _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Color(0xFF915050),
//               onPrimary: Colors.white,
//               surface: Color(0xFFFEFFF7),
//               onSurface: Color(0xFF915050),
//             ),
//             dialogBackgroundColor: Color(0xFFFEFFF7),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFEFFF7),
//       body: Center(
//         // Center the entire body content
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//                 maxWidth: 500), // Limit the max width for responsiveness
//             child: Container(
//               color: Color(0xFFFEFFF7),
//               padding: EdgeInsets.all(30),
//               child: Column(
//                 mainAxisAlignment:
//                     MainAxisAlignment.center, // Vertically center the column
//                 crossAxisAlignment: CrossAxisAlignment
//                     .center, // Horizontally center the children in the column
//                 children: [
//                   Image.asset(
//                     'assets/images/logo.PNG',
//                     width: 200,
//                     height: 200,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF915050),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   _buildTextField(
//                     controller: _fullNameController,
//                     icon: Icons.person,
//                     hintText: 'Full Name',
//                   ),
//                   SizedBox(height: 20),
//                   _buildEmailField(),
//                   SizedBox(height: 20),
//                   _buildTextField(
//                     controller: _passwordController,
//                     icon: Icons.lock,
//                     hintText: 'Password',
//                     isPassword: true,
//                   ),
//                   SizedBox(height: 20),
//                   _buildTextField(
//                     controller: _confirmPasswordController,
//                     icon: Icons.lock,
//                     hintText: 'Confirm Password',
//                     isPassword: true,
//                   ),
//                   SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () => _selectDate(context),
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.brown[50],
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _selectedDate == null
//                                 ? 'Select Date of Birth'
//                                 : _selectedDate!
//                                     .toLocal()
//                                     .toString()
//                                     .split(' ')[0],
//                             style: TextStyle(color: Color(0xFF915050)),
//                           ),
//                           Icon(Icons.calendar_today, color: Color(0xFF915050)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => _signUp(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.brown[400],
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: Text(
//                       'Sign Up',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Already have an account? ",
//                         style: TextStyle(
//                           color: Color(0xFF915050),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => context.go(AppRouter.login.path),
//                         child: Text(
//                           'Log in',
//                           style: TextStyle(
//                             color: Color(0xFF915050),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailField() {
//     return TextField(
//       controller: _emailController,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.email, color: Color(0xFF915050)),
//         hintText: 'email',
//         suffixText: '@babailon.com',
//         hintStyle: TextStyle(color: Color(0xFF915050)),
//         filled: true,
//         fillColor: Colors.brown[50],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// Widget _buildTextField({
//   required TextEditingController controller,
//   required IconData icon,
//   required String hintText,
//   bool isPassword = false,
// }) {
//   return TextField(
//     controller: controller,
//     obscureText: isPassword,
//     decoration: InputDecoration(
//       prefixIcon: Icon(
//         icon,
//         color: Color(0xFF915050),
//       ),
//       hintText: hintText,
//       hintStyle: TextStyle(color: Color(0xFF915050)),
//       filled: true,
//       fillColor: Colors.brown[50],
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: BorderSide.none,
//       ),
//     ),
//   );
// }
import 'package:babellion/models/dashboard.dart';
import 'package:babellion/providers/dashboard_provider.dart';
import 'package:babellion/routes/app_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  DateTime? _selectedDate;

  Future<void> _signUp(BuildContext context) async {
    final fullName = _fullNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields must be filled.')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': fullName,
          'email': email,
          'dateOfBirth': _selectedDate?.toIso8601String(),
        });

        final dashboardName = fullName;
        final dashboardEmail = email;
        final dashboardState = ref.watch(dashboardNotifierProvider);
        ref.read(dashboardNotifierProvider.notifier).addDashboard(Dashboard(
              '',
              email,
              [],
            ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Congratulations! You have successfully signed up!')),
        );

        context.go(AppRouter.login.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-up failed: ${e.toString()}')));
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF915050),
              onPrimary: Colors.white,
              surface: Color(0xFFFEFFF7),
              onSurface: Color(0xFF915050),
            ),
            dialogBackgroundColor: Color(0xFFFEFFF7),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFEFFF7),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.PNG',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF915050),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _fullNameController,
                    icon: Icons.person,
                    hintText: 'Full Name',
                  ),
                  SizedBox(height: 20),
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    icon: Icons.lock,
                    hintText: 'Confirm Password',
                    isPassword: true,
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.brown[50],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Select Date of Birth'
                                : _selectedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                            style: TextStyle(color: Color(0xFF915050)),
                          ),
                          Icon(Icons.calendar_today, color: Color(0xFF915050)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signUp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[400],
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFF915050),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRouter.login.path),
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Color(0xFF915050),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: Color(0xFF915050)),
        hintText: 'email',
        hintStyle: TextStyle(color: Color(0xFF915050)),
        filled: true,
        fillColor: Colors.brown[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required IconData icon,
  required String hintText,
  bool isPassword = false,
}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Color(0xFF915050),
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: Color(0xFF915050)),
      filled: true,
      fillColor: Colors.brown[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
