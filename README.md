# SIGUEMA Mobile

App mobile (Flutter, Android e iOS) do SIGUEMA, da UEMA. Projeto da CTIC.

## Status
**Alpha v0.0.1**: protótipo navegável do discente (login, Início, Turmas, Turma virtual, Documentos, Perfil, Configurações e Ajuda), com **dados 100% fictícios** em JSON local e sem API. Escopo em `docs/ALPHA-0.0.1.md`; o que é de mentira e como testar em `docs/NOTAS-ALPHA-0.0.1.md`.

### Rodar o alpha
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor dev -t lib/main_alpha.dart
```

## Como rodar (após criar o projeto)
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor dev
```
Pré-requisitos: Flutter SDK (versão registrada em `docs/`), Android Studio/SDK. Para iOS é preciso um Mac.

## Documentação
- `AGENTS.md`: regras do projeto (pessoas e agentes de IA)
- `CONTRIBUTING.md`: fluxo de branch, commits e PR
- `docs/adr/`: decisões de arquitetura

## Segurança
Não versione segredos nem dados reais de usuários. Detalhes em `AGENTS.md`.
