import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/weather/weather.dart';

class SettingsPage extends StatelessWidget {
  static Route route(WeatherCubit cubit) => MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: SettingsPage(),
        ),
      );

  static Widget widget(WeatherCubit cubit) => BlocProvider.value(
        value: cubit,
        child: SettingsPage(),
      );

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;

    return Scaffold(
      appBar: platform == TargetPlatform.macOS
          ? null
          : AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          BlocBuilder<WeatherCubit, WeatherState>(
            buildWhen: (previous, current) =>
                previous.temperatureUnits != current.temperatureUnits,
            builder: (context, state) {
              return ListTile(
                title: const Text('Temperature Units'),
                isThreeLine: true,
                subtitle: const Text(
                    'Use metric measurements for temperature units.'),
                trailing: Switch(
                  value: state.temperatureUnits.isCelcius,
                  onChanged: (_) => context.read<WeatherCubit>().toggleUnits(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
