import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gojek/app_locale.dart';
import 'package:gojek/constans.dart';

class PilihBahasaView extends StatefulWidget {
  const PilihBahasaView({super.key});

  @override
  State<PilihBahasaView> createState() => _PilihBahasaViewState();
}

class _PilihBahasaViewState extends State<PilihBahasaView> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.pilihBahasa.getString(context)),
        backgroundColor: GoNesaPalette.green,
      ),
      body: ListView(
        children: [
          _buildLanguageTile('Bahasa Indonesia', 'id'),
          _buildLanguageTile('English', 'en'),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(String languageName, String languageCode) {
    return ListTile(
      title: Text(languageName),
      trailing: localization.getLanguageName() == languageName
          ? Icon(Icons.check_circle, color: GoNesaPalette.green)
          : null,
      onTap: () {
        localization.translate(languageCode);
        setState(() {});
      },
    );
  }
}
