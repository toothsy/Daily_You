import 'package:daily_you/entries_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LaunchPage extends StatefulWidget {
  final Widget nextPage;
  const LaunchPage({super.key, required this.nextPage});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDatabaseConnection();
  }

  _checkDatabaseConnection() async {
    //Initialize Database
    if (await EntriesDatabase.instance.initDB()) {
      await _nextPage();
    }

    setState(() {
      isLoading = false;
    });
  }

  _forceLocalDatabase() async {
    await EntriesDatabase.instance.initDB(forceWithoutSync: true);
    await _nextPage();
  }

  Future<void> _nextPage() async {
    await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.nextPage));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(body: SizedBox())
        : Scaffold(
            extendBody: true,
            body: Center(
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .errorExternalStorageAccessTitle,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        32.0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .errorExternalStorageAccessDescription,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                        onPressed: _forceLocalDatabase,
                        child: Text(AppLocalizations.of(context)!
                            .errorExternalStorageAccessContinue)),
                  ],
                ),
              ),
            ));
  }
}
