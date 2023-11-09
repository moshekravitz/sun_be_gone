// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:sun_be_gone/models/bus_routes.dart';

void main() {
  test('BusRoutes', () {
    //scvString:
    List<String> str = [
      '15544,35,412,אליהו הנביא/הרב שלמה זלמן אויערבך-בית שמש<->ת. רכבת תל אביב - סבידור/הורדה-תל אביב יפו-10,10412-1-0,3,',
      '31999,34,600,heichalmishpat/aba-even<->haamoraim/school-10,12600-1-0,3',
      '15545,35,412,ת. רכבת תל אביב- סבידור/רציפים A-תל אביב יפו<->אליהו הנביא/הרב שלמה זלמן אויערבך-בית שמש-20,10412-2-0,3,',
    ];
    var splitstrs = [
      str[0].split(','),
      str[1].split(','),
      str[2].split(','),
    ];

    var i = 0;
    var busRoutes = BusRoutes(
        routeId: int.parse(splitstrs[i][0]),
        routeShortName: splitstrs[i][2],
        routeLongName: splitstrs[i][3]);

    String pretty = busRoutes.prettyString();
    print(pretty);

  });
}
