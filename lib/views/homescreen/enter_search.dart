
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnSearchTapped = void Function();

class EnterSearch extends HookWidget {

  final OnSearchTapped onSearchTapped;

  const EnterSearch({
    super.key,
    required this.onSearchTapped,
  });


  @override
  Widget build(BuildContext context) {
    final String searchHint = AppLocalizations.of(context)!.searchTitle;
    return Center(
      child: GestureDetector(
        onTap: onSearchTapped,
        child: Container(
          width: 333.0,
          height: 52.0,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2), // Color with opacity
                offset: Offset(5, 5), // Horizontal and vertical offset
                blurRadius: 5.0, // Blur radius
                spreadRadius: 0.0, // Spread radius
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
                color: const Color(0x79797900),
                width: 1.0,
                style: BorderStyle.solid),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  searchHint,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              const Icon(
                Icons.search,
                size: 30.0,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
