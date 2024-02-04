import 'package:api_manager/auth/firebase_auth/auth_util.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

class InviteLink {
  static Future<void> shareDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://pumpapp.page.link',
      link:
          Uri.parse('https://pumpapp.page.link/pump?personal=$currentUserUid'),
      androidParameters: AndroidParameters(
        packageName: 'br.com.pump.pump',
      ),
      iosParameters: IOSParameters(
        bundleId: 'br.com.pump',
        appStoreId: '1626404347',
      ),
    );

    final ShortDynamicLink dynamicUrl =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    String subject =
        'Pump Training: Cadastre-se e comece a receber seus treinos!';
    await Share.share('$subject\n\n${dynamicUrl.shortUrl}');
  }
}
