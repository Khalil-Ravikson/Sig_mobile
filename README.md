# SIGUEMA Mobile

App mobile (Flutter, Android e iOS) do SIGUEMA, da UEMA. Projeto da CTIC.

## Status
Em fase de **Sprint 0**: estrutura do repositório, decisões de stack e spike de login. O projeto Flutter ainda não foi criado. Veja `docs/` e o backlog.

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
