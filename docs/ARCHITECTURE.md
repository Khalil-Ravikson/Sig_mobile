# Arquitetura — SIGUEMA Mobile

> Decisões formais ficam em `docs/adr/` (ADR 0001 ainda é **proposta**). Se este arquivo conflitar com uma ADR aceita, a ADR vale.

## Stack e versões (de `pubspec.yaml`)
Flutter 3.44.9 (stable), Dart ^3.12.2. App `siguema_mobile` 0.0.1+1 (alpha).

| Uso | Pacote |
|---|---|
| Estado | `flutter_riverpod ^3.4.3` (`riverpod_annotation`, `riverpod_generator` instalados) |
| Navegação | `go_router ^17.5.0` |
| HTTP | `dio ^5.11.1` |
| Modelos | `freezed ^4.0.0-dev.3` (pré-lançamento), `json_serializable` |
| Token | `flutter_secure_storage ^11.2.0` |
| Biometria | `local_auth ^3.0.2` |
| Ícones | `lucide_icons_flutter ^4.0.3` |
| Testes | `flutter_test`, `mocktail`, `integration_test` |

Lints: `flutter_lints` + `strict-casts/inference/raw-types`, aspas simples, vírgula final, `directives_ordering` (ver `analysis_options.yaml`).

## Estrutura de pastas
```
lib/
  main_{dev,homologacao,producao}.dart   # entradas por ambiente → bootstrap(AppConfig)
  bootstrap.dart  app.dart  app_router.dart
  core/{config,error,mock,network,storage,theme,util,widgets}/
  alpha_overrides.dart  main_alpha.dart   # alpha: repositórios que leem assets/mock/*.json
assets/{mock,fonts}/                      # JSON fictícios do alpha e Public Sans
  features/<nome>/{data,domain,presentation}/
    auth/ inicio/ turmas/ shell/   # implementadas (alpha)
    avisos/ horarios/ notas/       # só .gitkeep
mock/        # contrato OpenAPI + WireMock (Docker)
docs/adr/    # decisões
```
Código em português (nomes de classes, arquivos e variáveis).

## Camadas
`presentation` → `domain` ← `data`.
- **presentation**: páginas, widgets e ViewModels (Riverpod `Notifier`).
- **domain**: modelos do app (freezed), interfaces de Repository. Sem Flutter, `dio` ou `data/`.
- **data**: `*_api.dart` (único uso do `dio`), DTOs, Mappers, `*_repository_impl.dart`.
- Repository devolve `Result<T>` (`Sucesso`/`Falha` com `AppError`); não lança para a UI.
- Uma feature não importa a `data/` de outra.
- Referência: `lib/features/auth/`.

## Fluxo de dados
UI → ViewModel → Repository (interface) → Repository impl → `*Api` (dio) → API.
DTO → Mapper → modelo de domínio: o app não herda o formato do legado.

## Navegação (`app_router.dart`)
Rotas (`rotas.dart`): `/login`, `/vinculo`, abas `/inicio`, `/turmas`, `/documentos` (`StatefulShellRoute` com `ContainerAbas` e `BarraBolha`), e por cima das abas `/turmas/:id` e `/perfil` (navegador raiz, sem barra, `paginaSuave`). O `redirect` depende só da `Sessao`:
sem login → `/login`; logado sem vínculo → `/vinculo`; com vínculo → `/inicio` (a partir de login/vínculo). Vínculos que não são de discente veem uma tela "em breve". `/turmas/:id?aba=resumo|frequencia|notas|materiais|atividades` é a turma virtual real (a aba vive na URL; chip troca com `go`, página com chave fixa); `/documentos` é a tela real (busca com debounce de 300 ms); `/perfil`, `/perfil/dados`, `/perfil/config` e `/perfil/ajuda` abrem por cima das abas (sem barra). As preferências do Perfil (`configuracoesProvider`, em memória) são aplicadas no `MaterialApp.builder` (`disableAnimations`, `textScaler` e `ContrasteApp`, que diz às telas se o alto contraste está ligado). Desempenho e medição: `docs/DESEMPENHO-ALPHA.md`. O router escuta `sessaoProvider` via `refreshListenable`.
`RetornoPage` (tela de quem volta, com digital) existe mas **não está nas rotas**.

## Sessão e autenticação
1. `POST /auth/login` (CPF + senha) → nome, vínculos e **token temporário**.
2. Se há vínculo a escolher, `POST /auth/vinculo` com `Bearer <temporário>` → token definitivo, guardado em `TokenStore` (Keychain/Keystore).
3. `AuthInterceptor` anexa `Bearer` em todas as chamadas, exceto `/auth/login`, e respeita um `Authorization` já definido.
- `Sessao` fica só em memória. Não há refresh de token (depende da API real).
- `PerfilLocal` (CPF mascarado `***.456.789-**` + iniciais + flags de biometria) é o único dado pessoal guardado no aparelho, em storage seguro. Nunca senha, CPF inteiro ou token.

## Ambientes
| Entrada | Flavor Android | `applicationId` | URL padrão |
|---|---|---|---|
| `main_dev.dart` | `dev` | `br.uema.siguema.dev` | `http://10.0.2.2:4010` (mock) |
| `main_homologacao.dart` | `homologacao` | `br.uema.siguema.hml` | `https://api-homologacao.siguema.invalid` (provisória) |
| `main_producao.dart` | `producao` | `br.uema.siguema` | `https://api.siguema.invalid` (provisória) |

`--dart-define=API_BASE_URL=...` sobrescreve a URL. Flavors existem **só no Android**; o iOS tem só o scheme `Runner`.

## Integrações e backend
- **API do SIGUEMA** (Java): existe, sem acesso liberado. O contrato usado é **proposto pelo app** em `mock/openapi.yaml`. Se a API real divergir, um adaptador/BFF traduz para este contrato.
- **Mock**: WireMock em Docker (`mock/`), porta 4010. CPFs fictícios em `mock/README.md`. Manter `openapi.yaml` e `wiremock/mappings/` sincronizados.
- **SIGAA**: integração planejada, sem acesso ainda.
- **CI** (`.github/workflows/ci.yml`): `pub get`, `build_runner`, `dart format --set-exit-if-changed`, `analyze`, `test`.

## Decisões e porquês
| Decisão | Por quê |
|---|---|
| Feature-first + MVVM + Repository | Padrão único para 2 devs e testes simples (ADR 0001) |
| DTO + Mapper | Isolar o app do formato do SIGAA/SIGUEMA |
| `Result<T>` em vez de exceções | A UI nunca recebe exceção do Repository |
| Mock com contrato OpenAPI | A API real está bloqueada por burocracia; o contrato vira base de conversa com a CTIC |
| Token só em secure storage; senha nunca | LGPD |
| Build iOS no Codemagic | Decisão da ata de 2026-11-04 (não há Mac) |
| `.g.dart`/`.freezed.dart` não versionados | Evita conflitos; o CI gera o código |

## Armadilhas
- Depois de `pub get`, rode `build_runner`; sem isso nada compila.
- `10.0.2.2` só funciona no emulador Android; em aparelho físico use `--dart-define` com o IP do PC.
- HTTP em texto puro é liberado só no build **debug** (`android/app/src/debug/res/xml/network_security_config.xml`).
- O `release` Android ainda assina com a chave de debug (TODO do Gradle padrão).
- `freezed` está em versão pré-lançamento (`4.0.0-dev.3`).
- Dados da Home (`turmas_exemplo.dart`) são fixos, vindos do Figma.

## Em aberto
Respostas do autor: sem acesso à API real (o sistema é Java); servidor começa com Docker; sem acesso às URLs reais; prioridade é o Figma. `freezed` 4.0.0-dev.3 foi só um teste.

1. API do SIGUEMA: atende o app ou será preciso um BFF? (depende de acesso)
2. Servidor: SO, exposição à internet, TLS (Docker é o ponto de partida).
3. A API real tem refresh token? Tempo de vida do token?
4. Firebase (push) é aceito pela LGPD? (decidir só quando push entrar)
5. Sentry e `drift`: manter na stack? (decidir depois)
6. URLs reais de homologação e produção.
7. Flavors no iOS e conta Codemagic (só quando houver build de iOS).
8. Fixar `freezed` na última estável antes do piloto.
9. Onde a tela de retorno e o convite de biometria entram nas rotas? (depende do design no Figma)

## Alpha v0.0.1 (protótipo com JSON local)
Escopo e marcos em `docs/ALPHA-0.0.1.md`. `flutter run --flavor dev -t lib/main_alpha.dart`: `alphaOverrides()` troca `authRepositoryProvider` (login falso com `assets/mock/usuarios.json`) e `semestreRepositoryProvider` (`assets/mock/turmas.json`) pelos `Json*Repository`, e fixa o relógio em 25/11/2026. `FonteJson` (`core/mock/`) simula 400–900 ms só na primeira leitura de cada arquivo e guarda em memória por 5 min; leituras simultâneas dividem uma espera. Início e Turmas vêm de **um** `ResumoSemestre`. A turma virtual lê `turma_<id>.json` e `frequencia_<id>.json` (o id da URL é validado antes de virar nome de arquivo); a frequência é calculada sobre todas as aulas e o mapa pagina 20 dias por vez. Os providers de repositório de dados (hoje `semestreRepositoryProvider`) lançam `UnimplementedError` fora do alpha: não há API. O `ProviderScope` usa `retry: semNovasTentativas` (sem o retry automático do Riverpod 3, para o erro aparecer na hora).
