import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/theme/cubit/theme_cubit.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_repository/weather_repository.dart';
import 'dart:io';

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key, required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(key: key);

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _weatherRepository,
        child: BlocProvider(
          create: (_) => ThemeCubit(),
          child: WeatherAppView(),
        ));
  }
}

class WeatherAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ThemeCubit, Color>(
      builder: (context, color) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: color,
            textTheme: GoogleFonts.rajdhaniTextTheme(),
            appBarTheme: AppBarTheme(
              textTheme: GoogleFonts.rajdhaniTextTheme(textTheme).apply(
                bodyColor: Colors.white,
              ),
            ),
          ),
          home: _getPlatformSpecificWidget(),
        );
      },
    );
  }
}

Widget _getPlatformSpecificWidget() {
  return Platform.isMacOS ? WeatherPageMacOS() : WeatherPage();
}
