import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../form_validators.dart';
import '../models.dart';
import '../strings.dart';
import '../widgets/common_widgets.dart';
import '../widgets/image_picker.dart';

class NewTwt extends StatefulWidget {
  const NewTwt({Key? key, this.initialText = ''}) : super(key: key);

  final String initialText;

  @override
  _NewTwtState createState() => _NewTwtState();
}

class _NewTwtState extends State<NewTwt> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _textController;
  String? postAs;

  bool _isLoading = false;

  void onChangePostAs(value) {
    setState(() => postAs = value);
  }

  void _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final postRequest = PostRequest(
      postAs ?? 'me',
      _textController!.text,
    );
    await context.read<Api>().savePost(postRequest);

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText)
      ..buildTextSpan(withComposing: true, context: this.context);
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = context.watch<AppStrings>();
    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.newpost),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: _isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).hintColor)
                  : Icon(Icons.send),
              onPressed: _submitPost,
            ),
          ),
        ],
      ),
      body: Container(
        child: Consumer<AppUser>(
          builder: (contxt, user, _) => Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Avatar(imageUrl: user.twter!.avatar.toString()),
                  const SizedBox(width: 16.0),
                  Flexible(
                    child: NewTwtForm(
                      formKey: _formKey,
                      textEditingController: _textController,
                    ),
                  ),
                ],
              ),
              if (user.profile != null && user.profile!.feeds != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: postAs ?? user.profile!.username,
                      onChanged: onChangePostAs,
                      items: [
                        DropdownMenuItem<String>(
                          child: Text(
                              'Post as ' + (user.profile!.username ?? 'me')),
                          value: user.profile!.username,
                        ),
                        ...user.profile!.feeds!
                            .map(
                              (feed) => DropdownMenuItem<String>(
                                child: Text(feed),
                                value: feed,
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewTwtForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? textEditingController;

  const NewTwtForm({Key? key, this.formKey, this.textEditingController})
      : super(key: key);

  @override
  _NewTwtFormState createState() => _NewTwtFormState();
}

class _NewTwtFormState extends State<NewTwtForm> {
  final _random = Random();
  final _scrollbarController = ScrollController();
  final _picker = ImagePicker();

  String? _twtPrompt;
  Future? _uploadImageFuture;

  @override
  void initState() {
    super.initState();
    _twtPrompt = _getTwtPrompt();
  }

  String _getTwtPrompt() {
    final prompts = context.read<AppStrings>().twtPromtpts;
    return prompts[_random.nextInt(prompts.length)];
  }

  void _surroundTextSelection(String left, String right) {
    final textEditingController = widget.textEditingController!;
    final currentTextValue = textEditingController.value.text;
    final selection = textEditingController.selection;
    final middle = selection.textInside(currentTextValue);
    final newTextValue = selection.textBefore(currentTextValue) +
        '$left$middle$right' +
        selection.textAfter(currentTextValue);

    textEditingController.value = textEditingController.value.copyWith(
      text: newTextValue,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + left.length + middle.length,
      ),
    );
  }

  Future<void> _uploadImage() async {
    final textEditingController = widget.textEditingController;
    try {
      final pickedFile = await getImage(context, _picker);
      if (pickedFile == null) {
        return;
      }

      final imageURL = await context.read<Api>().uploadImage(pickedFile.path);
      textEditingController!.value = textEditingController.value.copyWith(
        text: textEditingController.value.text + '![]($imageURL)',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has occurred while uploading an image: ${e.toString()} - Please try again',
          ),
        ),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: widget.formKey,
          child: TextFormField(
            validator: FormValidators.requiredField,
            autofocus: true,
            decoration: InputDecoration(
              hintText: _twtPrompt,
            ),
            maxLines: 8,
            controller: widget.textEditingController,
          ),
        ),
        SizedBox(
          height: 64,
          child: Scrollbar(
            controller: _scrollbarController,
            isAlwaysShown: true,
            child: ListView(
              controller: _scrollbarController,
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  tooltip: 'Bold',
                  icon: Icon(Icons.format_bold),
                  onPressed: () => _surroundTextSelection(
                    '**',
                    '**',
                  ),
                ),
                IconButton(
                  tooltip: 'Underline',
                  icon: Icon(Icons.format_italic),
                  onPressed: () => _surroundTextSelection(
                    '_',
                    '_',
                  ),
                ),
                IconButton(
                  tooltip: 'Link',
                  icon: Icon(Icons.link_sharp),
                  onPressed: () => _surroundTextSelection(
                    '[',
                    ']()',
                  ),
                ),
                FutureBuilder(
                  future: _uploadImageFuture,
                  builder: (context, snapshot) {
                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting;

                    void _onPressed() {
                      setState(() {
                        _uploadImageFuture = _uploadImage();
                      });
                    }

                    return IconButton(
                      tooltip: 'Upload image from camera',
                      icon: isLoading ? SizedSpinner() : Icon(Icons.camera_alt),
                      onPressed: isLoading ? null : _onPressed,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
