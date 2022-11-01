import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/provider/adsProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/warna.dart';
import '../../core/utils/preferences.dart';
import '../../main.dart';
import '../components/customCard.dart';
import '../components/customDivider.dart';

class PrivacyPolicyIntroScreen extends StatefulWidget {
  final RootState? rootState;

  const PrivacyPolicyIntroScreen({Key? key, this.rootState}) : super(key: key);

  @override
  _PrivacyPolicyIntroScreenState createState() => _PrivacyPolicyIntroScreenState();
}

class _PrivacyPolicyIntroScreenState extends State<PrivacyPolicyIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomCard(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("privacypolicy_title".tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  children: [
                    Text("privacypolicy_subtitle".tr().replaceAll("\$appname", appname)),
                    ColumnDivider(),
                    Text("privacypolicy_h2".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ColumnDivider(space: 5),
                    _privacyPointWidget("privacypolicy_title1".tr(), "privacypolicy_desc1".tr()),
                    ColumnDivider(),
                    _privacyPointWidget("privacypolicy_title2".tr(), "privacypolicy_desc2".tr()),
                    ColumnDivider(),
                    _privacyPointWidget("privacypolicy_title3".tr(), "privacypolicy_desc3".tr()),
                    ColumnDivider(),
                    Text("privacypolicy_footer".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    ),
                  ),
                  child: Text(
                    "accept_continue".tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _accAndContinueClick,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  void _accAndContinueClick() {
    Preferences.init().then((value) {
      widget.rootState!.setState(() {
        value.acceptPrivacyPolicy();
      });
    });
  }

  Widget _privacyPointWidget(String title, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 3),
          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
          width: 15,
          height: 15,
        ),
        RowDivider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(message),
            ],
          ),
        )
      ],
    );
  }
}
