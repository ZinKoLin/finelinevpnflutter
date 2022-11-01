import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';

import '../../core/provider/adsProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/warna.dart';
import '../components/customDivider.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(LineIcons.angleLeft), onPressed: () => Navigator.pop(context)),
        elevation: 0,
        title: Text("about".tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(text: "$appname ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600)),
                TextSpan(text: "VPN", style: GoogleFonts.poppins(color: primaryColor, fontSize: 30, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("${"version".tr()} ${snapshot.data!.version}", textAlign: TextAlign.center);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          ColumnDivider(),
          LottieBuilder.asset(
            "assets/animations/about.json",
            height: 300,
            fit: BoxFit.contain,
          ),
          ColumnDivider(),
          Text(
            "$appname ${"about_detail".tr()}",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }
}
