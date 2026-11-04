# AGENTS.md — SIGUEMA (app mobile UEMA)

Regras do projeto para qualquer agente de IA (Claude Code, Codex, etc.) e para pessoas.
Fonte de verdade das decisões: `docs/adr/`. Se algo aqui conflitar com uma ADR aceita, a ADR vale.

## Contexto
- App mobile (Flutter) do SIGUEMA para a UEMA. Execução: CTIC.
- Plataformas: Android (Play Store) e iOS (App Store).
- Piloto: ~3 mil usuários (campus Paulo VI). Meta: ~29 mil.
- Login: base do SIGUEMA, CPF + senha; depois o usuário escolhe o vínculo, se tiver mais de um.
- Integra com o SIGAA, usando o SIGUEMA como base.
- Hospedagem: servidor da UEMA (on-premises).
- Equipe: 2 devs, 1 infra/suporte, 1 chefe de departamento, 1 designer. Dev em Windows + VS Code.

## Status das decisões
Tudo abaixo é **proposta** até virar ADR aceita. Em aberto: API do SIGUEMA existente ou BFF novo, linguagem do BFF, servidor (SO/Docker/exposição), push (Firebase), build do iOS, contas das lojas.

## Stack do app (proposta)
- Flutter + Dart. Estado: **Riverpod**. Navegação: **go_router**. HTTP: **dio** (interceptors).
- Modelos: **freezed + json_serializable**. Tokens: **flutter_secure_storage**. Biometria: **local_auth**.
- Cache offline (só onde precisar): **drift**. Erros: **Sentry self-hosted**. Push: FCM, com conteúdo genérico.
- Testes: `flutter_test`, `mocktail`, `integration_test`.

## Arquitetura
- Feature-first + MVVM + Repository.
- `lib/core/` (rede, storage, erros, config) e `lib/features/<nome>/{data,domain,presentation}/`.
- A UI nunca chama o `dio` diretamente: UI → ViewModel → Repository → API/cache.
- Dados do SIGAA/SIGUEMA passam por DTO + Mapper; o modelo do app não herda o formato do legado.
- Estados de tela via `AsyncValue`/sealed classes; sem lógica de negócio no `build()`.

## Comandos
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```
Antes de abrir PR: `dart format .`, `flutter analyze` e `flutter test` limpos.

## Regras de segurança e LGPD (inegociáveis)
- Nunca guardar a senha no aparelho; só tokens de curta duração em `flutter_secure_storage`.
- Nunca registrar CPF, senha, token ou dado de aluno em log, print, issue, PR ou prompt.
- Push com texto genérico; o conteúdo real é buscado no servidor da UEMA.
- Sem segredos no repositório (`.env`, chaves, `key.properties`, `google-services.json`).
- Dados de exemplo e testes usam CPFs e nomes **fictícios**.

## Fluxo de trabalho
- `main` protegida; trabalho em branches curtas: `feat/`, `fix/`, `chore/`, `docs/`, `refactor/`, `test/`.
- Commits no padrão Conventional Commits (`feat: ...`, `fix: ...`).
- Todo PR é revisado pelo outro dev; ninguém aprova o próprio PR. PR pequeno (~400 linhas).
- Squash merge e apagar a branch. Issue fechada pelo PR (`Closes #n`).
- Mudança em `pubspec.yaml`, `core/` ou contrato da API entra num PR pequeno e separado.

## Como o agente deve trabalhar
- Antes de mudar código, ler o que existe e seguir o padrão do código vizinho.
- Mudar só o que a tarefa pede; sem refatoração paralela nem dependência nova sem avisar.
- Escrever o teste antes ou junto da regra (TDD quando fizer sentido).
- Se faltar uma decisão (ex.: formato da API), parar e perguntar em vez de inventar.
- Ao terminar: rodar format, analyze e test e relatar o resultado real, inclusive falhas.
- Não fazer commit nem push sem pedido explícito.

## Skills do Claude Code instaladas (`.claude/skills/`)
Arquitetura: `flutter-apply-architecture-best-practices` · Rotas: `flutter-setup-declarative-routing` · Layout: `flutter-build-responsive-layout`
Testes: `flutter-add-widget-test`, `flutter-add-integration-test`, `test-driven-development`
Qualidade: `dart-run-static-analysis`, `dart-fix-runtime-errors`, `requesting-code-review`
Planejamento: `writing-plans`, `executing-plans`, `finishing-a-development-branch` · Design: `figma` (exige Figma MCP conectado)
Quem usa outra ferramenta de IA segue este arquivo; as skills são um extra do Claude Code.
