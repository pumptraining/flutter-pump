import 'package:flutter/material.dart';
import 'package:flutter_flow/flutter_flow_model.dart';

class ProfileModel extends FlutterFlowModel {
  dynamic content;

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  List<dynamic> getFAQOptions() {
    return [
      {
        'question':
            'Como faço para ter meu perfil disponível no app do aluno (Pump Training App)?',
        'answer':
            'Para ter o perfil disponível no app do aluno, é necessário estar no plano Pump PRO. Após a mudança de plano, o perfil será automaticamente exibido no app do aluno.',
      },
      {
        'question':
            'Posso receber contato via WhatsApp de alunos interessados?',
        'answer':
            'Sim, para receber contato de alunos interessados via WhatsApp, é necessário estar no plano Pump PRO.',
      },
      {
        'question':
            'Quando estará disponível a venda de programas de treino no Pump Training App?',
        'answer':
            'A venda de programas de treino está em beta e em breve estará disponível para todos os usuários que estiverem no plano Pump PRO.',
      },
      {
        'question': 'Como faço para cadastrar um aluno com um link?',
        'answer':
            'Com um único link, você pode enviar convites para vários alunos simultaneamente, ganhando agilidade. Os alunos aparecerão na lista após se cadastrarem e aceitarem o convite. O plano gratuito permite ter alunos ilimitados.',
      },
      {
        'question': 'O que é um programa de treino?',
        'answer':
            'Um programa de treino é um conjunto de treinos que o aluno realizará durante um determinado período, por exemplo, treino A, treino B, treino C durante 1 mês.',
      },
      {
        'question':
            'Como faço para criar treinos avançados e enviar programas de treino?',
        'answer':
            'Você pode criar treinos com técnicas avançadas, adicionar comentários e até duplicar treinos para ganhar eficiência na criação de novos. Além disso, pode enviar programas de treino para os alunos após eles se cadastrarem e aceitarem o convite.',
      },
    ];
  }
}
