import 'dart:ui';
import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/Setup/otp/otp_screen.dart';
import 'package:c0nnect/helper/config.dart';
import 'package:c0nnect/widget/AcceptTermsWidget.dart';
import 'package:country_codes/country_codes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:c0nnect/globals.dart' as globals;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PageController _pageController;
  int currentIndex = 0;

  TextEditingController _phoneNumberController = TextEditingController();
  String countrySelected = "🇺🇸";
  String countryCode = "1";
  String finalPhoneNumber = "";

  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  bool isValidNumber=false;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
//    getCountryCode();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void getCountryCode()async{
    print('code');
//    await CountryCodes.init();
//    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
//    String isoCountryCode = systemLocales.first.countryCode;

//    countrySelected = getFlags(isoCountryCode);
//    final CountryDetails details = CountryCodes.detailsForLocale();
//    countryCode = details.dialCode;

    await CountryCodes.init(); // Optionally, you may provide a `Locale` to get countrie's localizadName

    final Locale deviceLocale = CountryCodes.getDeviceLocale();
    print(deviceLocale.languageCode); // Displays en
    print(deviceLocale.countryCode); // Displays US

    final CountryDetails details = CountryCodes.detailsForLocale();
    print(details.alpha2Code); // Displays alpha2Code, for example US.
    print(details.dialCode); // Displays the dial code, for example +1.
    print(details.name); // Displays the extended name, for example United States.
    print(details.localizedName); //

    print('code--${deviceLocale.countryCode} --- ${details.dialCode}');

  }


  String getFlags($code) {
    if ($code == 'AD') return '🇦🇩';
    if ($code == 'AE') return '🇦🇪';
    if ($code == 'AF') return '🇦🇫';
    if ($code == 'AG') return '🇦🇬';
    if ($code == 'AI') return '🇦🇮';
    if ($code == 'AL') return '🇦🇱';
    if ($code == 'AM') return '🇦🇲';
    if ($code == 'AO') return '🇦🇴';
    if ($code == 'AQ') return '🇦🇶';
    if ($code == 'AR') return '🇦🇷';
    if ($code == 'AS') return '🇦🇸';
    if ($code == 'AT') return '🇦🇹';
    if ($code == 'AU') return '🇦🇺';
    if ($code == 'AW') return '🇦🇼';
    if ($code == 'AX') return '🇦🇽';
    if ($code == 'AZ') return '🇦🇿';
    if ($code == 'BA') return '🇧🇦';
    if ($code == 'BB') return '🇧🇧';
    if ($code == 'BD') return '🇧🇩';
    if ($code == 'BE') return '🇧🇪';
    if ($code == 'BF') return '🇧🇫';
    if ($code == 'BG') return '🇧🇬';
    if ($code == 'BH') return '🇧🇭';
    if ($code == 'BI') return '🇧🇮';
    if ($code == 'BJ') return '🇧🇯';
    if ($code == 'BL') return '🇧🇱';
    if ($code == 'BM') return '🇧🇲';
    if ($code == 'BN') return '🇧🇳';
    if ($code == 'BO') return '🇧🇴';
    if ($code == 'BQ') return '🇧🇶';
    if ($code == 'BR') return '🇧🇷';
    if ($code == 'BS') return '🇧🇸';
    if ($code == 'BT') return '🇧🇹';
    if ($code == 'BV') return '🇧🇻';
    if ($code == 'BW') return '🇧🇼';
    if ($code == 'BY') return '🇧🇾';
    if ($code == 'BZ') return '🇧🇿';
    if ($code == 'CA') return '🇨🇦';
    if ($code == 'CC') return '🇨🇨';
    if ($code == 'CD') return '🇨🇩';
    if ($code == 'CF') return '🇨🇫';
    if ($code == 'CG') return '🇨🇬';
    if ($code == 'CH') return '🇨🇭';
    if ($code == 'CI') return '🇨🇮';
    if ($code == 'CK') return '🇨🇰';
    if ($code == 'CL') return '🇨🇱';
    if ($code == 'CM') return '🇨🇲';
    if ($code == 'CN') return '🇨🇳';
    if ($code == 'CO') return '🇨🇴';
    if ($code == 'CR') return '🇨🇷';
    if ($code == 'CU') return '🇨🇺';
    if ($code == 'CV') return '🇨🇻';
    if ($code == 'CW') return '🇨🇼';
    if ($code == 'CX') return '🇨🇽';
    if ($code == 'CY') return '🇨🇾';
    if ($code == 'CZ') return '🇨🇿';
    if ($code == 'DE') return '🇩🇪';
    if ($code == 'DJ') return '🇩🇯';
    if ($code == 'DK') return '🇩🇰';
    if ($code == 'DM') return '🇩🇲';
    if ($code == 'DO') return '🇩🇴';
    if ($code == 'DZ') return '🇩🇿';
    if ($code == 'EC') return '🇪🇨';
    if ($code == 'EE') return '🇪🇪';
    if ($code == 'EG') return '🇪🇬';
    if ($code == 'EH') return '🇪🇭';
    if ($code == 'ER') return '🇪🇷';
    if ($code == 'ES') return '🇪🇸';
    if ($code == 'ET') return '🇪🇹';
    if ($code == 'FI') return '🇫🇮';
    if ($code == 'FJ') return '🇫🇯';
    if ($code == 'FK') return '🇫🇰';
    if ($code == 'FM') return '🇫🇲';
    if ($code == 'FO') return '🇫🇴';
    if ($code == 'FR') return '🇫🇷';
    if ($code == 'GA') return '🇬🇦';
    if ($code == 'GB') return '🇬🇧';
    if ($code == 'GD') return '🇬🇩';
    if ($code == 'GE') return '🇬🇪';
    if ($code == 'GF') return '🇬🇫';
    if ($code == 'GG') return '🇬🇬';
    if ($code == 'GH') return '🇬🇭';
    if ($code == 'GI') return '🇬🇮';
    if ($code == 'GL') return '🇬🇱';
    if ($code == 'GM') return '🇬🇲';
    if ($code == 'GN') return '🇬🇳';
    if ($code == 'GP') return '🇬🇵';
    if ($code == 'GQ') return '🇬🇶';
    if ($code == 'GR') return '🇬🇷';
    if ($code == 'GS') return '🇬🇸';
    if ($code == 'GT') return '🇬🇹';
    if ($code == 'GU') return '🇬🇺';
    if ($code == 'GW') return '🇬🇼';
    if ($code == 'GY') return '🇬🇾';
    if ($code == 'HK') return '🇭🇰';
    if ($code == 'HM') return '🇭🇲';
    if ($code == 'HN') return '🇭🇳';
    if ($code == 'HR') return '🇭🇷';
    if ($code == 'HT') return '🇭🇹';
    if ($code == 'HU') return '🇭🇺';
    if ($code == 'ID') return '🇮🇩';
    if ($code == 'IE') return '🇮🇪';
    if ($code == 'IL') return '🇮🇱';
    if ($code == 'IM') return '🇮🇲';
    if ($code == 'IN') return '🇮🇳';
    if ($code == 'IO') return '🇮🇴';
    if ($code == 'IQ') return '🇮🇶';
    if ($code == 'IR') return '🇮🇷';
    if ($code == 'IS') return '🇮🇸';
    if ($code == 'IT') return '🇮🇹';
    if ($code == 'JE') return '🇯🇪';
    if ($code == 'JM') return '🇯🇲';
    if ($code == 'JO') return '🇯🇴';
    if ($code == 'JP') return '🇯🇵';
    if ($code == 'KE') return '🇰🇪';
    if ($code == 'KG') return '🇰🇬';
    if ($code == 'KH') return '🇰🇭';
    if ($code == 'KI') return '🇰🇮';
    if ($code == 'KM') return '🇰🇲';
    if ($code == 'KN') return '🇰🇳';
    if ($code == 'KP') return '🇰🇵';
    if ($code == 'KR') return '🇰🇷';
    if ($code == 'KW') return '🇰🇼';
    if ($code == 'KY') return '🇰🇾';
    if ($code == 'KZ') return '🇰🇿';
    if ($code == 'LA') return '🇱🇦';
    if ($code == 'LB') return '🇱🇧';
    if ($code == 'LC') return '🇱🇨';
    if ($code == 'LI') return '🇱🇮';
    if ($code == 'LK') return '🇱🇰';
    if ($code == 'LR') return '🇱🇷';
    if ($code == 'LS') return '🇱🇸';
    if ($code == 'LT') return '🇱🇹';
    if ($code == 'LU') return '🇱🇺';
    if ($code == 'LV') return '🇱🇻';
    if ($code == 'LY') return '🇱🇾';
    if ($code == 'MA') return '🇲🇦';
    if ($code == 'MC') return '🇲🇨';
    if ($code == 'MD') return '🇲🇩';
    if ($code == 'ME') return '🇲🇪';
    if ($code == 'MF') return '🇲🇫';
    if ($code == 'MG') return '🇲🇬';
    if ($code == 'MH') return '🇲🇭';
    if ($code == 'MK') return '🇲🇰';
    if ($code == 'ML') return '🇲🇱';
    if ($code == 'MM') return '🇲🇲';
    if ($code == 'MN') return '🇲🇳';
    if ($code == 'MO') return '🇲🇴';
    if ($code == 'MP') return '🇲🇵';
    if ($code == 'MQ') return '🇲🇶';
    if ($code == 'MR') return '🇲🇷';
    if ($code == 'MS') return '🇲🇸';
    if ($code == 'MT') return '🇲🇹';
    if ($code == 'MU') return '🇲🇺';
    if ($code == 'MV') return '🇲🇻';
    if ($code == 'MW') return '🇲🇼';
    if ($code == 'MX') return '🇲🇽';
    if ($code == 'MY') return '🇲🇾';
    if ($code == 'MZ') return '🇲🇿';
    if ($code == 'NA') return '🇳🇦';
    if ($code == 'NC') return '🇳🇨';
    if ($code == 'NE') return '🇳🇪';
    if ($code == 'NF') return '🇳🇫';
    if ($code == 'NG') return '🇳🇬';
    if ($code == 'NI') return '🇳🇮';
    if ($code == 'NL') return '🇳🇱';
    if ($code == 'NO') return '🇳🇴';
    if ($code == 'NP') return '🇳🇵';
    if ($code == 'NR') return '🇳🇷';
    if ($code == 'NU') return '🇳🇺';
    if ($code == 'NZ') return '🇳🇿';
    if ($code == 'OM') return '🇴🇲';
    if ($code == 'PA') return '🇵🇦';
    if ($code == 'PE') return '🇵🇪';
    if ($code == 'PF') return '🇵🇫';
    if ($code == 'PG') return '🇵🇬';
    if ($code == 'PH') return '🇵🇭';
    if ($code == 'PK') return '🇵🇰';
    if ($code == 'PL') return '🇵🇱';
    if ($code == 'PM') return '🇵🇲';
    if ($code == 'PN') return '🇵🇳';
    if ($code == 'PR') return '🇵🇷';
    if ($code == 'PS') return '🇵🇸';
    if ($code == 'PT') return '🇵🇹';
    if ($code == 'PW') return '🇵🇼';
    if ($code == 'PY') return '🇵🇾';
    if ($code == 'QA') return '🇶🇦';
    if ($code == 'RE') return '🇷🇪';
    if ($code == 'RO') return '🇷🇴';
    if ($code == 'RS') return '🇷🇸';
    if ($code == 'RU') return '🇷🇺';
    if ($code == 'RW') return '🇷🇼';
    if ($code == 'SA') return '🇸🇦';
    if ($code == 'SB') return '🇸🇧';
    if ($code == 'SC') return '🇸🇨';
    if ($code == 'SD') return '🇸🇩';
    if ($code == 'SE') return '🇸🇪';
    if ($code == 'SG') return '🇸🇬';
    if ($code == 'SH') return '🇸🇭';
    if ($code == 'SI') return '🇸🇮';
    if ($code == 'SJ') return '🇸🇯';
    if ($code == 'SK') return '🇸🇰';
    if ($code == 'SL') return '🇸🇱';
    if ($code == 'SM') return '🇸🇲';
    if ($code == 'SN') return '🇸🇳';
    if ($code == 'SO') return '🇸🇴';
    if ($code == 'SR') return '🇸🇷';
    if ($code == 'SS') return '🇸🇸';
    if ($code == 'ST') return '🇸🇹';
    if ($code == 'SV') return '🇸🇻';
    if ($code == 'SX') return '🇸🇽';
    if ($code == 'SY') return '🇸🇾';
    if ($code == 'SZ') return '🇸🇿';
    if ($code == 'TC') return '🇹🇨';
    if ($code == 'TD') return '🇹🇩';
    if ($code == 'TF') return '🇹🇫';
    if ($code == 'TG') return '🇹🇬';
    if ($code == 'TH') return '🇹🇭';
    if ($code == 'TJ') return '🇹🇯';
    if ($code == 'TK') return '🇹🇰';
    if ($code == 'TL') return '🇹🇱';
    if ($code == 'TM') return '🇹🇲';
    if ($code == 'TN') return '🇹🇳';
    if ($code == 'TO') return '🇹🇴';
    if ($code == 'TR') return '🇹🇷';
    if ($code == 'TT') return '🇹🇹';
    if ($code == 'TV') return '🇹🇻';
    if ($code == 'TW') return '🇹🇼';
    if ($code == 'TZ') return '🇹🇿';
    if ($code == 'UA') return '🇺🇦';
    if ($code == 'UG') return '🇺🇬';
    if ($code == 'UM') return '🇺🇲';
    if ($code == 'US') return '🇺🇸';
    if ($code == 'UY') return '🇺🇾';
    if ($code == 'UZ') return '🇺🇿';
    if ($code == 'VA') return '🇻🇦';
    if ($code == 'VC') return '🇻🇨';
    if ($code == 'VE') return '🇻🇪';
    if ($code == 'VG') return '🇻🇬';
    if ($code == 'VI') return '🇻🇮';
    if ($code == 'VN') return '🇻🇳';
    if ($code == 'VU') return '🇻🇺';
    if ($code == 'WF') return '🇼🇫';
    if ($code == 'WS') return '🇼🇸';
    if ($code == 'XK') return '🇽🇰';
    if ($code == 'YE') return '🇾🇪';
    if ($code == 'YT') return '🇾🇹';
    if ($code == 'ZA') return '🇿🇦';
    if ($code == 'ZM') return '🇿🇲';
    return '🏳';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  )),
              child: PageView(
                onPageChanged: (int page) {
                  setState(() {
                    currentIndex = page;
                  });
                },
                controller: _pageController,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 120, left: 30, right: 50, bottom: 13),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(),
                          Text(
                            "Welcome 👋",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "We are happy to get you onboard",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Please swipe though our onboarding screens or continueq directly by inputting your number below.",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          Row(children: [
                            Expanded(
                                child: Container(
                                    child: Image.asset(
                                        "assets/images/onboarding1.png"))),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  makePage(
                      reverse: true,
                      image: 'assets/images/onboarding2.png',
                      title: Strings.stepTwoTitle,
                      content: Strings.stepTwoContent),
                  makePage(
                      image: 'assets/images/people3.jpg',
                      title: Strings.stepThreeTitle,
                      content: Strings.stepThreeContent),
                  Container(
                    padding: EdgeInsets.fromLTRB(32, 20, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Hop on!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Yehhhh IDK you probably shouldn't",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
//                Padding(
//                  padding: const EdgeInsets.only(top: 16.0),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(30),
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.5),
//                          spreadRadius: 1,
//                          blurRadius: 5,
//                          offset: Offset(0, 3), // changes position of shadow
//                        ),
//                      ],
//                    ),
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                        VerticalDivider(),
//                        GestureDetector(
//                          onTap: () {
//                            showCountryPicker(
//                              context: context,
//                              showPhoneCode: true, // optional. Shows phone code before the country name.
//                              onSelect: (Country country) {
//                                print('Select country: ${country.displayName}');
//                                setState(() {
//                                  countrySelected = getFlags(country.countryCode);
//                                  print('Country Emoji:' + countrySelected);
//                                  countryCode = country.phoneCode;
//                                });
//
//                              },
//                            );
//
//                            HapticFeedback.heavyImpact();
//                          },
//                          child: Row(
//                            children: [
//                              Text(
//                                countrySelected,
//                                style: TextStyle(fontSize: 30),
//                              ),
//                              IconButton(
//                                  icon: Icon(
//                                    Icons.arrow_drop_down,
//                                    color: Colors.black,
//                                  ),
//                                  onPressed: null,
//                                  iconSize: 25),
//                            ],
//                          ),
//                        ),
//                        Container(
//                          width: 0.5,
//                          height: 30,
//                          color: Colors.grey,
//                        ),
//                        VerticalDivider(),
//                        Text(
//                          countryCode,
//                          style: TextStyle(color: Colors.grey, fontSize: 18),
//                        ),
//                        Flexible(
//                          child: TextField(
//                            controller: _phoneNumberController,
//                            autocorrect: false,
////                            maxLength: 10,
//                            keyboardType: TextInputType.number,
//                            decoration: InputDecoration(
//                              counterText: '',
//                              hintText: '(778) 266 6597',
//                              hintStyle: TextStyle(
//                                  color: Colors.grey,
//                                  fontSize: 15,
//                                  fontWeight: FontWeight.w300),
//                              border: InputBorder.none,
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
//                    getPhoneNumber(number.phoneNumber);
                    finalPhoneNumber = number.phoneNumber;
                    },
                    onInputValidated: (bool value) {
                      print(value);
                      isValidNumber = value;
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: _phoneNumberController,
                    formatInput: true,
                    keyboardType: TextInputType.number
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: DefaultButton(
                      text: "verify my phone number",
                      press: () {
                        if(isValidNumber){
//                          finalPhoneNumber = "+" + countryCode + _phoneNumberController.text;
                          print("Final Phone Number: " + finalPhoneNumber);
                          globals.userPhoneNumber = finalPhoneNumber;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return OtpScreen();
                              },
                            ),
                          );
                        }
                        else{
                          Config().displaySnackBar('Please enter valid phone number', '');
                        }


                     }),
                ),
                SizedBox(
                  height: 10,
                ),

                Center(
                  child: AcceptTermsWidget()

//                  Wrap(
//                    textAlign: TextAlign.center,
//                    text: TextSpan(
//                      text: "By continuing you agree with connect's ",
//                      style: TextStyle(
//                        color: Colors.grey,
//                        fontSize: 12,
//                      ),
//                      children:[
//                        TextSpan(
//                            text: "Terms of Use ",
//                            style: TextStyle(color: Colors.green)),
//                        TextSpan(
//                            text: "and confirm that you have read connect's ",
//                            style: TextStyle(color: Colors.grey)),
//                        TextSpan(
//                            text: "Privacy Policy ",
//                            style: TextStyle(color: Colors.green)),
//                      ],
//                    ),
//                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              : SizedBox(),
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          reverse
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 4; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }
}

class Strings {
  static var stepOneTitle = "Hey 👋";
  static var stepOneContent =
      "We are connect. A modern way to handel your social life. \nSwipe to get onbaorded!";
  static var stepTwoTitle = "society's problem";
  static var stepTwoContent =
      "everybody's on their phones nowerdays. That decresed real human interactions, health and friendships.";
  static var stepThreeTitle = "how we innovate";
  static var stepThreeContent =
      "We are hoping to incurage you to go out- do stuff - have fun!";
}
