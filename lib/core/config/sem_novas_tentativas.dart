/// O Riverpod 3 refaz sozinho, com espera crescente, qualquer provider que
/// falhe. No app quem decide é a pessoa ("Tentar de novo"), e o estado de
/// erro precisa aparecer na hora. Passe como `retry` do `ProviderScope`.
Duration? semNovasTentativas(int tentativa, Object erro) => null;
