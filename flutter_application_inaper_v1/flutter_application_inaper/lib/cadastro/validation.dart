class Validation {
  String? campoNome(String nome) {
    if (nome.isEmpty) {
      return 'Entre o nome';
    }
    return null;
  }

  String? campoSobreNome(String sobrenome) {
    if (sobrenome.isEmpty) {
      return 'Entre o sobrenome';
    }
    return null;
  }

  String? campoEmail(String email) {
  if (email.isEmpty) {
    return 'Entre com seu e-mail';
  }
  // Expressão regular para validar o formato do e-mail
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(email)) {
    return 'O e-mail deve estar em um formato válido';
  }
  return null;
}

  String? campoSenha(String senha) {
    if (senha.isEmpty) {
      return 'Entre com sua senha';
    }
    if (senha.length < 8 && !senha.contains(RegExp(r'[A-Z]')) && !senha.contains(RegExp(r'[a-z]')) && !senha.contains(RegExp(r'\W'))) {
      return 'A senha deve ter no mínimo 8 dígitos, uma letra maiuscula, uma minuscula e um caracter especial';
    }
    return null;
  }
    String? confirmaSenha(String confSenha, String senha) {
    if (confSenha.isEmpty) {
      return 'Entre com sua senha';
    }
    if (confSenha != senha) {
      return 'Senhas diferentes';
    }
    return null;
  }
}
