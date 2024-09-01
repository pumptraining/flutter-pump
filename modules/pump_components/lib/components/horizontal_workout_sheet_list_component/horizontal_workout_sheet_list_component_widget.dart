import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import '../card_workout_sheet_component/card_workout_sheet_component_widget.dart';
import 'horizontal_workout_sheet_list_component_model.dart';
export 'horizontal_workout_sheet_list_component_model.dart';

class HorizontalWorkoutSheetListComponentWidget extends StatefulWidget {
  const HorizontalWorkoutSheetListComponentWidget(
      {super.key,
      required this.dtoList,
      this.onTap,
      this.scrollDirection = Axis.horizontal});

  final List<CardWorkoutSheetDTO> dtoList;
  final Function(CardWorkoutSheetDTO)? onTap;
  final Axis scrollDirection;

  @override
  State<HorizontalWorkoutSheetListComponentWidget> createState() =>
      _HorizontalWorkoutSheetListComponentWidgetState();
}

class _HorizontalWorkoutSheetListComponentWidgetState
    extends State<HorizontalWorkoutSheetListComponentWidget> {
  late HorizontalWorkoutSheetListComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => HorizontalWorkoutSheetListComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: CarouselSlider(
        items: [
          ...widget.dtoList.map((element) {
            return InkWell(
              onTap: () {
                widget.onTap?.call(element);
              },
              child: CardWorkoutSheetComponentWidget(dto: element),
            );
          }).toList()
        ],
        options: CarouselOptions(
          height: MediaQuery.sizeOf(context).height * 0.3,
          aspectRatio: 16 / 9,
          disableCenter: true,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.22,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
