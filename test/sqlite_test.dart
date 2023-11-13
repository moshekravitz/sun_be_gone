import 'package:flutter_test/flutter_test.dart';
import 'package:sun_be_gone/data/sqlite_db.dart';
import 'package:sun_be_gone/models/bus_route_full_data.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';

void main() async {
  test('BusRouteDB', () async {
    var busRouteDB = BusRouteDB();
    // '31999,34,600,heichalmishpat/aba-even<->haamoraim/school-10,12600-1-0,3',
    BusRoutes busRoute = BusRoutes(
        routeId: 1,
        routeShortName: '111',
        routeLongName: 'heichalmishpat/aba-even<->haamoraim/school-10');
    var res = await busRouteDB.saveBusRoute(busRoute);
    expect(res, 1);
    var list = await busRouteDB.getBusRoutes();
    expect(list.length, 1);
    expect(list[0].routeId, 1);
    expect(list[0].routeShortName, '111');
    expect(
        list[0].routeLongName, 'heichalmishpat/aba-even<->haamoraim/school-10');
  });
  test('BusRoutesQuaryDB', () async {
    var busRoutesQuaryDb = BusRoutesQuaryDB();
    List<StopQuaryInfo> stops = [
      StopQuaryInfo(
        stopId: 1,
        stopName: 'stop1',
        stopLat: 1.1,
        stopLon: 1.1,
        stopInterval: '1',
      ),
      StopQuaryInfo(
        stopId: 2,
        stopName: 'stop2',
        stopLat: 2.2,
        stopLon: 2.2,
        stopInterval: '2',
      ),
    ];
    RoutesQuaryData routeQuaryData = RoutesQuaryData(
      routeId: 1,
      departureIndex: 0,
      destinationIndex: 1,
      fullStops: stops,
      shapeId: 1,
      shapeStr: null,
    );
    var saveRouteQRes =
        await busRoutesQuaryDb.saveRouteQuaryInfo(routeQuaryData);
    expect(saveRouteQRes, 1);
    var getRouteQRes = await busRoutesQuaryDb.getRouteQuaryInfo(1);
    expect(getRouteQRes!.routeId, 1);
    expect(getRouteQRes.fullStops.length, 2);
  });
}
