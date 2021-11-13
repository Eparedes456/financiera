import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:financiera/bloc/ticker.dart';
import 'package:financiera/bloc/timer_event.dart';
import 'package:financiera/bloc/timer_state.dart';

class TimerBloc extends Bloc<TimerEvent,TimerState>{

  final Ticker _ticker;
  final int _duration = 60;

  StreamSubscription<int> _tickerSubscription;

 TimerBloc({ Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;
    


  @override
  TimerState get initialState => Ready(_duration);

  @override

  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if(event is Start){
      yield* _mapStartToState(event);
    }
  }

  @override
  void dispose(){
    _tickerSubscription?.cancel();
    super.dispose();
  }

  Stream<TimerState> _mapStartToState(Start start) async*{

    yield Running(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: start.duration).listen(
      (duration) {
        dispatch(Tick(duration: duration));
      },
    );
  }

}