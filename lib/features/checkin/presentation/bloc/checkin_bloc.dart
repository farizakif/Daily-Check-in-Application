import 'package:bloc/bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/exceptions/checkin_exceptions.dart';
import '../../domain/entities/checkin_entity.dart';
import '../../domain/usecases/get_checkin_history.dart';
import '../../domain/usecases/get_today_checkin.dart';
import '../../domain/usecases/has_checked_in_today_usecase.dart';
import '../../domain/usecases/perform_checkin.dart';
import 'checkin_event.dart';
import 'checkin_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final PerformCheckIn performCheckInUseCase;
  final GetCheckInHistory getCheckInHistoryUseCase;
  final HasCheckedInToday hasCheckedInTodayUseCase;
  final GetTodayCheckIn getTodayCheckInUseCase;

  CheckInBloc({
    required this.performCheckInUseCase,
    required this.getCheckInHistoryUseCase,
    required this.hasCheckedInTodayUseCase,
    required this.getTodayCheckInUseCase,
  }) : super(CheckInInitial()) {
    on<LoadCheckInStatus>(_onLoadStatus);
    on<RefreshCheckInsEvent>(_onRefresh);
    on<LoadCheckInsEvent>(_onLoadCheckIns);
    on<PerformCheckInEvent>(_onPerformCheckIn);
    on<LoadHistory>(_onLoadHistory);
  }

  Future<void> _onRefresh(
    RefreshCheckInsEvent event,
    Emitter<CheckInState> emit,
  ) async {
    await _onLoadStatus(LoadCheckInStatus(), emit);
  }

  Future<void> _onLoadCheckIns(
    LoadCheckInsEvent event,
    Emitter<CheckInState> emit,
  ) async {
    await _onLoadStatus(LoadCheckInStatus(), emit);
  }

  Future<void> _onLoadStatus(
    LoadCheckInStatus event,
    Emitter<CheckInState> emit,
  ) async {
    emit(CheckInLoading());
    try {
      final hasCheckedIn = await hasCheckedInTodayUseCase();
      final todayCheckIn = await getTodayCheckInUseCase();
      final history = await getCheckInHistoryUseCase(limit: 30);
      final streak = _calculateStreak(history);

      emit(
        CheckInLoaded(
          hasCheckedInToday: hasCheckedIn,
          todayCheckInTime: todayCheckIn?.dateTime,
          streakCount: streak,
          checkIns: history,
        ),
      );
    } catch (e) {
      emit(CheckInError(message: 'Failed to load status. Please try again.'));
    }
  }

  Future<void> _onPerformCheckIn(
    PerformCheckInEvent event,
    Emitter<CheckInState> emit,
  ) async {
    emit(CheckInLoading());
    try {
      final checkIn = await performCheckInUseCase();
      final history = await getCheckInHistoryUseCase(limit: 30);
      final streak = _calculateStreak(history);
      final hasCheckedIn = await hasCheckedInTodayUseCase();

      emit(
        CheckInLoaded(
          hasCheckedInToday: hasCheckedIn,
          todayCheckInTime: checkIn.dateTime,
          streakCount: streak,
          checkIns: history,
        ),
      );
    } on CheckInAlreadyDoneException {
      final todayCheckIn = await getTodayCheckInUseCase();
      final history = await getCheckInHistoryUseCase(limit: 30);
      final streak = _calculateStreak(history);

      emit(
        CheckInLoaded(
          hasCheckedInToday: true,
          todayCheckInTime: todayCheckIn?.dateTime ?? DateTime.now(),
          streakCount: streak,
          checkIns: history,
        ),
      );
    } catch (_) {
      emit(CheckInError(message: 'Could not check in. Please try again.'));
    }
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<CheckInState> emit,
  ) async {
    emit(CheckInLoading());
    try {
      final history = await getCheckInHistoryUseCase(limit: 30);
      // Materialise last 30 calendar days so presentation can compute misses.
      final last30Days = DateUtilsHelper.last30Days();
      emit(CheckInHistoryLoaded(checkIns: history, last30Days: last30Days));
    } catch (_) {
      emit(CheckInError(message: 'Failed to load history. Please try again.'));
    }
  }

  int _calculateStreak(List<CheckIn> history) {
    if (history.isEmpty) return 0;

    final normalizedDates = history
        .map((c) => DateTime(c.dateTime.year, c.dateTime.month, c.dateTime.day))
        .toSet();

    final now = DateTime.now();
    DateTime cursor = DateTime(now.year, now.month, now.day);

    int streak = 0;

    if (!normalizedDates.contains(cursor)) {
      return 0;
    }

    while (normalizedDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
