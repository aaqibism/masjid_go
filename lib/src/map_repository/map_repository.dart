import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:masjid_go/src/map_repository/map_repository_stub.dart'
    if (dart.library.io) 'package:masjid_go/repository/map_repository/map_repository_mobile.dart'
    if (dart.library.html) 'package:masjid_go/repository/map_repository/map_repository_web.dart';
import 'package:masjid_go/src/models/google_place/google_place.dart';
import 'package:masjid_go/src/models/lat_long/lat_long.dart';
import 'package:masjid_go/src/models/masjid/masjid.dart';

abstract class MapRepository {
  factory MapRepository() => getMapRepository();

  Future<String?> addressFromLoc(LatLong loc) => throw UnimplementedError();

  Uri buildMapsURL(
    LatLong origin,
    String originPlaceId,
    LatLong destination,
    String destinationPlaceId, {
    List<LatLong> waypoints = const [],
    List<String> waypoint_place_ids = const [],
  }) =>
      throw UnimplementedError();

  Future<PolylineResult?> findRoutes(String origin, String destination) =>
      throw UnimplementedError();

  Future<LatLong?> getLocation() => throw UnimplementedError();

  Future<LatLong?> getLocFromPlaceId(String placeId) =>
      throw UnimplementedError();

  Future<List<Masjid>> getMasjids(Route route) => throw UnimplementedError();

  Future<String?> getPlaceIdFromLoc(LatLong loc) => throw UnimplementedError();

  Future<List<GooglePlace>> searchPlaces(String query, {LatLong? loc}) =>
      throw UnimplementedError();
}
