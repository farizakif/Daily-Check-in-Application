import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'features/checkin/data/datasources/checkin_local_data_source.dart';
import 'features/checkin/data/repositories/checkin_repository_impl.dart';
import 'features/checkin/domain/repositories/checkin_repository.dart';
import 'features/checkin/domain/usecases/get_checkin_history.dart';
import 'features/checkin/domain/usecases/get_today_checkin.dart';
import 'features/checkin/domain/usecases/has_checked_in_today_usecase.dart';
import 'features/checkin/domain/usecases/perform_checkin.dart';
import 'features/checkin/presentation/bloc/checkin_bloc.dart';
import 'features/checkin/presentation/pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;

  final localDataSource = await CheckInLocalDataSourceImpl.create();
  final repository = CheckInRepositoryImpl(localDataSource: localDataSource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final CheckInRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CheckInRepository>.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CheckInBloc>(
            create: (context) {
              final repo = context.read<CheckInRepository>();
              final performCheckIn = PerformCheckIn(repo);
              final getCheckInHistory = GetCheckInHistory(repo);
              final hasCheckedInToday = HasCheckedInToday(repo);
              final getTodayCheckIn = GetTodayCheckIn(repo);

              return CheckInBloc(
                performCheckInUseCase: performCheckIn,
                getCheckInHistoryUseCase: getCheckInHistory,
                hasCheckedInTodayUseCase: hasCheckedInToday,
                getTodayCheckInUseCase: getTodayCheckIn,
              );
            },
          ),
        ],
        child: MaterialApp(
          title: 'CheckIn',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const HomePage(),
        ),
      ),
    );
  }
}
