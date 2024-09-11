import 'package:flutter/material.dart';
import 'package:seb7a/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchivmentWidget extends StatefulWidget {
  const AchivmentWidget(
      {required this.sliderValueNotifier, required this.hexColor, super.key});
  final Color hexColor;
  final ValueNotifier<double> sliderValueNotifier;
  @override
  State<AchivmentWidget> createState() => _AchivmentWidgetState();
}

class _AchivmentWidgetState extends State<AchivmentWidget> {
  final String goalKey = 'goal';
  @override
  void initState() {
    super.initState();
    setState(() {
      _getGoal();
    });
  }

  void _setGoal(double goal) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setDouble(goalKey, goal);
  }

  void _getGoal() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    widget.sliderValueNotifier.value =
        sharedPreferences.getDouble(goalKey) ?? 33;
  }

  void _incrementValue() {
    final newValue = (widget.sliderValueNotifier.value + 1).clamp(0.0, 100.0);
    widget.sliderValueNotifier.value = newValue;
    _setGoal(newValue);
  }

  void _decrementValue() {
    final newValue = (widget.sliderValueNotifier.value - 1).clamp(0.0, 100.0);
    widget.sliderValueNotifier.value = newValue;
    _setGoal(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.hexColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SimpleTextWidget(text: 'الهدف', color: Colors.white),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _incrementValue,
                icon: const Icon(Icons.add_circle),
                color: Colors.white,
              ),
              ValueListenableBuilder(
                  valueListenable: widget.sliderValueNotifier,
                  builder: (context, value, child) {
                    return SimpleTextWidget(
                        text: '${value.round()}', color: Colors.white);
                  }),
              IconButton(
                onPressed: _decrementValue,
                icon: const Icon(Icons.remove_circle),
                color: Colors.white,
              ),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: widget.sliderValueNotifier,
              builder: (context, value, child) {
                return Slider(
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.white,
                  value: value,
                  max: 100,
                  divisions:
                      5, // Set divisions to 500 for single-step increments
                  label: value.round().toString(),
                  onChanged: (double newValue) {
                    widget.sliderValueNotifier.value = newValue;
                    _setGoal(newValue);
                  },
                );
              })
        ],
      ),
    );
  }
}
