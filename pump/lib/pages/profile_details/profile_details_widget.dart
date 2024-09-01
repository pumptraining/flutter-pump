import 'dart:async';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:api_manager/api_requests/pump_api_calls.dart';
import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:pump/flutter_flow/nav/nav.dart';
import 'package:pump_components/components/header_component/header_component_widget.dart';
import 'package:pump_components/components/information_dialog/information_dialog_widget.dart';
import 'package:pump_components/components/pump_app_bar/pump_app_bar.dart';
import 'package:pump_components/components/simple_row_component/simple_row_component_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_details_model.dart';

export 'package:pump/pages/personal_profile/profile14_other_user_model.dart';

class ProfileDetailsWidget extends StatefulWidget {
  const ProfileDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileDetailsWidget> createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends State<ProfileDetailsWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ProfileDetailsModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileDetailsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: PumpAppBar(title: 'Mais Opções'),
      body: SingleChildScrollView(
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        HeaderComponentWidget(title: 'Configurações'),
        SimpleRowComponentWidget(
          title: 'Editar perfil',
          onTap: () => _editPressed(),
        ),
        HeaderComponentWidget(title: 'Compartilhar'),
        SimpleRowComponentWidget(
          title: 'Convide seus amigos',
          onTap: () => _shareFriendPressed(),
        ),
        SimpleRowComponentWidget(
          title: 'Indique para um Personal Trainer',
          onTap: () => _sharePersonalTrainerPressed(),
        ),
        HeaderComponentWidget(title: 'Termos'),
        SimpleRowComponentWidget(
          title: 'Termos de uso',
          onTap: () => _termsOfUsePressed(),
        ),
        SimpleRowComponentWidget(
          title: 'Política de privacidade',
          onTap: () => _policiesPressed(),
        ),
        HeaderComponentWidget(title: 'Minha Conta'),
        SimpleRowComponentWidget(
          title: 'Deletar conta',
          onTap: () => _deleteAccountPressed(),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 48),
          child: SimpleRowComponentWidget(
            title: 'Logout',
            onTap: () async => _logoutPressed(),
          ),
        ),
      ],
    );
  }

  void _editPressed() {
    context.pushNamed('EditProfile').then((value) {
      if (value != null && value is bool && value == true) {
        context.pop(true);
      }
    });
  }

  void _shareFriendPressed() {
    Share.share('https://pumpapp.page.link/pump');
  }

  void _sharePersonalTrainerPressed() {
    Share.share('https://pump-personal-trainer.webflow.io/');
  }

  void _termsOfUsePressed() {
    launchURL('https://pump-personal-trainer.webflow.io/termos-de-uso');
  }

  void _policiesPressed() {
    launchURL(
        'https://pump-personal-trainer.webflow.io/politica-de-privacidade');
  }

  void _deleteAccountPressed() async {
    HapticFeedback.mediumImpact();
    await showAlignedDialog(
      context: context,
      isGlobal: true,
      avoidOverflow: false,
      targetAnchor:
          AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
      followerAnchor:
          AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
      builder: (dialogContext) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            child: InformationDialogWidget(
              title: 'Atenção',
              message:
                  'Tem certeza de que deseja excluir sua conta no Pump? Essa ação é irreversível e todos os seus dados serão perdidos.',
              actionButtonTitle: 'Deletar',
            ),
          ),
        );
      },
    ).then(
      (value) async {
        if (value == 'leave') {
          unawaited(PumpGroup.userDeleteAccountCall.call());
          final storage = await SharedPreferences.getInstance();
          storage.remove('uid');
          authManager.signOut();
          GoRouter.of(context).clearRedirectLocation();

          context.goNamedAuth('SignIn', context.mounted);
        }
      },
    );
  }

  void _logoutPressed() async {
    final storage = await SharedPreferences.getInstance();
    storage.remove('uid');

    await authManager.signOut();
    GoRouter.of(context).clearRedirectLocation();

    context.goNamedAuth('SignIn', context.mounted);
  }
}
