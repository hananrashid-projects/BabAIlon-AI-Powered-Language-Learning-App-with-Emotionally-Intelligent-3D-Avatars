// import 'package:babellion/models/feedback_history.dart';
// import 'package:babellion/providers/dashboard_repo_provider.dart';
// import 'package:babellion/repositoriy/dashboardRepository.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class FeedbackHistoryNotifier extends AsyncNotifier<List<FeedbackHistory>> {
//   DashboardRepository? _repository;

//   @override
//   Future<List<FeedbackHistory>> build() async {
//     _repository = await ref.watch(dashboardDataFeedbackRepoProvider.future);
//     final dashboardDataId = ref.watch(selectedDatabaseDataIdProvider);

//     _repository?.observeFeedbackHistory(dashboardDataId!).listen(
//       (feedbacks) {
//         state = AsyncValue.data(feedbacks);
//       },
//     ).onError((error, stackTrace) {
//       state = AsyncValue.error(error, stackTrace);
//       print("Error while observing feedback history: $error");
//     });

//     return [];
//   }

//   void addFeedbackHistory(FeedbackHistory feedback) async {
//     try {
//       await _repository?.addFeedbackHistory(feedback);
//     } catch (e) {
//       print("Error adding feedback history: $e");
//     }
//   }

//   void updateFeedbackHistory(FeedbackHistory feedback) async {
//     try {
//       await _repository?.updateFeedbackHistory(feedback);
//     } catch (e) {
//       print("Error updating feedback history: $e");
//     }
//   }

//   void deleteFeedbackHistory(FeedbackHistory feedback) async {
//     try {
//       await _repository?.deleteFeedbackHistory(feedback);
//     } catch (e) {
//       print("Error deleting feedback history: $e");
//     }
//   }
// }

// final feedbackHistoryNotifierProvider =
//     AsyncNotifierProvider<FeedbackHistoryNotifier, List<FeedbackHistory>>(
//         () => FeedbackHistoryNotifier());
