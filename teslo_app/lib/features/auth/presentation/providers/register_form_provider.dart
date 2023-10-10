import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import '../../../shared/infrastructure/inputs/inputs.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onFullNameChange(String value) {
    final newFullName = InputText.dirty(value);
    state = state.copyWith(
        fullName: newFullName,
        isValid: Formz.validate(
            [newFullName, state.email, state.password, state.confirmPassword]));
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate(
            [newEmail, state.password, state.fullName, state.confirmPassword]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate(
            [newPassword, state.email, state.fullName, state.confirmPassword]));
  }

  onConfirmPasswordChanged(String value) {
    final newConfirmPassword =
        ConfirmPassword.dirty(value, state.password.value);
    state = state.copyWith(
        confirmPassword: newConfirmPassword,
        isValid: Formz.validate(
            [newConfirmPassword, state.password, state.email, state.fullName]));
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;

    await registerUserCallback(
        state.email.value, state.password.value, state.fullName.value);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(
        state.confirmPassword.value, state.password.value);
    final fullName = InputText.dirty(state.fullName.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        fullName: fullName,
        isValid: Formz.validate([email, password, confirmPassword, fullName]));
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final InputText fullName;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.confirmPassword = const ConfirmPassword.pure(''),
      this.fullName = const InputText.pure()});

  RegisterFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password,
          ConfirmPassword? confirmPassword,
          InputText? fullName}) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password,
          confirmPassword: confirmPassword ?? this.confirmPassword,
          fullName: fullName ?? this.fullName);

  @override
  String toString() {
    return '''
  RegisterFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    confirmPassword: $confirmPassword
    fullName: $fullName
    ''';
  }
}
