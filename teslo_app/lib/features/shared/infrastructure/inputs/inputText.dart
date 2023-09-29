import 'package:formz/formz.dart';

enum InputTextError { empty, format }

class InputText extends FormzInput<String, InputTextError> {
  static final RegExp inputTextRegExp = RegExp(r'^[azAZ ]');

  const InputText.pure() : super.pure('');

  const InputText.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == InputTextError.empty) return 'El campo es requerido';
    if (displayError == InputTextError.format) {
      return 'Solo se permite letras[a-z, A-Z]';
    }
  }

  @override
  InputTextError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return InputTextError.empty;
    if (!inputTextRegExp.hasMatch(value)) return InputTextError.format;

    return null;
  }
}
