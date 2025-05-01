// import 'package:babellion/models/dashboard_data.dart';
// import 'package:babellion/providers/dashboard_repo_provider.dart';
// import 'package:babellion/repositoriy/dashboardRepository.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DashboardDataNotifier extends AsyncNotifier<List<DashboardData>> {
//   DashboardRepository? _repository;

//   Future<List<DashboardData>> build() async {
//     _repository = await ref.watch(dashboardDataFeedbackRepoProvider.future);
//     // Set the initial loading state
//     state = AsyncValue.loading();

//     // Listen for changes in dashboard data
//     _repository!.observeDashboardData().listen(
//       (datas) {
//         // Update state with fetched data
//         state = AsyncValue.data(datas);
//       },
//       onError: (error, stackTrace) {
//         // Update state on error
//         state = AsyncValue.error(error, stackTrace);
//         print("Error while observing dashboard data: $error");
//       },
//     );

//     return []; // Initially, return an empty list
//   }

//   void addDashboardData(DashboardData data) async {
//     try {
//       await _repository!.addDashboardData(data);
//     } catch (e) {
//       print("Error adding dashboard data: $e");
//     }
//   }

//   void updateDashboardData(DashboardData data) async {
//     try {
//       await _repository!.updateDashboardData(data);
//     } catch (e) {
//       print("Error updating dashboard data: $e");
//     }
//   }

//   void addScoreToDashboardData(String userEmail, Score score) async {
//     try {
//       await _repository!.addScoreToDashboardData(userEmail, score);
//     } catch (e) {
//       print("Error adding score to dashboard data: $e");
//     }
//   }

//   void deleteDashboardData(DashboardData data) async {
//     try {
//       await _repository!.deleteDashboardData(data);
//     } catch (e) {
//       print("Error deleting dashboard data: $e");
//     }
//   }
// }

// final dashboardDataNotifierProvider =
//     AsyncNotifierProvider<DashboardDataNotifier, List<DashboardData>>(
//         () => DashboardDataNotifier());
