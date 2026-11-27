# AGENTS.md — SIGUEMA (app mobile UEMA)

Regras do projeto para qualquer agente de IA (Claude Code, Codex, etc.) e para pessoas.
Fonte de verdade das decisões: `docs/adr/`. Se algo aqui conflitar com uma ADR aceita, a ADR vale.
Contexto detalhado: `docs/PRD.md` (produto), `docs/ARCHITECTURE.md` (arquitetura), `docs/DESIGN-SYSTEM.md` (design). Atualize-os quando uma decisão mudar.
Figma: https://www.figma.com/design/1mlDbgjkCV77fX1cJGnthM/SIGUEMA-Mobile-%E2%80%94-UI-UX-Research (prioridade atual do projeto: o design).

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

## Stack do app
Instalado (`pubspec.yaml`): Flutter 3.44 + Dart; **Riverpod**, **go_router**, **dio**, **freezed + json_serializable**, **flutter_secure_storage**, **local_auth**, **lucide_icons_flutter** (ícones).
Só proposto, **ainda não instalado**: cache offline **drift**, erros **Sentry self-hosted**, push FCM com conteúdo genérico.
- Testes: `flutter_test`, `mocktail`, `integration_test`.

## Arquitetura
- Feature-first + MVVM + Repository.
- `lib/core/` (rede, storage, erros, config) e `lib/features/<nome>/{data,domain,presentation}/`.
- A UI nunca chama o `dio` diretamente: UI → ViewModel → Repository → API/cache.
- Dados do SIGAA/SIGUEMA passam por DTO + Mapper; o modelo do app não herda o formato do legado.
- Estados de tela via `AsyncValue`/sealed classes; sem lógica de negócio no `build()`.
- Dependências entre camadas: `presentation` → `domain` ← `data`. `domain` não importa Flutter, `dio` nem `data/`. Só `*_api.dart` usa o `dio`. Repository devolve `Result<T>` (`core/error`), nunca lança para a UI. Uma feature não importa a `data/` de outra.
- Exemplo de referência: `lib/features/auth/`. Arquivos `*.g.dart` e `*.freezed.dart` não são versionados: rode `build_runner` depois do `pub get`.

## Comandos
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```
Alpha navegável (dados fictícios em `assets/mock/`, sem API): `flutter run --flavor dev -t lib/main_alpha.dart` (ver `docs/NOTAS-ALPHA-0.0.1.md`).
Rodar o app (Android): suba o mock (`cd mock && docker compose up -d`) e use `flutter run --flavor dev -t lib/main_dev.dart`. Em aparelho físico, acrescente `--dart-define=API_BASE_URL=http://<ip-do-pc>:4010`.
Antes de abrir PR: `dart format .`, `flutter analyze` e `flutter test` limpos. O CI roda a mesma sequência (com `dart format --set-exit-if-changed`); rode o `build_runner` antes do `analyze`.

## O que NÃO fazer
- Cor fora de `AppColors` (nada de hex solto); laranja não é cor de texto sobre branco.
- Versionar `*.g.dart` ou `*.freezed.dart`.
- Dado real (CPF, nome, nota) em mocks, testes ou exemplos.
- Chamar o `dio` fora de `*_api.dart`.
- Instalar pacote novo (ex.: `drift`, Sentry, Firebase) sem avisar.
- Mudar o design por conta própria: o Figma é a fonte do design.

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
