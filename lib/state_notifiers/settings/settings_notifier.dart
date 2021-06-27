import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:masjid_enroute/models/asr_jurisdiction.dart';
import 'package:masjid_enroute/repository/settings_database.dart';

part 'settings.dart';
part 'settings_notifier.freezed.dart';
part 'settings_notifier.g.dart';

class SettingsNotifier extends StateNotifier<AsyncValue<Settings>> {
  final SettingsDatabase? settingsDatabase;
  SettingsNotifier({this.settingsDatabase}) : super(const AsyncLoading());

  void init() {
    if (settingsDatabase == null) return;
    state = AsyncData(settingsDatabase!.getSettings());
  }

  void update({AsrJurisdiction? asr, bool? store}) {
    if (settingsDatabase == null) return;
    
    state.whenData((value) {
      final newSettings = value.copyWith(
        asr: asr ?? value.asr,
        storeLastLocation: store ?? value.storeLastLocation,
      );
      state = AsyncData(newSettings);
      settingsDatabase!.newSettings(newSettings);
    });
  }
}
