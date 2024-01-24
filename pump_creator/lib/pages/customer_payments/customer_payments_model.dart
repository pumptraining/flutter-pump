import 'package:flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

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
}
