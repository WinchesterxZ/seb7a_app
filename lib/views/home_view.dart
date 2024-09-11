import 'package:flutter/material.dart';
import 'package:seb7a/widgets/achivment_widget.dart';
import 'package:seb7a/widgets/body_widget.dart';
import 'package:seb7a/widgets/bottom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier<double> _sliderValueNotifier = ValueNotifier<double>(33);
  final ValueNotifier<bool> _resetNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isColorEnabled = ValueNotifier<bool>(false);
  final ValueNotifier<Color> _colorNotifier =
      ValueNotifier<Color>(const Color(0xff81001c));

  static const  String colorKey = 'color';

  @override
  void initState() {
    super.initState();
    _getColor();
  }

  void _resetValues() {
    _resetNotifier.value = true; // Trigger the reset
    Future.delayed(const Duration(milliseconds: 100), () {
      _resetNotifier.value = false; // Reset notifier after reset
    });
  }

  Future<void> _getColor() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _colorNotifier.value =
        Color(sharedPreferences.getInt(colorKey) ?? 0xff81001c);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: ValueListenableBuilder(
            valueListenable: _colorNotifier,
            builder: (context, color, child) {
             return  Scaffold(
                  floatingActionButton: FloatingActionButton(
                    foregroundColor: Colors.white,
                    onPressed: _resetValues,
                    backgroundColor: color,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.refresh),
                  ),
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor:color,
                    actions: [
                      ValueListenableBuilder(
                          valueListenable: _isColorEnabled,
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: () {
                                _isColorEnabled.value = !_isColorEnabled.value;
                              },
                              icon: Icon(_isColorEnabled.value
                                  ? Icons.color_lens_outlined
                                  : Icons.color_lens),
                              color: Colors.white,
                            );
                          })
                    ],
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AchivmentWidget(
                          sliderValueNotifier: _sliderValueNotifier,
                          hexColor: color,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: BodyWidget(
                          sliderValueNotifier: _sliderValueNotifier,
                          hexColor: color,
                          resetNotifier: _resetNotifier,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: BottomWidget(
                            colorNotifier: _colorNotifier,
                            isColorEnabled: _isColorEnabled,
                          ))
                    ],
                  ));
            }),
      ),
    );
  }
}
