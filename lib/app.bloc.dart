import 'package:ai_touch_10_days/repository/Repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

// EVENT
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppEventStartup extends AppEvent {}

class AppEventMessage extends AppEvent {
  final String message;

  AppEventMessage(this.message);

  @override
  List<Object> get props => [message];
}

// STATE
abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppStateInitial extends AppState {}

class AppStateLoading extends AppState {}

class AppStateNewMessage extends AppState {
  final String message;

  const AppStateNewMessage(this.message);
}

class AppStateError extends AppState {
  final String error;

  AppStateError(this.error);

  @override
  List<Object> get props => [error];
}

// BLOC
class AppBloc extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => AppStateInitial();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppEventMessage) {
      yield AppStateNewMessage(event.message);
    }
  }
}
