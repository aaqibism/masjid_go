import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:masjid_go/src/home/home_notifier.dart';
import 'package:masjid_go/src/location_search/location_search_notifier.dart';
import 'package:masjid_go/src/map_repository/map_repository.dart';
import 'package:masjid_go/src/map_routes/routes_notifier.dart';
import 'package:masjid_go/src/models/google_place/google_place.dart';
import 'package:masjid_go/src/models/masjid/masjid.dart';
import 'package:masjid_go/src/settings/db_constants.dart';
import 'package:masjid_go/src/settings/settings_database.dart';
import 'package:masjid_go/src/settings/settings_notifier.dart';

final settingsDatabaseProvider = FutureProvider<SettingsDatabase>((_) async {
  final searchBox = await Hive.openLazyBox<String>(DbBox.search);
  final settingsBox = await Hive.openBox(DbBox.settings);

  return SettingsDatabase(
    searchBox: searchBox,
    settingsBox: settingsBox,
  );
});

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<GlobalSettings>>((ref) {
  return ref.watch(settingsDatabaseProvider).maybeWhen(
        data: (_) => SettingsNotifier(settingsDatabase: _)..init(),
        orElse: () => SettingsNotifier(),
      );
});

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<HomeState>>((ref) {
  final mapsRepo = ref.read(mapRepoProvider);
  return ref.watch(settingsDatabaseProvider).maybeWhen(
        data: (_) =>
            HomeNotifier(mapRepository: mapsRepo, settingsDatabase: _)..init(),
        orElse: () => HomeNotifier(mapRepository: mapsRepo),
      );
});

final locationSearchProvider =
    StateNotifierProvider<LocationSearchNotifer, List<GooglePlace>>((ref) {
  return LocationSearchNotifer(mapRepository: ref.read(mapRepoProvider));
});

final mapRepoProvider = Provider((ref) => MapRepository());

final routesNotifierProvider =
    StateNotifierProvider<RoutesNotifier, AsyncValue<RoutesState>>((ref) {
  return RoutesNotifier(mapRepository: ref.read(mapRepoProvider));
});

final masjidsProvider =
    FutureProvider.autoDispose.family<List<Masjid>, Route>((ref, route) {
  return ref.read(mapRepoProvider).getMasjids(route);
});