import 'package:babellion/models/dashboard.dart';
import 'package:babellion/models/feedback_history.dart';
import 'package:babellion/models/language.dart';
import 'package:babellion/models/score.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardRepository {
  final CollectionReference dashboardRef;

  DashboardRepository({
    required this.dashboardRef,
  });

  // Observe Dashboards - Get all dashboards with their languages and scores
  Stream<List<Dashboard>> observeDashboards() {
    return dashboardRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Dashboard.fromMap(data);
      }).toList();
    });
  }

  // Add a new Dashboard
  Future<void> addDashboard(Dashboard dashboard) async {
    var docId = dashboardRef.doc().id;
    dashboard.id = docId;
    await dashboardRef.doc(docId).set(dashboard.toMap());
  }

  // Update an existing Dashboard
  Future<void> updateDashboard(Dashboard dashboard) async {
    await dashboardRef.doc(dashboard.id).update(dashboard.toMap());
  }

  // Delete a Dashboard
  Future<void> deleteDashboard(Dashboard dashboard) async {
    await dashboardRef.doc(dashboard.id).delete();
  }

  // Get a Dashboard by user_email
  Future<Dashboard?> getDashboardByEmail(String userEmail) async {
    var snapshot = await dashboardRef
        .where('user_email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    var data = snapshot.docs.first.data() as Map<String, dynamic>;
    return Dashboard.fromMap(data);
  }

  // Observe Languages for a specific Dashboard based on email
  Stream<List<Language>> observeLanguagesByEmail(String userEmail) {
    return dashboardRef
        .where('user_email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      var dashboard = Dashboard.fromMap(data);
      return dashboard.languages;
    });
  }

  // Add a Language to the Dashboard's languages list based on email
  Future<void> addLanguageToDashboard(
      String userEmail, Language language) async {
    var docSnapshot = await dashboardRef
        .where('user_email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (docSnapshot.docs.isEmpty) {
      throw Exception("Dashboard not found for user_email: $userEmail");
    }

    var doc = docSnapshot.docs.first;
    var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);

    dashboard.languages.add(language);

    await dashboardRef.doc(doc.id).update({
      'languages': dashboard.languages.map((lang) => lang.toMap()).toList(),
    });
  }

  // Get all languages of a Dashboard based on email
  Future<List<Language>> getLanguagesByEmail(String userEmail) async {
    var docSnapshot = await dashboardRef
        .where('user_email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (docSnapshot.docs.isEmpty) {
      throw Exception("Dashboard not found for user_email: $userEmail");
    }

    var doc = docSnapshot.docs.first;
    var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);
    return dashboard.languages;
  }

  // Observe Scores for a specific Dashboard and Language based on email
  Stream<List<Score>> observeScoresByEmail(
      String userEmail, String languageName) {
    return dashboardRef
        .where('user_email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      var dashboard = Dashboard.fromMap(data);

      var language = dashboard.languages.firstWhere(
          (lang) => lang.language == languageName,
          orElse: () => throw Exception("Language not found"));

      return language.scores;
    });
  }

  Future<List<Score>> getScoresByDate(
      String userEmail, String languageName, String date) async {
    try {
      var querySnapshot = await dashboardRef
          .where('user_email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No dashboard found for user_email: $userEmail");
      }

      var doc = querySnapshot.docs.first;
      var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);

      var language = dashboard.languages.firstWhere(
        (lang) => lang.language == languageName,
        orElse: () => throw Exception("Language not found: $languageName"),
      );

      var filteredScores = language.scores.where((score) {
        String scoreDate = score.date.substring(0, 10); // "yyyy-MM-dd"
        return scoreDate == date;
      }).toList();

      return filteredScores;
    } catch (e) {
      print('Error fetching scores by date: $e');
      throw Exception("Failed to get scores by date: $e");
    }
  }

  Future<void> addScoreToLanguage(
      String userEmail, String languageName, Score score) async {
    try {
      // Get the document snapshot of the user's dashboard
      var docSnapshot = await FirebaseFirestore.instance
          .collection('dashboards')
          .where('user_email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (docSnapshot.docs.isEmpty) {
        throw Exception("Dashboard not found for user_email: $userEmail");
      }

      var doc = docSnapshot.docs.first;
      var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);

      // Find the language in the dashboard using the language name
      var language = dashboard.languages.firstWhere(
        (lang) => lang.language == languageName,
        orElse: () =>
            throw Exception("Language not found with name: $languageName"),
      );

      // Add the score to the language's score list
      language.scores.add(score);

      // Update the dashboard with the new scores list
      await FirebaseFirestore.instance
          .collection('dashboards')
          .doc(doc.id)
          .update({
        'languages': dashboard.languages.map((lang) => lang.toMap()).toList(),
      });

      print("Score added successfully to the language.");
    } catch (e) {
      print('Error adding score to language: $e');
      throw Exception("Failed to add score: $e");
    }
  }

  Future<List<Score>> fetchAllScores(
      String userEmail, String languageName) async {
    try {
      // Fetch the user's dashboard document
      var querySnapshot = await dashboardRef
          .where('user_email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No dashboard found for user_email: $userEmail");
      }

      var doc = querySnapshot.docs.first;
      var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);

      // Find the language in the dashboard using the language name
      var language = dashboard.languages.firstWhere(
        (lang) => lang.language == languageName,
        orElse: () => throw Exception("Language not found: $languageName"),
      );

      // Return the scores for that language
      return language.scores;
    } catch (e) {
      print('Error fetching all scores: $e');
      throw Exception("Failed to get scores: $e");
    }
  }

  Future<List<Score>> getScoresBeforeDate(
      String userEmail, String selectedLanguage, String selectedDate) async {
    // Fetch all scores for the user and language first
    final allScores = await fetchAllScores(userEmail, selectedLanguage);

    // Parse the selected date string to a DateTime object
    final selectedDateTime = DateFormat('yyyy-MM-dd').parse(selectedDate);

    // Find the closest previous score by comparing the dates
    final closestScores = allScores
        .where((score) => DateFormat('yyyy-MM-dd')
            .parse(score.date)
            .isBefore(selectedDateTime))
        .toList();

    // Sort by date descending, so the latest date comes first
    closestScores.sort((a, b) => DateFormat('yyyy-MM-dd')
        .parse(b.date)
        .compareTo(DateFormat('yyyy-MM-dd').parse(a.date)));

    return closestScores;
  }

  Future<void> addFeedbackForLanguage(String userEmail, String languageName,
      String feedback, String date) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('dashboards')
          .where('user_email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (docSnapshot.docs.isEmpty) {
        throw Exception("Dashboard not found for user_email: $userEmail");
      }

      var doc = docSnapshot.docs.first;
      var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);

      // Find the language
      var language = dashboard.languages.firstWhere(
        (lang) => lang.language == languageName,
        orElse: () => throw Exception("Language not found: $languageName"),
      );

      FeedbackHistory newFeedback =
          FeedbackHistory(languageName, feedback, date);

      // Add the new FeedbackHistory object to the feedbackHistory list
      language.feedbackHistory ??= [];
      language.feedbackHistory!.add(newFeedback);

      // Update the dashboard with the new feedback list
      await FirebaseFirestore.instance
          .collection('dashboards')
          .doc(doc.id)
          .update({
        'languages': dashboard.languages.map((lang) => lang.toMap()).toList(),
      });

      print("Feedback added to language $languageName successfully.");
    } catch (e) {
      print('Error adding feedback for language: $e');
      throw Exception("Failed to add feedback for language: $e");
    }
  }

  Future<List<FeedbackHistory>> getFeedbackForLanguage(
      String userEmail, String languageName) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('dashboards')
          .where('user_email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No dashboard found for user_email: $userEmail");
      }

      var doc = querySnapshot.docs.first;
      var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);

      // Find the language
      var language = dashboard.languages.firstWhere(
        (lang) => lang.language == languageName,
        orElse: () => throw Exception("Language not found: $languageName"),
      );

      // Return the feedback for the language
      return language.feedbackHistory ?? [];
    } catch (e) {
      print('Error fetching feedback for language: $e');
      throw Exception("Failed to get feedback for language: $e");
    }
  }

  Future<List<FeedbackHistory>> getFeedbackByDate(
      String userEmail, String languageName, String date) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('dashboards')
          .where('user_email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (docSnapshot.docs.isEmpty) {
        throw Exception("Dashboard not found for user_email: $userEmail");
      }

      var doc = docSnapshot.docs.first;
      var dashboard = Dashboard.fromMap(doc.data() as Map<String, dynamic>);

      // Find the language
      var language = dashboard.languages.firstWhere(
        (lang) => lang.language == languageName,
        orElse: () => throw Exception("Language not found: $languageName"),
      );

      // Filter the feedbackHistory for the given date
      if (language.feedbackHistory != null) {
        var filteredFeedback = language.feedbackHistory!.where((feedback) {
          return feedback.date ==
              date; // Compare the date with the feedback date
        }).toList();

        return filteredFeedback;
      }

      return [];
    } catch (e) {
      print('Error fetching feedback by date: $e');
      throw Exception("Failed to get feedback by date: $e");
    }
  }
}
