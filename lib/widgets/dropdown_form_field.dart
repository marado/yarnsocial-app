import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownFormField<T> extends FormField<T> {
  DropdownFormField(
    BuildContext context,
    List<DropdownMenuItem<T>> dropDownItems, {
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    T? initialValue,
    bool isExpanded = false,
    Widget? hint,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<T> state) {
            final theme = Theme.of(context);
            return Column(
              children: [
                DropdownButton<T>(
                  onTap: () {
                    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  value: state.value,
                  isExpanded: isExpanded,
                  items: dropDownItems,
                  underline: Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: state.hasError
                              ? theme.errorColor
                              : Color(0xFFBDBDBD),
                          width: state.hasError ? 1.0 : 0.0,
                        ),
                      ),
                    ),
                  ),
                  hint: hint,
                  onChanged: (changedValue) {
                    state.didChange(changedValue);
                  },
                ),
                if (state.hasError) ...[
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.errorText!,
                      style: theme.textTheme.caption!.copyWith(
                        color: theme.errorColor,
                      ),
                    ),
                  )
                ]
              ],
            );
          },
        );
}
