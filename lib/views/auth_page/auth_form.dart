// @dart=2.12
import 'package:email_validator/email_validator.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/_widgets/mixins/loading_state_mixin.dart';
import 'package:flutter_folio/commands/app/authenticate_user_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/styled_widgets/styled_load_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

enum _AuthFormMode { CreateAccount, SignIn }

class _AuthFormState extends State<AuthForm> with LoadingStateMixin {
  _AuthFormMode _formMode = _AuthFormMode.SignIn;
  _AuthFormMode get formMode => _formMode;
  set formMode(_AuthFormMode formMode) => setState(() => _formMode = formMode);

  String _errorText = "";
  String get errorText => _errorText;
  set errorText(String errorText) => setState(() => _errorText = errorText);

  late TextEditingController _emailController;
  late TextEditingController _passController;

  // Provided quick login for devs
  bool enableDebugLogin = kDebugMode; // && false;
  String get _defaultEmail => enableDebugLogin ? "shawn@test.com" : "";
  String get _defaultPass => enableDebugLogin ? "password" : "";
  bool get enableSubmit {
    bool emailAndPassAreValid = EmailValidator.validate(_emailController.text) && _passController.text.length >= 6;
    print("Enable submit??${_emailController.text}");
    return emailAndPassAreValid;
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: _defaultEmail);
    _passController = TextEditingController(text: _defaultPass);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        AppTheme theme = context.watch();
        bool isCreatingAccount = formMode == _AuthFormMode.CreateAccount;
        String headerText = isCreatingAccount ? "Welcome to flutter folio" : "Welcome back!";
        String descText = isCreatingAccount
            ? "Create an account to start your scrapbook!"
            : "Log into your account to view your existing scrapbooks or start a new one.";
        String submitBtnText = isCreatingAccount ? "Sign Up" : "Log In";
        String switchFormText = isCreatingAccount ? "Already have an account?" : "Don't have an account?";
        String switchFormBtnText = isCreatingAccount ? "Log In" : "Sign Up";
        bool reduceTextSize = constraints.maxHeight < 500;
        return Stack(
          children: [
            ContextMenuRegion(isEnabled: kIsWeb == false, contextMenu: AppContextMenu(), child: Container()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: Insets.xl),

              /// Use animated switch to fade between the forms
              child: AnimatedSwitcher(
                duration: Times.fast,

                /// Wrap in AutoFillGroup + Form for auto-complete on web
                child: AutofillGroup(
                  key: ValueKey(formMode),
                  child: Form(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),

                        /// Use an expanded scrolling column so our form will scroll vertically when it has to
                        child: ExpandedScrollingColumn(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),

                            /// Title
                            UiText(
                              headerText,
                              style: TextStyles.h2.copyWith(color: theme.accent1, fontSize: reduceTextSize ? 36 : 46),
                            ),
                            VSpace.med,

                            /// Desc
                            UiText(descText, style: TextStyles.title2.copyWith(color: theme.greyStrong, fontSize: 16)),
                            VSpace.med,

                            /// Email
                            LabeledTextInput(
                              onSubmit: (_) => _handleSubmitPressed(),
                              controller: _emailController,
                              autoFocus: true,
                              style: TextStyles.body1,
                              hintText: "Email",
                              autofillHints: [AutofillHints.email, AutofillHints.username],
                              onChanged: (_) => setState(() {}),
                            ),
                            VSpace.med,

                            /// PASS
                            LabeledTextInput(
                              onSubmit: (_) => _handleSubmitPressed(),
                              controller: _passController,
                              style: TextStyles.body1,
                              hintText: "Password",
                              autofillHints: [AutofillHints.password],
                              onChanged: (_) => setState(() {}),
                              obscureText: true,
                            ),
                            VSpace.med,

                            /// ERROR MSG
                            if (_errorText.isNotEmpty) ...[
                              VSpace(Insets.xs),
                              UiText(errorText, style: TextStyles.title2.copyWith(color: theme.accent1)),
                            ],
                            VSpace(Insets.xs),

                            /// SUBMIT BTN
                            isLoading
                                ? StyledLoadSpinner()
                                : PrimaryBtn(
                                    onPressed: enableSubmit ? _handleSubmitPressed : null,
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(submitBtnText.toUpperCase(), style: TextStyles.callout1)),
                                  ),

                            /// SWITCH MODE BTN
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UiText(switchFormText, style: TextStyles.title2),
                                TextBtn(switchFormBtnText,
                                    onPressed: _handleSwitchViewPressed,
                                    style: TextStyles.title1.copyWith(fontSize: 14, color: theme.accent1)),
                              ],
                            ),
                            Spacer(flex: 3),

                            /// Bottom Content (learn more)
                            SeparatedRow(
                              separatorBuilder: () => HSpace.sm,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UiText("Learn more about Flutter Folio"),
                                ContextMenuRegion(
                                  contextMenu: LinkContextMenu(
                                    url: 'https://github.com/gskinnerTeam/flutter-folio',
                                  ),
                                  child: SimpleBtn(
                                    child: AppIcon(AppIcons.website, color: theme.greyStrong, size: 24),
                                    onPressed: _handleWebsitePressed,
                                  ),
                                ),
                                ContextMenuRegion(
                                  contextMenu: LinkContextMenu(url: "https://flutter.gskinner.com"),
                                  child: SimpleBtn(
                                    child: AppIcon(AppIcons.github, color: theme.greyStrong, size: 24),
                                    onPressed: _handleGitPressed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
          ? "Your account or password is incorrect."
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

  void _handleGitPressed() => launch("https://github.com/gskinnerTeam/flutter-folio");

  void _handleWebsitePressed() => launch("https://flutter.gskinner.com");
}
