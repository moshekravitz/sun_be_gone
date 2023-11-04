import 'package:bloc/bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_state.dart';
import 'package:sun_be_gone/models/route_quary_info.dart';

class DataAction {
  const DataAction();
}

class AddRoutesDataAction extends DataAction {
  int? routeId;
  String? routeHeadSign;
  String? shapeStr;
  Iterable<StopQuaryInfo>? stopQuaryInfo;
  Iterable<StopQuaryInfo>? fullStopQuaryInfo;
  DateTime? dateTime;

  AddRoutesDataAction({
    this.routeId,
    this.routeHeadSign,
    this.shapeStr,
    this.stopQuaryInfo,
    this.fullStopQuaryInfo,
    this.dateTime,
  });
}

class AddDateTimeAction extends DataAction {
  final DateTime dateTime;

  const AddDateTimeAction({
    required this.dateTime,
  });
}

class DataState {
  int? routeId;
  String? routeHeadSign;
  String? shapeStr;
  Iterable<StopQuaryInfo>? stopQuaryInfo;
  Iterable<StopQuaryInfo>? fullStopQuaryInfo;
  DateTime? dateTime;

  DataState({
    this.routeId,
    this.routeHeadSign,
    this.shapeStr,
    this.stopQuaryInfo,
    this.fullStopQuaryInfo,
    this.dateTime,
  });
}

class DataBloc extends Bloc<DataAction, DataState> {
  DataBloc() : super(DataState()) {
    on<AddRoutesDataAction>((action, emit) async {
      emit(DataState(
        routeId: action.routeId,
        routeHeadSign: action.routeHeadSign,
        shapeStr: action.shapeStr,
        fullStopQuaryInfo: action.fullStopQuaryInfo,
        stopQuaryInfo: action.stopQuaryInfo,
        dateTime: state.dateTime,
      ));
    });

    on<AddDateTimeAction>((action, emit) async {
      emit(DataState(
        routeId: state.routeId,
        routeHeadSign: state.routeHeadSign,
        shapeStr: state.shapeStr,
        fullStopQuaryInfo: state.fullStopQuaryInfo,
        stopQuaryInfo: state.stopQuaryInfo,
        dateTime: action.dateTime,
      ));
    });
  }
}

class DateTimeCubit extends Cubit<DateTime> {
    DateTimeCubit() : super(DateTime.now());
    
    void setDateTime(DateTime dateTime) {
        emit(dateTime);
    }
}
