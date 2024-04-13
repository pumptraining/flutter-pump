import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/common/loader_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:pump_components/components/bottom_button_fixed/bottom_button_fixed_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'package:pump_components/components/review_bottom_sheet/review_bottom_sheet_widget.dart';
import 'package:pump_components/components/review_card/review_card_widget.dart';
import 'package:pump_components/components/two_count_component/two_count_component_widget.dart';
import 'review_screen_model.dart';
export 'review_screen_model.dart';

class ReviewScreenWidget extends StatefulWidget {
  const ReviewScreenWidget(
      {Key? key, this.workoutId, this.personalId, this.isPersonal})
      : super(key: key);

  final String? workoutId;
  final String? personalId;
  final bool? isPersonal;

  @override
  // ignore: library_private_types_in_public_api
  _ReviewScreenWidgetState createState() => _ReviewScreenWidgetState();
}

class _ReviewScreenWidgetState extends State<ReviewScreenWidget> {
  late ReviewScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String workoutId = '';
  String personalId = '';
  ApiLoaderController _apiLoaderController = ApiLoaderController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewScreenModel());

    workoutId = widget.workoutId ?? '';
    personalId = widget.personalId ?? '';
    _model.isPersonal = widget.isPersonal ?? false;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: PumpAppBar(title: 'Avaliações'),
      body: ApiLoaderWidget(
          apiCall: workoutId.isNotEmpty
              ? PumpGroup.workoutRatingsCall
              : PumpGroup.getPersonalReviewsCall,
          params: workoutId.isNotEmpty
              ? {'workoutId': workoutId}
              : {'personalId': personalId},
          controller: _apiLoaderController,
          builder: (context, snapshot) {
            if (workoutId.isEmpty) {
              _model.content = snapshot?.data?.jsonBody['response'];
            } else {
              _model.content = snapshot?.data?.jsonBody;
            }

            return buildContent(context);
          }),
    );
  }

  SafeArea buildContent(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 100.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TwoCountComponentWidget(
                    firstTitle: 'avaliações',
                    secondTitle: 'nota',
                    firstCount: '${_model.content['ratings']?.length}',
                    secondCount: _model.content['averageRating'],
                    secondIcon: Icons.star_border_outlined,
                    firstIcon: Icons.people_alt_outlined),
                SizedBox(
                  height: 16,
                ),
                Column(
                  children: List.generate(
                    _model.content['ratings'].length,
                    (index) {
                      final feedback = _model.content['ratings'][index];
                      return ReviewCardWidget(
                        name: _model.getFeedbackName(feedback),
                        feedback: feedback['feedbackText'],
                        imageUrl: feedback['imageUrl'],
                        rating: feedback['rating'],
                        showBorder: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomButtonFixedWidget(
              buttonTitle: 'Avaliar',
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: ReviewBottomSheetWidget(
                        workoutId: workoutId.isEmpty ? null : workoutId,
                        personalId: personalId,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
