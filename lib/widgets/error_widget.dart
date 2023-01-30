import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../strings.dart';

class UnexpectedErrorMessage extends StatelessWidget {
  final VoidCallback onRetryPressed;
  final String? description;
  final String? buttonLabel;
  const UnexpectedErrorMessage({
    Key? key,
    required this.onRetryPressed,
    this.buttonLabel,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<AppStrings>();
    return ErrorMessage(
      onButtonPressed: onRetryPressed,
      description: Column(
        children: [
          Text(
            description ?? strings.unexpectedError,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 32),
        ],
      ),
      buttonChild: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.refresh),
          SizedBox(width: 8),
          Text(buttonLabel ?? strings.tapToRetry),
        ],
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final VoidCallback? onButtonPressed;
  final Widget? description;
  final Widget? buttonChild;
  const ErrorMessage({
    Key? key,
    this.onButtonPressed,
    this.buttonChild,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          description!,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.error,
            ),
            onPressed: onButtonPressed,
            child: buttonChild,
          )
        ],
      ),
    );
  }
}
