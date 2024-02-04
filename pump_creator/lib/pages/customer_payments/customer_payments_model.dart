import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';

class CustomerPaymentsModel extends FlutterFlowModel {
  
  final unfocusNode = FocusNode();
  dynamic content;

  bool? checkboxValue;

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  List<dynamic> getQuestions() {
    return [
      {
        'question': 'Qual é a taxa de processamento para recebimento de pagamentos na minha conta?',
        'answer': 'A taxa de recorrência é fixa em 4,99%, aplicada apenas quando o aluno paga a fatura.',
      },
      {
        'question': 'Em quanto tempo os pagamentos estarão disponíveis na minha conta bancária?',
        'answer': 'Normalmente, os pagamentos são transferidos para sua conta bancária em 30 dias a partir do pagamento da fatura, sujeito a processamento bancário padrão.',
      },
      {
        'question': 'Qual a forma de pagamento disponível para os alunos?',
        'answer': 'A forma de pagamento para os alunos é exclusivamente por meio de cartão de crédito.',
      },
      {
        'question': 'Como funcionam as cobranças mensais no cartão de crédito?',
        'answer': 'As cobranças mensais são automáticas no cartão de crédito cadastrado, garantindo praticidade e pontualidade nos pagamentos.'
      },
      {
        'question': 'Por que preciso cadastrar minha conta bancária na Stripe?',
        'answer': 'Ao cadastrar sua conta bancária na Stripe, você habilita a funcionalidade de receber pagamentos e criar assinaturas mensais para seus alunos de maneira eficiente e segura. A Stripe é nossa parceira de confiança para processamento de pagamentos, garantindo transações seguras e repasses precisos para sua conta bancária. Além disso, o cadastro na Stripe é fundamental para proporcionar uma experiência financeira integrada e transparente em nossa plataforma.',
      },
    ];
  }

  bool showTerms() {
    if (content['bankStatus'] == null || content['bankStatus'] == 'pending_onboarding') {
      return true;
    }
    return false;
  }

  String getBottomButtonTitle() {
    if (content['bankStatus'] == null || content['bankStatus'] == 'pending_onboarding') {
      return 'Conectar Conta';
    }

    if (content['bankStatus'] == 'pending_validation') {
      return 'Atualizar Conta';
    }

    return 'Criar Plano de Assinatura';
  }

  String getTitle() {
    if (content['bankStatus'] == null || content['bankStatus'] == 'pending_onboarding') {
      return 'Conectar Conta Bancária';
    }

    if (content['bankStatus'] == 'pending_validation') {
      return 'Conta Bloqueada';
    }

    return 'Conta Conectada';
  }

  String getSubtitle() {
    if (content['bankStatus'] == null || content['bankStatus'] == 'pending_onboarding') {
      return 'Desbloqueie as assinaturas mensais agora!\nConecte sua conta bancária para receber os pagamentos dos seus alunos de maneira prática e segura';
    }

    if (content['bankStatus'] == 'pending_validation') {
      return 'Seus dados de pagamento precisam de atualização. Por favor, verifique e atualize suas informações na Stripe para garantir o recebimento dos pagamentos.';
    }

    return 'Você já pode criar planos de assinatura! Comece a receber os pagamentos dos seus alunos de maneira prática e segura';
  }

  Color circleColor(BuildContext context) {
    if (content['bankStatus'] == null || content['bankStatus'] == 'pending_onboarding') {
      return FlutterFlowTheme.of(context).secondaryBackground;
    }

    if (content['bankStatus'] == 'pending_validation') {
      return FlutterFlowTheme.of(context).error;
    }

    return FlutterFlowTheme.of(context).primary;
  }
}
