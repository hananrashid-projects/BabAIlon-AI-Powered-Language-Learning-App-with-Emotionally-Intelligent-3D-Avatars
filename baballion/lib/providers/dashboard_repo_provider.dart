import 'package:babellion/repositoriy/dashboardRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider =
    FutureProvider<DashboardRepository>((ref) async {
  var db = FirebaseFirestore.instance;
  var dashboardRef = db.collection('dashboards');
  return DashboardRepository(
    dashboardRef: dashboardRef,
  );
});

final selectedDatabaseIdProvider = StateProvider<String?>((ref) => null);
