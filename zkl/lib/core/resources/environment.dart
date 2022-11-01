import 'dart:io';

//if you got problems with your endpoint, read FAQ in the docs
const String endpoint = "https://shwehintharsg.com"; //<= Replace with yours

const String appname = "FINE LINE";

const String defaultVpnUsername = "ncpzinkolin@namecheap";
const String defaultVpnPassword = "V6OBm8vwOT";

const bool showAds = true;
const bool groupCountries = true;
const bool showAllCountries = true;

//IOS AppstoreID
//Do not change this without read the instructions
const String vpnExtensionIdentifier = "com.nerdtech.vpn.VPNExtensions";
const String groupIdentifier = "group.com.nerdtech.vpn";
const String appstoreId = "";

const String androidAdmobAppId = "ca-app-pub-1182345835256995~6266110438";
const String iosAdmobAppId = "ca-app-pub-1182345835256995~6266110438";

const String banner1Android = "ca-app-pub-1182345835256995/2590491086"; //BOTTOM_BANNER
const String banner2Android = "ca-app-pub-1182345835256995/7459674383"; //DIALOG_BANNER
const String inters1Android = "ca-app-pub-1182345835256995/1796284166"; //CONNECT_VPN
const String inters2Android = "ca-app-pub-1182345835256995/5543957489"; //DISCONNECT_VPN
const String inters3Android = "ca-app-pub-1182345835256995/4147077349"; //SELECT_SERVER

const String banner1IOS = "ca-app-pub-1182345835256995/2590491086"; //BOTTOM_BANNER
const String banner2IOS = "ca-app-pub-1182345835256995/7459674383"; //DIALOG_BANNER
const String inters1IOS = "ca-app-pub-1182345835256995/1796284166"; //CONNECT_VPN
const String inters2IOS = "ca-app-pub-1182345835256995/5543957489"; //DISCONNECT_VPN
const String inters3IOS = "ca-app-pub-1182345835256995/4147077349"; //SELECT_SERVER

//Do not touch section ===================================================================
const String api = "$endpoint/api/";

String get banner1 => Platform.isIOS ? banner1IOS : banner1Android;
String get banner2 => Platform.isIOS ? banner2IOS : banner2Android;
String get inters1 => Platform.isIOS ? inters1IOS : inters1Android;
String get inters2 => Platform.isIOS ? inters2IOS : inters2Android;
String get inters3 => Platform.isIOS ? inters3IOS : inters3Android;
