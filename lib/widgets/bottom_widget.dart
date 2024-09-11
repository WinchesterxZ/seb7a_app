import 'package:flutter/material.dart';
import 'package:seb7a/widgets/radio_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget(
      {required this.isColorEnabled, required this.colorNotifier, super.key});
  final ValueNotifier<Color> colorNotifier;
  final ValueNotifier<bool> isColorEnabled;

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  Color mainColor = const Color(0xff81001c);
  Color secondColor = const Color(0xff14212A);
  Color thirdColor = const Color(0xff62249f);
  final String radioKey = 'radio';
  static const  String colorKey = 'color';


  Future<void> _setRadio(int color) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setInt(radioKey, color);
    await sharedPreferences.setInt(colorKey, color);

  }

  Future<void> _getRadio() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    widget.colorNotifier.value =
        Color(sharedPreferences.getInt(radioKey) ?? 0xff81001c);
  }


  @override
  void initState() {
    super.initState();
    _getRadio();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.isColorEnabled,
        builder: (context, isEnabled, child) {
          return Visibility(
              visible: isEnabled,
              child: ValueListenableBuilder(
                  valueListenable: widget.colorNotifier,
                  builder: (context, selectedColor, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioWidget(
                            color: mainColor,
                            groupValue: selectedColor,
                            value: mainColor,
                            onChanged: (val) {
                              widget.colorNotifier.value = val!;
                              _setRadio(val.value);
                            }),
                        RadioWidget(
                            color: secondColor,
                            groupValue: selectedColor,
                            value: secondColor,
                            onChanged: (val) {
                              widget.colorNotifier.value = val!;
                              _setRadio(val.value);

                            }),
                        RadioWidget(
                            color: thirdColor,
                            groupValue: selectedColor,
                            value: thirdColor,
                            onChanged: (val) {
                              widget.colorNotifier.value = val!;
                              _setRadio(val.value);
                            }),
                      ],
                    );
                  }));
        });
  }
}
