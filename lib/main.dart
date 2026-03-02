import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/checkin/data/datasources/checkin_local_data_source.dart';
import 'features/checkin/data/repositories/checkin_repository_impl.dart';
import 'features/checkin/domain/usecases/check_in_usecase.dart';
import 'features/checkin/domain/usecases/get_checkins_usecase.dart';
import 'features/checkin/domain/usecases/has_checked_in_today_usecase.dart';
import 'features/checkin/presentation/bloc/checkin_bloc.dart';
import 'features/checkin/presentation/bloc/checkin_event.dart';
import 'features/checkin/presentation/pages/checkin_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final localDataSource = CheckInLocalDataSourceImpl(sharedPreferences: sharedPreferences);

  final repository = CheckInRepositoryImpl(localDataSource: localDataSource);

  final getCheckInsUseCase = GetCheckInsUseCase(repository);
  final hasCheckedInTodayUseCase = HasCheckedInTodayUseCase(repository);
  final checkInUseCase = CheckInUseCase(repository);

  runApp(DailyCheckInApp(
    getCheckInsUseCase: getCheckInsUseCase,
    hasCheckedInTodayUseCase: hasCheckedInTodayUseCase,
    checkInUseCase: checkInUseCase,
  ));
}

class DailyCheckInApp extends StatelessWidget {
  final GetCheckInsUseCase getCheckInsUseCase;
  final HasCheckedInTodayUseCase hasCheckedInTodayUseCase;
  final CheckInUseCase checkInUseCase;

  const DailyCheckInApp({
    super.key,
    required this.getCheckInsUseCase,
    required this.hasCheckedInTodayUseCase,
    required this.checkInUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckInBloc>(
      create: (_) => CheckInBloc(
        getCheckInsUseCase: getCheckInsUseCase,
        hasCheckedInTodayUseCase: hasCheckedInTodayUseCase,
        checkInUseCase: checkInUseCase,
      )..add(const LoadCheckInsEvent()),
      child: MaterialApp(
        title: 'Daily Check-In',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const CheckInPage(),
      ),
    );
  }
}
