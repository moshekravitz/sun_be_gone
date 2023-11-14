import 'package:flutter/material.dart';
import 'package:sun_be_gone/animations/results_animation.dart';
import 'package:sun_be_gone/dialogs/generic_dialog.dart';
import 'package:sun_business/sun_business.dart' show SittingInfo;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingResult extends StatelessWidget {
  final SittingInfo sittingInfo;

  const LoadingResult({super.key, required this.sittingInfo});

  @override
  Widget build(BuildContext context) {
    final String dialogInfoTitle =
        AppLocalizations.of(context)!.dialogInfoTitle;
    final String dialogInfoContent =
        AppLocalizations.of(context)!.resultDialogContent;
    final String dialogOk = AppLocalizations.of(context)!.dialogOk;
    return Scaffold(
      body: Stack(
        children: [
          //button in top right corner
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.help),
              onPressed: () => showGenericDialog<bool>(
                context: context,
                title: dialogInfoTitle,
                content: dialogInfoContent,
                optionsBuilder: () => {dialogOk: true},
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: AnimatedCurvedProgressBar(
                sittingInfo: sittingInfo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
