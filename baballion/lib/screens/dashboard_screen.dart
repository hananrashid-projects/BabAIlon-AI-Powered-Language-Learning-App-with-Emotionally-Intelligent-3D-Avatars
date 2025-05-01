import 'package:babellion/models/language.dart';
import 'package:babellion/models/score.dart';
import 'package:babellion/screens/flutter_radar_chart.dart';
import 'package:babellion/screens/monthly_time_series.dart';
import 'package:babellion/screens/yearly_time_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:babellion/providers/user_provider.dart';
import 'package:babellion/providers/dashboard_provider.dart';
import 'package:intl/intl.dart';
import 'package:babellion/models/feedback_history.dart';

// import 'dart:ui';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static List<int> ticks = [
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100
  ]; // Your tick values

  static List<String> features = [
    'Vocabulary',
    'Grammar',
    'Pronunciation',
    'Fluency'
  ];
  static List<String> graphNames = [
    'Previous Score',
    'Latest Score',
  ];
  static List<double> monthlyscore = [0, 1, 2, 3, 1, 2, 3, 1, 2, 2, 2];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final allScoreForUser = ref.watch(dashboardNotifierProvider.notifier);

    final userEmail = userState.when(
      data: (userData) => userData?['email'],
      loading: () => null,
      error: (error, stackTrace) => null,
    );
    if (userEmail == null) return CircularProgressIndicator();

    final languages = [
      "English",
      "Spanish",
      "Mandarin Chinese",
      "Hindi",
      "Arabic",
      "French",
      "Russian",
      "Portuguese",
      "German",
      "Japanese",
      "Korean",
      "Italian",
      "Dutch",
      "Turkish",
      "Vietnamese",
      "Polish",
      "Bengali",
      "Punjabi",
      "Swahili",
      "Tamil",
      "Telugu",
      "Urdu",
      "Greek",
      "Hebrew",
      "Thai",
      "Swedish",
      "Norwegian",
      "Danish",
      "Finnish",
      "Hungarian",
      "Czech",
      "Romanian",
      "Indonesian",
      "Malay",
      "Filipino",
      "Ukrainian",
      "Serbian",
      "Croatian",
      "Bulgarian",
      "Afrikaans",
      "Slovak",
      "Albanian",
      "Lithuanian",
      "Latvian",
      "Estonian",
      "Icelandic",
      "Maltese",
      "Georgian",
      "Armenian",
      "Kazakh",
      "Azerbaijani",
    ];

    String selectedLanguages = languages.first;
    String selectedLanguage = ref.watch(selectedLanguageProvider);
    TextEditingController dateController = TextEditingController();
    bool isMonthlySelected = false; // Toggle between Monthly and Yearly

    String _selectedDate = '';
    String _mainselectedDate = '';
    final selectedDate =
        ref.watch(selectedDateProvider); // Tracks selected date

    DateTime _date = DateTime.now();
    void _showLanguageSelectionDialog() async {
      if (userEmail == null) return;

      final currentLanguages = await ref
          .read(dashboardNotifierProvider.notifier)
          .observeLanguages(userEmail)
          .first;

      final currentLanguageList =
          currentLanguages.map((language) => language.language).toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose a language", style: GoogleFonts.poppins()),
            content: SizedBox(
              height: 300,
              width: 250,
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(languages[index], style: GoogleFonts.poppins()),
                    onTap: () {
                      if (!currentLanguageList.contains(languages[index])) {
                        final language = Language(languages[index], [], []);
                        ref
                            .read(dashboardNotifierProvider.notifier)
                            .addLanguageToDashboard(userEmail, language);
                      }
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    }

    void _showAddScoreDialog() {
      if (userEmail == null) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          String selectedLanguage = languages.first;
          TextEditingController dateController = TextEditingController();
          // TextEditingController dateOnlyController = TextEditingController();
          TextEditingController vocabController = TextEditingController();
          TextEditingController fluencyController = TextEditingController();
          TextEditingController grammarController = TextEditingController();
          TextEditingController pronunciationController =
              TextEditingController();

          return AlertDialog(
            title: Text("Add Score", style: GoogleFonts.poppins()),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    items: languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang, style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedLanguage = value!;
                    },
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: "Date & Time",
                      suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today,
                              color: Color.fromARGB(255, 233, 190, 97)),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != _date) {
                              _date = picked;
                              _selectedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                            }
                            // DateTime? pickedDate = await showDatePicker(
                            //   context: context,
                            //   initialDate: DateTime.now(),
                            //   firstDate: DateTime(2000),
                            //   lastDate: DateTime(2101),
                            // );

                            // if (pickedDate != null) {
                            //   DateTime now =
                            //       DateTime.now(); // Get the current exact time

                            //   DateTime finalDateTime = DateTime(
                            //     pickedDate.year,
                            //     pickedDate.month,
                            //     pickedDate.day,
                            //     now.hour,
                            //     now.minute,
                            //     now.second,
                            //   );

                            //   String formattedDateTime =
                            //       "${DateFormat('yyyy-MM-dd').format(finalDateTime)} : ${DateFormat('HH:mm:ss').format(finalDateTime)}";

                            dateController.text = _selectedDate;
                            // }
                          }),
                    ),
                    readOnly: true,
                  ),
                  TextField(
                      controller: vocabController,
                      decoration:
                          InputDecoration(labelText: "Vocabulary Score"),
                      keyboardType: TextInputType.number),
                  TextField(
                      controller: fluencyController,
                      decoration: InputDecoration(labelText: "Fluency Score"),
                      keyboardType: TextInputType.number),
                  TextField(
                      controller: grammarController,
                      decoration: InputDecoration(labelText: "Grammar Score"),
                      keyboardType: TextInputType.number),
                  TextField(
                      controller: pronunciationController,
                      decoration:
                          InputDecoration(labelText: "Pronunciation Score"),
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel", style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () {
                  // Set date if not selected
                  String date = _selectedDate.isEmpty
                      ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                      : _selectedDate;
                  final score = Score(
                    date,
                    int.tryParse(vocabController.text) ?? 0,
                    int.tryParse(fluencyController.text) ?? 0,
                    int.tryParse(grammarController.text) ?? 0,
                    int.tryParse(pronunciationController.text) ?? 0,
                  );
                  ref
                      .read(dashboardNotifierProvider.notifier)
                      .addScoreToLanguage(userEmail, selectedLanguage, score);

                  Navigator.of(context).pop();
                  ref.read(selectedDateScoresProvider.notifier).state = ref
                          .read(dashboardNotifierProvider.notifier)
                          .getScoresByDate(
                              userEmail, selectedLanguage, _mainselectedDate)
                      as List<Score>;
                },
                child: Text("Add",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }

    void _showAddFeedbackDialog() {
      final languageController = TextEditingController();
      final feedbackController = TextEditingController();
      final dateController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Feedback for Language"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Language Dropdown
                StreamBuilder<List<Language>>(
                  stream: ref
                      .read(dashboardNotifierProvider.notifier)
                      .observeLanguages(userEmail ?? ""),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      // Print message to the console when no data is available
                      print('There is no data');
                      return Center(
                        child: Text(
                          'No data available', // Display a message when there's no data
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      );
                    }

                    final languages =
                        snapshot.data!.map((lang) => lang.language).toList();

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Select Language'),
                      value: selectedLanguage,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          ref.read(selectedLanguageProvider.notifier).state =
                              newValue;
                        }
                      },
                      items: languages.map((String language) {
                        return DropdownMenuItem<String>(
                          value: language,
                          child: Text(language),
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 16),

                // Feedback Text Field
                TextField(
                  controller: feedbackController,
                  decoration: InputDecoration(labelText: "Enter Feedback"),
                ),
                SizedBox(height: 16),

                // Date Picker
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: "Select Date"),
                  onTap: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null) {
                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                      dateController.text = formattedDate;
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // Get values from controllers
                  final feedback = feedbackController.text;
                  final date = dateController.text;

                  // Add feedback for the selected language
                  ref
                      .read(dashboardNotifierProvider.notifier)
                      .addFeedbackForLanguage(userEmail ?? "",
                          selectedLanguage ?? "", feedback, selectedDate ?? "");

                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text("Add Feedback"),
              ),
            ],
          );
        },
      );
    }

    TextEditingController dateOnlyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFFF7),
        title: userState.when(
          data: (userData) => Center(
            child: Text(
              userData != null
                  // ? "Dashboard for ${userData['fullName'] ?? 'User'}"
                  ? "         Dashboard"
                  : "Dashboard",
              style: GoogleFonts.poppins(
                color: Color.fromARGB(255, 233, 190, 97),
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
          loading: () => Text("Loading...", style: GoogleFonts.poppins()),
          error: (error, stackTrace) =>
              Text("Error", style: GoogleFonts.poppins()),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Color.fromARGB(255, 233, 190, 97)),
            onPressed: _showLanguageSelectionDialog,
            tooltip: "Add Language",
          ),
          IconButton(
            icon: Icon(Icons.score, color: Color.fromARGB(255, 233, 190, 97)),
            onPressed: _showAddScoreDialog,
            tooltip: "Add Score",
          ),
        ],
      ),
      backgroundColor: Color(0xFFFEFFF7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Language Growth Overview",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StreamBuilder<List<Language>>(
                      stream: ref
                          .read(dashboardNotifierProvider.notifier)
                          .observeLanguages(userEmail ?? ""),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: Text(
                                  "No data available. No languages have been selected, no scores have been recorded, and no feedback has been provided.",
                                  style: GoogleFonts.poppins()));
                        final userLanguages = snapshot.data!
                            .map((lang) => lang.language)
                            .toList();

                        final currentLanguage =
                            userLanguages.contains(selectedLanguage)
                                ? selectedLanguage
                                : (userLanguages.isNotEmpty
                                    ? userLanguages.first
                                    : null);

                        return DropdownButton<String>(
                          value: currentLanguage,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              ref
                                  .read(selectedLanguageProvider.notifier)
                                  .state = newValue;
                            }
                          },
                          items: userLanguages
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          dropdownColor: Color(0xFFEFEFEF),
                        );
                      },
                    ),
                    SizedBox(width: 2),
                    IconButton(
                      icon: Icon(Icons.calendar_today,
                          color: Color.fromARGB(255, 233, 190, 97)),
                      onPressed: () async {
                        final selectedDate =
                            ref.read(selectedDateProvider.state).state;

                        final DateTime initialDate = selectedDate != null
                            ? DateFormat('yyyy-MM-dd').parse(selectedDate)
                            : DateTime.now();

                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData(
                                primaryColor: Color.fromARGB(255, 233, 190, 97),
                                hintColor: Color.fromARGB(255, 179, 145, 73),
                                buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary,
                                ),
                                colorScheme: ColorScheme.light(
                                  primary: Color.fromARGB(
                                      255, 233, 190, 97), // Header color
                                  onPrimary: const Color.fromARGB(255, 255, 255,
                                      255), // Text color on header
                                  onSurface:
                                      Colors.black, // Text color for days
                                ),
                                dialogBackgroundColor:
                                    Color.fromARGB(255, 233, 190, 97),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(picked);
                          dateOnlyController.text = formattedDate;
                          ref.read(selectedDateProvider.notifier).state =
                              formattedDate;
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2),

              // Scores Display
              FutureBuilder<List<Score>>(
                future: (selectedDate ?? "").isEmpty
                    ? ref
                        .read(dashboardNotifierProvider.notifier)
                        .observeScores(userEmail ?? "", selectedLanguage ?? "")
                        .first
                    : ref
                        .read(dashboardNotifierProvider.notifier)
                        .getScoresByDate(userEmail ?? "",
                            selectedLanguage ?? "", selectedDate ?? ""),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // Print message to the console when no data is available
                    print('There is no data');
                    return Center(
                      child: Text(
                        'No data available', // Display a message when there's no data
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    );
                  }

                  final scores = snapshot.data!;
                  if (scores.isEmpty) {
                    return Center(
                      child: Text(
                        "No scores available for ${selectedLanguage ?? "selected language"} on ${selectedDate ?? "selected date"}",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
                      ),
                    );
                  }

                  Score latestScore = scores.last;
                  if (selectedDate == "") {
                    print("Hello");
                  }
                  scores.sort((a, b) => a.date.compareTo(b.date));
                  debugPrint("-------------------------");

                  debugPrint("Latest: ${latestScore.toString()}");

                  int latestIndex = scores.lastIndexWhere(
                      (score) => score.date == latestScore.date);

                  Score previousScore =
                      latestIndex > 0 ? scores[latestIndex - 1] : latestScore;
                  debugPrint("previousScore: ${previousScore.toString()}");

                  if (previousScore.date == latestScore.date &&
                      previousScore.vocabularyScore ==
                          latestScore.vocabularyScore &&
                      previousScore.fluencyScore == latestScore.fluencyScore &&
                      previousScore.grammarScore == latestScore.grammarScore &&
                      previousScore.pronunciationScore ==
                          latestScore.pronunciationScore) {
                    ref
                        .read(dashboardNotifierProvider.notifier)
                        .observeScores(userEmail ?? "", selectedLanguage ?? "")
                        .first
                        .then((updatedScores) {
                      updatedScores.sort((a, b) => a.date.compareTo(b.date));
                      int latestIndex = updatedScores.lastIndexWhere((score) =>
                          score.date == latestScore.date &&
                          score.fluencyScore == latestScore.fluencyScore);
                      previousScore = (latestIndex > 0)
                          ? updatedScores[latestIndex - 1]
                          : latestScore;
                    });
                  }

                  return Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildScoreCard(
                              "Vocabulary",
                              latestScore.vocabularyScore,
                              previousScore.vocabularyScore),
                          SizedBox(width: 10),
                          buildScoreCard("Fluency", latestScore.fluencyScore,
                              previousScore.fluencyScore),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildScoreCard("Grammar", latestScore.grammarScore,
                              previousScore.grammarScore),
                          SizedBox(width: 10),
                          buildScoreCard(
                              "Pronunciation",
                              latestScore.pronunciationScore,
                              previousScore.pronunciationScore),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Growth Radar",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: RadarChartt(
                          ticks: ticks,
                          features: features,
                          data: [
                            [
                              previousScore.vocabularyScore,
                              previousScore.grammarScore,
                              previousScore.pronunciationScore,
                              previousScore.fluencyScore,
                            ],
                            [
                              latestScore.vocabularyScore,
                              latestScore.grammarScore,
                              latestScore.pronunciationScore,
                              latestScore.fluencyScore,
                            ],
                          ],
                          graphNames: graphNames,
                          reverseAxis: false,
                          graphColors: [
                            Color.fromARGB(255, 152, 123, 59),
                            Color.fromARGB(255, 233, 190, 97),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      IconButton(
                        icon: Icon(Icons.add,
                            color: Color.fromARGB(255, 233, 190, 97)),
                        onPressed:
                            _showAddFeedbackDialog, // Show the dialog to add feedback
                        tooltip: "Add Feedback",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(" Feedback History",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      FutureBuilder<List<FeedbackHistory>>(
                        future: (selectedDate ?? "").isEmpty
                            ? ref
                                .read(dashboardNotifierProvider.notifier)
                                .getFeedbackForLanguage(
                                    userEmail ?? "", selectedLanguage ?? "")
                            : ref
                                .read(dashboardNotifierProvider.notifier)
                                .getFeedbackByDate(userEmail ?? "",
                                    selectedLanguage ?? "", selectedDate ?? ""),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            // Print message to the console when no data is available
                            print('There is no data');
                            return Center(
                              child: Text(
                                'No Feedbacks available', // Display a message when there's no data
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            );
                          }

                          final feedbackList = snapshot.data!;
                          if (feedbackList.isEmpty) {
                            return Center(
                              child: Text(
                                "No feedback available for ${selectedLanguage ?? "selected language"} on ${selectedDate ?? "selected date"}",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700]),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...feedbackList.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  FeedbackHistory feedback = entry.value;
                                  bool isRight = index % 2 == 0;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: isRight
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: isRight
                                                ? Color.fromARGB(
                                                    255, 233, 190, 97)
                                                : Color.fromARGB(
                                                    255, 152, 123, 59),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            feedback.feedback,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(" Growth Time Series",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 15),

              Column(
                children: [
                  SizedBox(height: 15),

                  // Step 1: The rectangular, rounded container with divider
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        // Row with 'Monthly' and 'Yearly' buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(isMonthlySelectedProvider.notifier)
                                    .state = true;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: ref.watch(isMonthlySelectedProvider)
                                      ? const Color.fromARGB(255, 61, 46, 17)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 151, 113, 29)),
                                ),
                                child: Text(
                                  "Monthly",
                                  style: TextStyle(
                                    color: ref.watch(isMonthlySelectedProvider)
                                        ? Colors.white
                                        : const Color.fromARGB(255, 71, 53, 14),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(isMonthlySelectedProvider.notifier)
                                    .state = false;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: !ref.watch(isMonthlySelectedProvider)
                                      ? const Color.fromARGB(255, 88, 67, 21)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 151, 113, 29)),
                                ),
                                child: Text(
                                  "Yearly",
                                  style: TextStyle(
                                    color: !ref.watch(isMonthlySelectedProvider)
                                        ? Colors.white
                                        : const Color.fromARGB(255, 71, 53, 14),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Step 2: Divider
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                        ),

                        SizedBox(height: 10),

                        // Step 3: Conditional rendering for Monthly or Yearly BarChart
                        Builder(
                          builder: (context) {
                            final isMonthlySelected =
                                ref.watch(isMonthlySelectedProvider);

                            return isMonthlySelected
                                ? StreamBuilder<List<Score>>(
                                    stream: ref
                                        .read(
                                            dashboardNotifierProvider.notifier)
                                        .observeScores(userEmail ?? "",
                                            selectedLanguage ?? ""),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        // Print message to the console when no data is available
                                        print('There is no data');
                                        return Center(
                                          child: Text(
                                            'No data available', // Display a message when there's no data
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        );
                                      }

                                      final scores = snapshot.data!;
                                      if (scores.isEmpty) {
                                        return Center(
                                          child: Text(
                                            "No scores available for selected language",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[700]),
                                          ),
                                        );
                                      }

                                      // Grouping scores by year and month
                                      Map<int, List<Score>> scoresByYear = {};
                                      for (var score in scores) {
                                        int year =
                                            int.parse(score.date.split("-")[0]);
                                        if (!scoresByYear.containsKey(year)) {
                                          scoresByYear[year] = [];
                                        }
                                        scoresByYear[year]!.add(score);
                                      }

                                      List<Widget> barCharts = [];
                                      List<int> sortedYears = scoresByYear.keys
                                          .toList()
                                        ..sort((a, b) => b.compareTo(a));

                                      for (var year in sortedYears) {
                                        List<Score> yearScores =
                                            scoresByYear[year]!;
                                        Map<int, List<int>> monthlyScores = {};

                                        // Grouping scores by month and calculating average
                                        for (var score in yearScores) {
                                          String monthStr =
                                              score.date.split("-")[1];
                                          int month = int.parse(monthStr);
                                          if (!monthlyScores
                                              .containsKey(month)) {
                                            monthlyScores[month] = [];
                                          }

                                          int averageScore = (score
                                                      .vocabularyScore +
                                                  score.fluencyScore +
                                                  score.grammarScore +
                                                  score.pronunciationScore) ~/
                                              4;
                                          monthlyScores[month]!
                                              .add(averageScore);
                                        }

                                        List<int> monthlyAverages = [];
                                        for (int month = 1;
                                            month <= 12;
                                            month++) {
                                          if (monthlyScores
                                              .containsKey(month)) {
                                            final monthScores =
                                                monthlyScores[month]!;
                                            int monthAverage = monthScores
                                                    .reduce((a, b) => a + b) ~/
                                                monthScores.length;
                                            monthlyAverages.add(monthAverage);
                                          } else {
                                            monthlyAverages.add(0);
                                          }
                                        }

                                        barCharts.add(
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: 300,
                                                    child: Center(
                                                      child: SizedBox(
                                                        height: 300,
                                                        width: 500,
                                                        child: BarChart(
                                                          ticks: [
                                                            10,
                                                            20,
                                                            30,
                                                            40,
                                                            50,
                                                            60,
                                                            70,
                                                            80,
                                                            90,
                                                            100
                                                          ],
                                                          features: [
                                                            'January',
                                                            'February',
                                                            'March',
                                                            'April',
                                                            'May',
                                                            'June',
                                                            'July',
                                                            'August',
                                                            'September',
                                                            'October',
                                                            'November',
                                                            'December'
                                                          ],
                                                          data: [
                                                            monthlyAverages
                                                          ],
                                                          graphNames: [
                                                            'Monthly Average Scores'
                                                          ],
                                                          graphColors: [
                                                            Color.fromARGB(255,
                                                                152, 123, 59),
                                                            Color.fromARGB(255,
                                                                233, 190, 97),
                                                            Color.fromARGB(255,
                                                                77, 62, 29),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Text(
                                                        "Year: $year",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 78, 56, 36),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              "Monthly Average Scores",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 15),
                                            Container(
                                              height: 400,
                                              child: PageView(
                                                children: barCharts,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : StreamBuilder<List<Score>>(
                                    stream: ref
                                        .read(
                                            dashboardNotifierProvider.notifier)
                                        .observeScores(userEmail ?? "",
                                            selectedLanguage ?? ""),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        // Print message to the console when no data is available
                                        print('There is no data');
                                        return Center(
                                          child: Text(
                                            'No data available', // Display a message when there's no data
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        );
                                      }

                                      final scores = snapshot.data!;
                                      if (scores.isEmpty) {
                                        return Center(
                                          child: Text(
                                            "No scores available for selected language",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[700]),
                                          ),
                                        );
                                      }

                                      // Grouping scores by year
                                      Map<int, List<Score>> scoresByYear = {};
                                      for (var score in scores) {
                                        int year =
                                            int.parse(score.date.split("-")[0]);
                                        if (!scoresByYear.containsKey(year)) {
                                          scoresByYear[year] = [];
                                        }
                                        scoresByYear[year]!.add(score);
                                      }

                                      List<int> yearAverages = [];
                                      List<int> years = [];
                                      List<int> sortedYears = scoresByYear.keys
                                          .toList()
                                        ..sort((a, b) => b.compareTo(a));

                                      for (var year in sortedYears) {
                                        List<Score> yearScores =
                                            scoresByYear[year]!;
                                        int totalScore = 0;
                                        int count = 0;
                                        for (var score in yearScores) {
                                          int averageScore = (score
                                                      .vocabularyScore +
                                                  score.fluencyScore +
                                                  score.grammarScore +
                                                  score.pronunciationScore) ~/
                                              4;
                                          totalScore += averageScore;
                                          count++;
                                        }
                                        int yearAverage = (count > 0)
                                            ? totalScore ~/ count
                                            : 0;

                                        yearAverages.add(yearAverage);
                                        years.add(year);
                                      }

                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              "Yearly Average Scores",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 15),
                                            Container(
                                              height: 400,
                                              child: BarChartY(
                                                ticks: [
                                                  10,
                                                  20,
                                                  30,
                                                  40,
                                                  50,
                                                  60,
                                                  70,
                                                  80,
                                                  90,
                                                  100
                                                ],
                                                features: years
                                                    .map((year) =>
                                                        year.toString())
                                                    .toList(),
                                                data: [yearAverages],
                                                graphNames: [
                                                  'Yearly Average Scores'
                                                ],
                                                graphColors: [
                                                  Color.fromARGB(
                                                      255, 152, 123, 59),
                                                  Color.fromARGB(
                                                      255, 233, 190, 97),
                                                  Color.fromARGB(
                                                      255, 77, 62, 29),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildScoreCard(String title, int currentScore, int previousScore) {
  // Determine if the score increased or decreased
  Icon arrowIcon;
  Color arrowColor;
  if (currentScore > previousScore) {
    arrowIcon = Icon(Icons.arrow_upward, color: Colors.green);
    arrowColor = Colors.green;
  } else if (currentScore < previousScore) {
    arrowIcon = Icon(Icons.arrow_downward, color: Colors.red);
    arrowColor = Colors.red;
  } else {
    arrowIcon = Icon(Icons.horizontal_rule, color: Colors.grey);
    arrowColor = Colors.grey;
  }

  return Container(
    height: 120,
    width: 170,
    padding: EdgeInsets.all(1),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 245, 237, 198),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$currentScore",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color.fromARGB(255, 94, 85, 54),
              ),
            ),
            SizedBox(width: 5),
            arrowIcon,
          ],
        )
      ],
    ),
  );
}
