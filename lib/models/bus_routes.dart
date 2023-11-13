
class BusRoutes {
  int routeId;
  String routeShortName;
  String routeLongName;
  String? routeDeparture;
  String? routeDestination;

  BusRoutes({
    required this.routeId,
    required this.routeShortName,
    required this.routeLongName,
  }) {
    routeDeparture = routeLongName.substring(
      1,
      routeLongName.indexOf('<'),
    );
    routeDestination = routeLongName.substring(
      routeLongName.indexOf('>') + 1,
      routeLongName.lastIndexOf('-'),
    );
  }

//to string
  @override
  String toString() {
    return 'BusRoutes{routeId: $routeId, routeShortName: $routeShortName, routeLongName: $routeLongName}';
  }

  factory BusRoutes.fromJson(Map<String, dynamic> json) {
    return BusRoutes(
      routeId: json['routeId'] as int,
      routeShortName: json['routeShortName'] as String,
      routeLongName: json['routeLongName'] as String,
    );
  }

  //bus Route to map
  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'routeShortName': routeShortName,
      'routeLongName': routeLongName,
    };
  }



  String prettyString() {
    List<String> strs = routeLongName.split('-');

    String departureStation = strs[0].replaceAll(RegExp(r'\s+'), ' ');
    String departureCity = strs[1].replaceAll('<', '').replaceAll(RegExp(r'\s+'), ' ');
    String destinationStation = strs[2].substring(1).replaceAll(RegExp(r'\s+'), ' ');
    String destinationCity = strs[3].replaceAll(RegExp(r'\s+'), ' ');

    //String arrowIcon = '\u27F5';
    String arrowIcon = '\u2190';

    if (departureCity == destinationCity) {
      return '$departureStation $arrowIcon $destinationStation';
    } else {
      return '$departureCity $arrowIcon $destinationCity';
    }
  }
}

final mockBusRoutes = Iterable.generate(
  3,
  (i) => BusRoutes(
    routeId: i,
    routeShortName: '${i}00',
    routeLongName: 'Route number ${i + 1}',
  ),
);
