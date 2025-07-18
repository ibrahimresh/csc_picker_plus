import 'dart:developer';
import 'package:flutter/material.dart';


class DropdownWithSearch<T> extends StatelessWidget {
  final String title;
  final String placeHolder;
  final T selected;
  final List items;
  final EdgeInsets? selectedItemPadding;
  final TextStyle? selectedItemStyle;
  final TextStyle? dropdownHeadingStyle;
  final TextStyle? itemStyle;
  final BoxDecoration? decoration, disabledDecoration;
  final double? searchBarRadius;
  final double? dialogRadius;
  final bool disabled;
  final String label;
  final bool? isArabic;
  final Color? dialogBackgroundColor;
  final InputDecoration? searchInputDecoration;
  final Widget? dividerWidget;
  final Color? dialogBarrierColor;
  final Function onChanged;

  const DropdownWithSearch({
    super.key,
    required this.title,
    required this.placeHolder,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.selectedItemPadding,
    this.selectedItemStyle,
    this.dropdownHeadingStyle,
    this.itemStyle,
    this.decoration,
    this.disabledDecoration,
    this.searchBarRadius,
    this.dialogRadius,
    required this.label,
    this.disabled = false,
    this.isArabic,
    this.dialogBackgroundColor,
    this.searchInputDecoration,
    this.dividerWidget,
    this.dialogBarrierColor,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              barrierColor: dialogBarrierColor,
              builder: (context) => SearchDialog(
                  dividerWidget: dividerWidget,
                  dialogBackgroundColor: dialogBackgroundColor,
                  searchInputDecoration: searchInputDecoration,
                  placeHolder: placeHolder,
                  title: title,
                  searchInputRadius: searchBarRadius,
                  dialogRadius: dialogRadius,
                  titleStyle: dropdownHeadingStyle,
                  itemStyle: itemStyle,
                  displayArabic: isArabic,
                  items: items)).then((value) {
                    onChanged(value);
            /* if(value!=null)
                    {
                      onChanged(value);
                      _lastSelected = value;
                    }
                    else {
                      print("Value NULL $value $_lastSelected");
                      onChanged(_lastSelected);
                    }*/
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: !disabled
              ? decoration ??
                  BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1))
              : disabledDecoration ??
                  BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.grey.shade300, width: 1)),
          child: Row(
            children: [
              Expanded(
                  child: Text(selected.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: selectedItemStyle ?? const TextStyle(fontSize: 14))),
              const Icon(Icons.keyboard_arrow_down_rounded)
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDialog extends StatefulWidget {
  final String title;
  final String placeHolder;
  final List items;
  final TextStyle? titleStyle;
  final TextStyle? itemStyle;
  final double? searchInputRadius;
  final bool? displayArabic;
  final Color? dialogBackgroundColor;
  final InputDecoration? searchInputDecoration;
  final Widget? dividerWidget;
  final double? dialogRadius;

  const SearchDialog({
    super.key,
    required this.title,
    required this.placeHolder,
    required this.items,
    this.titleStyle,
    this.searchInputRadius,
    this.dialogRadius,
    this.itemStyle,
    this.displayArabic,
    this.dialogBackgroundColor,
    this.searchInputDecoration,
    this.dividerWidget,
  });

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState<T> extends State<SearchDialog> {
  TextEditingController textController = TextEditingController();
  late List filteredList;

  @override
  void initState() {
    log(widget.items.runtimeType.toString());
    if (widget.items is List<String?>) {
      filteredList = widget.items;
      textController.addListener(() {
        setState(() {
          if (textController.text.isEmpty) {
            filteredList = widget.items;
          } else {
            filteredList = widget.items
                .where((element) =>
                    element.toString().toLowerCase().contains(textController.text.toLowerCase()))
                .toList();
          }
        });
      });
    } else {
      filteredList =
          widget.items.map((e) => widget.displayArabic == true ? e.nameAr : e.name).toList();
      textController.addListener(() {
        setState(() {
          if (textController.text.isEmpty) {
            filteredList =
                widget.items.map((e) => widget.displayArabic == true ? e.nameAr : e.name).toList();
          } else {
            filteredList = widget.items
                .where((element) {
                  return element.name
                          .toString()
                          .toLowerCase()
                          .contains(textController.text.toLowerCase()) ||
                      element.nameAr
                          .toString()
                          .toLowerCase()
                          .contains(textController.text.toLowerCase());
                })
                .map((e) => widget.displayArabic == true ? e.nameAr : e.name)
                .toList();
          }
        });
      });
    }
    super.initState();
  }

  dynamic _getSelectedItem(String countryName) {
    final list = widget.items;
    if (list is List<String?>) return countryName;
    final item = list.firstWhere((element) {
      return element.name.toString().toLowerCase() == countryName ||
          element.nameAr.toString().toLowerCase() == countryName;
    });

    return item;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      dialogBackgroundColor: widget.dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: widget.dialogRadius != null
              ? BorderRadius.circular(widget.dialogRadius!)
              : BorderRadius.circular(14)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.title,
                    style: widget.titleStyle ??
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    })
                /*Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: widget.titleStyle != null
                          ? widget.titleStyle
                          : TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )),
              )*/
              ],
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: widget.searchInputDecoration ??
                    InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search),
                      hintText: widget.placeHolder,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(widget.searchInputRadius != null
                            ? Radius.circular(widget.searchInputRadius!)
                            : const Radius.circular(5)),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(widget.searchInputRadius != null
                            ? Radius.circular(widget.searchInputRadius!)
                            : const Radius.circular(5)),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                style: widget.itemStyle ?? const TextStyle(fontSize: 14),
                controller: textController,
              ),
            ),
            if (widget.dividerWidget != null) widget.dividerWidget!,
            const SizedBox(height: 5),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(widget.dialogRadius != null
                    ? Radius.circular(widget.dialogRadius!)
                    : const Radius.circular(5)),
                //borderRadius: widget.dialogRadius!=null?BorderRadius.circular(widget.dropDownRadius!):BorderRadius.circular(14),
                child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            final item = _getSelectedItem(filteredList[index]);
                            Navigator.pop(context, item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                            child: Text(
                              filteredList[index].toString(),
                              style: widget.itemStyle ?? const TextStyle(fontSize: 14),
                            ),
                          ));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const CustomDialog({
    super.key,
    this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
    this.constraints =
        const BoxConstraints(minWidth: 280.0, minHeight: 280.0, maxHeight: 400.0, maxWidth: 400.0),
    this.dialogBackgroundColor,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  final Color? dialogBackgroundColor;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve insetAnimationCurve;

  /// {@template flutter.material.dialog.shape}
  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  /// {@endtemplate}
  final ShapeBorder? shape;
  final BoxConstraints constraints;

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)));

  @override
  Widget build(BuildContext context) {
    final DialogThemeData dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: constraints,
            child: Material(
              elevation: 15.0,
              color: dialogBackgroundColor ?? _getColor(context),
              type: MaterialType.card,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
