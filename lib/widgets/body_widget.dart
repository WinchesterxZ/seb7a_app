import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seb7a/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodyWidget extends StatefulWidget {
  const BodyWidget(
      {required this.resetNotifier,
      required this.sliderValueNotifier,
      required this.hexColor,
      super.key});
  final Color hexColor;
  final ValueNotifier<double> sliderValueNotifier;
  final ValueNotifier<bool> resetNotifier;

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  double _estghfarValue = 0;
  int _time = 0;
  int _sum = 0;
  final String estghfarKey = 'estghfar';
  final String timeKey = 'key';
  final String sumKey = 'sum';

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadValues();
    });
    widget.resetNotifier.addListener(_handleReset);
  }

  @override
  void dispose() {
    widget.resetNotifier.removeListener(_handleReset);
    super.dispose();
  }

  Future<void> _loadValues() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      _estghfarValue = sharedPreferences.getInt(estghfarKey)?.toDouble() ?? 0.0;
      _time = sharedPreferences.getInt(timeKey) ?? 0;
      _sum = sharedPreferences.getInt(sumKey) ?? 0;
    });
  }

  Future<void> _setEstghfar(double estghfar) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setInt(estghfarKey, estghfar.toInt());
  }

  Future<void> _setTime(int time) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setInt(timeKey, time);
  }

  Future<void> _setSum(int time) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setInt(sumKey, _sum);
  }

  void _incrementEstghfar() {
    final newValue = _estghfarValue + 1;
    if (newValue < widget.sliderValueNotifier.value) {
      if (widget.sliderValueNotifier.value != 0) {
        setState(() {
          _estghfarValue++;
          _sum++;
          _setSum(_sum);
          _setEstghfar(_estghfarValue);
          _loadValues();
        });
      }
    } else if (newValue == widget.sliderValueNotifier.value) {
      setState(() {
        _sum++;
        _setSum(_sum);
        _estghfarValue = 0;
        _time++;
        _setEstghfar(_estghfarValue);
        _setTime(_time);
        _loadValues();
      });
    }
  }

  void _handleReset() {
    if (widget.resetNotifier.value) {
      setState(() {
        _estghfarValue = 0;
        _time = 0;
        _sum = 0;
        _setEstghfar(_estghfarValue);
        _setTime(_time);
        _setSum(_sum);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemsList = [
      SimpleTextWidget(
        text: 'الاستغفار',
        color: widget.hexColor,
      ),
      SimpleTextWidget(
        text: '${_estghfarValue.toInt()}',
        color: widget.hexColor,
      ),
      CircularPercentIndicator(
        radius: 100,
        lineWidth: 5,
        percent:
            (_estghfarValue / widget.sliderValueNotifier.value).clamp(0.0, 1.0),
        center: IconButton(
            onPressed: _incrementEstghfar,
            icon: Icon(
              Icons.touch_app,
              size: 80,
              color: widget.hexColor,
            )),
        backgroundColor: widget.hexColor.withOpacity(0.2),
        progressColor: widget.hexColor,
      ),
      SimpleTextWidget(
        text: 'مرات التكرار : $_time',
        color: widget.hexColor,
      ),
      SimpleTextWidget(
        text: 'المجموع : $_sum',
        color: widget.hexColor,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: itemsList
            .map((item) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: item,
                ))
            .toList(),
      ),
    );
  }
}
