import 'package:daily_you/entries_database.dart';
import 'package:daily_you/models/template.dart';
import 'package:daily_you/widgets/template_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TemplateSelect extends StatefulWidget {
  final Function(Template template) onTemplatesSelected;

  const TemplateSelect({super.key, required this.onTemplatesSelected});

  @override
  State<TemplateSelect> createState() => _TemplateSelectDialogState();
}

class _TemplateSelectDialogState extends State<TemplateSelect> {
  List<Template> _templates = [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    List<Template> templates = await EntriesDatabase.instance.getAllTemplates();
    setState(() {
      _templates = templates;
    });
  }

  void _showTemplateManagementPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TemplateManager(
          onTemplatesUpdated: _loadTemplates,
        );
      },
    );
  }

  Widget _buildTemplatesList() {
    if (_templates.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.noTemplatesDescription),
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _templates.length,
        itemBuilder: (context, index) {
          final template = _templates[index];
          return Card(
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  template.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              trailing: IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () {
                  widget.onTemplatesSelected(template);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.addTemplate),
      content: SizedBox(width: double.maxFinite, child: _buildTemplatesList()),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.edit_document),
          label: Text(AppLocalizations.of(context)!.manageTemplates),
          onPressed: () {
            _showTemplateManagementPopup(context);
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
