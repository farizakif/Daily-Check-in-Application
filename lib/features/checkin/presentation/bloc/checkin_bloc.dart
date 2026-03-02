import 'package:bloc/bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/checkin_entity.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/get_checkins_usecase.dart';
import '../../domain/usecases/has_checked_in_today_usecase.dart';
import 'checkin_event.dart';
import 'checkin_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final GetCheckInsUseCase getCheckInsUseCase;
  final HasCheckedInTodayUseCase hasCheckedInTodayUseCase;
  final CheckInUseCase checkInUseCase;

  CheckInBloc({
    required this.getCheckInsUseCase,
    required this.hasCheckedInTodayUseCase,
    required this.checkInUseCase,
  }) : super(const CheckInInitial()) {
    on<LoadCheckInsEvent>(_onLoad);
    on<RefreshCheckInsEvent>(_onRefresh);
    on<PerformCheckInEvent>(_onPerformCheckIn);
  }

  Future<void> _onLoad(
    LoadCheckInsEvent event,
    Emitter<CheckInState> emit,
  ) async {
    emit(const CheckInLoading());
    try {
      final checkIns = await getCheckInsUseCase();
      final hasCheckedInToday = await hasCheckedInTodayUseCase();

      final normalized = _normalizeHistory(checkIns);

      emit(CheckInLoaded(
        checkIns: normalized,
        hasCheckedInToday: hasCheckedInToday,
      ));
    } catch (e) {
      emit(CheckInError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onRefresh(
    RefreshCheckInsEvent event,
    Emitter<CheckInState> emit,
  ) async {
    await _onLoad(const LoadCheckInsEvent(), emit);
  }

  Future<void> _onPerformCheckIn(
    PerformCheckInEvent event,
    Emitter<CheckInState> emit,
  ) async {
    final currentState = state;

    emit(const CheckInLoading());

    try {
      final alreadyCheckedInToday = await hasCheckedInTodayUseCase();

      if (alreadyCheckedInToday) {
        if (currentState is CheckInLoaded) {
          emit(currentState);
        } else {
          final checkIns = await getCheckInsUseCase();
          final normalized = _normalizeHistory(checkIns);
          emit(CheckInLoaded(
            checkIns: normalized,
            hasCheckedInToday: true,
          ));
        }
        emit(const CheckInError('You have already checked in today.'));
        return;
      }

      await checkInUseCase();

      final checkIns = await getCheckInsUseCase();
      final hasCheckedInToday = await hasCheckedInTodayUseCase();

      final normalized = _normalizeHistory(checkIns);

      emit(CheckInLoaded(
        checkIns: normalized,
        hasCheckedInToday: hasCheckedInToday,
      ));
    } catch (e) {
      emit(CheckInError(_mapErrorToMessage(e)));
    }
  }

  List<CheckInEntity> _normalizeHistory(List<CheckInEntity> checkIns) {
    final sorted = List<CheckInEntity>.from(checkIns)
      ..sort((a, b) => b.time.compareTo(a.time));

    if (sorted.length <= 30) {
      return List<CheckInEntity>.unmodifiable(sorted);
    }
    return List<CheckInEntity>.unmodifiable(sorted.take(30).toList());
  }

  String _mapErrorToMessage(Object e) {
    if (e is CacheFailure) {
      return e.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
