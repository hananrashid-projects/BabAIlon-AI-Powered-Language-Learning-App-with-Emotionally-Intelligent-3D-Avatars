import 'package:babellion/models/dashboard.dart';
import 'package:babellion/models/feedback_history.dart';
import 'package:babellion/models/language.dart';
import 'package:babellion/models/score.dart';
import 'package:babellion/providers/dashboard_repo_provider.dart';
import 'package:babellion/repositoriy/dashboardRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardNotifier extends AsyncNotifier<List<Dashboard>> {
  DashboardRepository? _repository;

  @override
  Future<List<Dashboard>> build() async {
    _repository = await ref.watch(dashboardRepositoryProvider.future);

    // Set the initial loading state
    state = AsyncValue.loading();

    // Listen for changes in dashboard data
    _repository!.observeDashboards().listen(
      (dashboards) {
        // Update state with fetched data
        state = AsyncValue.data(dashboards);
      },
      onError: (error, stackTrace) {
        // Update state on error
        state = AsyncValue.error(error, stackTrace);
        print("Error while observing dashboards: $error");
      },
    );

    return []; // Initially, return an empty list
  }

  // Fetch dashboard by email
  Future<void> fetchDashboardByEmail(String userEmail) async {
    try {
      final dashboard = await _repository!.getDashboardByEmail(userEmail);
      if (dashboard != null) {
        state = AsyncValue.data([dashboard]);
      } else {
        state = AsyncValue.data([]);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Add a new dashboard
  void addDashboard(Dashboard dashboard) async {
    try {
      await _repository!.addDashboard(dashboard);
    } catch (e) {
      print("Error adding dashboard: $e");
    }
  }

  // Add a new language to a dashboard based on email
  void addLanguageToDashboard(String userEmail, Language language) async {
    try {
      await _repository!.addLanguageToDashboard(userEmail, language);
      fetchDashboardByEmail(
          userEmail); // Refresh the dashboard with new language
    } catch (e) {
      print("Error adding language to dashboard: $e");
    }
  }

  // Add a score to a specific language in a dashboard
  Future<void> addScoreToLanguage(
      String userEmail, String languageName, Score score) async {
    try {
      // Ensure that the language exists in Firestore
      final dashboard = await _repository!.getDashboardByEmail(userEmail);
      final language = dashboard!.languages.firstWhere(
        (language) => language.language == languageName,
        orElse: () => throw Exception("Language not found in dashboard"),
      );

      // Add score to Firestore
      await _repository!
          .addScoreToLanguage(userEmail, language.language, score);

      // Optionally, refresh the dashboard to reflect the new score
      fetchDashboardByEmail(userEmail);
    } catch (e) {
      print("Error adding score to language: $e");
      throw e; // Rethrow the error so it can be handled in the UI
    }
  }

  // Observe languages for a dashboard based on userEmail
  Stream<List<Language>> observeLanguages(String userEmail) {
    return _repository!.observeLanguagesByEmail(userEmail);
  }

  // Observe scores for a specific language in a dashboard
  Stream<List<Score>> observeScores(String userEmail, String languageId) {
    return _repository!.observeScoresByEmail(userEmail, languageId);
  }

  Future<List<Score>> getScoresByDate(
      String userEmail, String languageName, String date) async {
    try {
      var scores =
          await _repository!.getScoresByDate(userEmail, languageName, date);
      return scores;
    } catch (e) {
      print('Error fetching scores by date: $e');
      throw Exception("Failed to get scores by date: $e");
    }
  }

  Future<List<Score>> getScoresBeforeDate(
      String userEmail, String languageName, String date) async {
    try {
      var scores =
          await _repository!.getScoresBeforeDate(userEmail, languageName, date);
      return scores;
    } catch (e) {
      print('Error fetching scores by date: $e');
      throw Exception("Failed to get scores by date: $e");
    }
  }

  // Add feedback for a specific language
  Future<void> addFeedbackForLanguage(String userEmail, String languageName,
      String feedback, String date) async {
    try {
      await _repository!
          .addFeedbackForLanguage(userEmail, languageName, feedback, date);
      // Optionally refresh the dashboard after adding feedback
      fetchDashboardByEmail(userEmail);
    } catch (e) {
      print("Error adding feedback for language: $e");
      throw e;
    }
  }

  Future<List<FeedbackHistory>> getFeedbackForLanguage(
      String userEmail, String languageName) async {
    try {
      return await _repository!.getFeedbackForLanguage(userEmail, languageName);
    } catch (e) {
      print('Error fetching feedback for language: $e');
      throw Exception("Failed to get feedback for language: $e");
    }
  }

  Future<List<FeedbackHistory>> getFeedbackByDate(
      String userEmail, String languageName, String date) async {
    try {
      return await _repository!
          .getFeedbackByDate(userEmail, languageName, date);
    } catch (e) {
      print('Error fetching feedback by date: $e');
      throw Exception("Failed to get feedback by date: $e");
    }
  }
}

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, List<Dashboard>>(
  () => DashboardNotifier(),
);
final selectedLanguageProvider = StateProvider<String>((ref) => "English");
// final selectedDateProvider = StateProvider<String>((ref) {
//   return DateFormat('yyyy-MM-dd')
//       .format(DateTime.now()); // Default to today's date
// });
final selectedDateProvider = StateProvider<String?>((ref) => null);
final selectedDateScoresProvider = StateProvider<List<Score>>((ref) => []);
final selectedFeedbackDateProvider = StateProvider<String?>((ref) => null);
final allScoresProvider = StateProvider<List<Score>>((ref) => []);
final isMonthlySelectedProvider = StateProvider<bool>((ref) => false); // Default is false (Yearly)
