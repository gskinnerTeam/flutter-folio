import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/_widgets/flexibles/seperated_flexibles.dart';
import 'package:flutter_folio/_widgets/mixins/loading_state_mixin.dart';
import 'package:flutter_folio/commands/app/authenticate_user_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/styled_widgets/styled_load_spinner.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

enum _AuthFormMode { CreateAccount, SignIn }

class _AuthPageState extends State<AuthPage> with LoadingStateMixin {
  _AuthFormMode _formMode = _AuthFormMode.SignIn;
  _AuthFormMode get formMode => _formMode;
  set formMode(_AuthFormMode formMode) => setState(() => _formMode = formMode);

  String _errorText = "";
  String get errorText => _errorText;
  set errorText(String errorText) => setState(() => _errorText = errorText);

  TextEditingController _emailController;
  TextEditingController _passController;

  // Provided quick login for devs
  bool enableDebugLogin = kDebugMode && true;
  String get _defaultEmail => enableDebugLogin ? "shawn@test.com" : "";
  String get _defaultPass => enableDebugLogin ? "password" : "";
  bool get enableSubmit {
    return EmailValidator.validate(_emailController.text) && _passController.text.length >= 6;
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: _defaultEmail);
    _passController = TextEditingController(text: _defaultPass);
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    bool isCreatingAccount = formMode == _AuthFormMode.CreateAccount;
    String submitLabel = isCreatingAccount ? "Create Account" : "Sign In";
    String switchLabel = isCreatingAccount ? "Already have an account?" : "Create an account?";
    return Stack(
      children: [
        ContextMenuRegion(isEnabled: kIsWeb == false, contextMenu: AppContextMenu(), child: Container()),
        Center(
          child: IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: theme.grey, width: 1),
                    bottom: BorderSide(color: theme.grey, width: 1),
                  )),
              width: double.infinity,
              height: 400,
              padding: EdgeInsets.symmetric(vertical: Insets.lg, horizontal: Insets.med),
              child: AnimatedSwitcher(
                duration: Times.fast,
                child: AutofillGroup(
                  key: ValueKey(formMode),
                  child: Form(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: SeparatedColumn(
                        separatorBuilder: () => VSpace.med,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SelectableText(submitLabel.toUpperCase(), style: TextStyles.title1),
                          if (isCreatingAccount) ...[
                            SelectableText(
                              "Please enter a valid email and a  password that is at least 6 characters.",
                              style: TextStyles.body2,
                            ),
                          ],
                          // Email
                          LabeledTextInput(
                            onSubmit: (_) => _handleSubmitPressed(),
                            controller: _emailController,
                            autoFocus: true,
                            style: TextStyles.body1,
                            hintText: "Email",
                            autofillHints: [AutofillHints.email, AutofillHints.username],
                            onChanged: (value) => setState(() {}),
                          ),
                          // PASS
                          LabeledTextInput(
                            onSubmit: (_) => _handleSubmitPressed(),
                            controller: _passController,
                            style: TextStyles.body1,
                            hintText: "Password",
                            autofillHints: [AutofillHints.password],
                            onChanged: (value) => setState(() {}),
                            obscureText: true,
                          ),
                          // ERROR MSG
                          if (_errorText.isNotEmpty) ...[
                            SelectableText(errorText, style: TextStyle(color: Colors.red.shade800)),
                          ],
                          // SUBMIT BTN
                          isLoading
                              ? StyledLoadSpinner()
                              : PrimaryBtn(
                                  onPressed: enableSubmit ? _handleSubmitPressed : null,
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 200,
                                      child: Text(submitLabel.toUpperCase(), style: TextStyles.callout1)),
                                ),
                          // SWITCH MODE BTN
                          TextBtn(switchLabel, onPressed: _handleSwitchViewPressed),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmitPressed() async {
    if (enableSubmit == false) return;
    errorText = "";
    bool success = await load(() async => await AuthenticateUserCommand().run(
          email: _emailController.text,
          pass: _passController.text,
          createNew: formMode == _AuthFormMode.CreateAccount,
        ));
    if (!success) {
      errorText = formMode == _AuthFormMode.SignIn
          ? "Sign in failed. Double check your email and password."
          : "Unable to create an account, that email is already in use.";
    }
  }

  void _handleSwitchViewPressed() {
    errorText = "";
    bool isCreatingAccount = formMode == _AuthFormMode.CreateAccount;
    formMode = isCreatingAccount ? _AuthFormMode.SignIn : _AuthFormMode.CreateAccount;
    _emailController.text = "";
    _passController.text = "";
    InputUtils.unFocus();
  }
}
