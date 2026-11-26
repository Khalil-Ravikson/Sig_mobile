# Notas do alpha v0.0.1

> Para quem vai abrir o app: o que é de mentira, como testar e o que ainda não foi verificado. Escopo e decisões em `ALPHA-0.0.1.md`; movimento e medição em `DESEMPENHO-ALPHA.md`.

## O que é
Protótipo **navegável** do discente, para mostrar o fluxo e a sensação do app. **Não chama API, não usa banco e não guarda nada no aparelho.** Tudo vem de JSON em `assets/mock/`, lido por `Json*Repository` trocados em `lib/alpha_overrides.dart`.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor dev -t lib/main_alpha.dart
```

## Entrar (dados de demonstração)
Senha de todos: `alpha123` (só do alpha; vive em `assets/mock/usuarios.json`).

| CPF | O que mostra |
|---|---|
| `00000000001` | 1 vínculo (discente): pula a escolha e abre o Início |
| `00000000002` | 2 vínculos de discente: mostra a escolha |
| `00000000003` | docente e servidor: tela "em breve" |
| `00000000004` | sem vínculo ativo: aviso para procurar a secretaria |

Fluxo para mostrar: login → Início → Turmas → uma turma → Frequência (role até carregar a 2ª página) → Documentos (digite na busca) → foto do topo → Perfil → Configurações (tamanho do texto, reduzir animações, alto contraste).

## O que é fictício (tudo)
- **Pessoas:** nomes com "Exemplo" (Ana Exemplo Souza e os docentes), CPFs `0000000000N`, e-mails `.invalid`, telefones `(98) 9000x-000x`, matrícula `2022000001`. Um teste (`test/core/dados_ficticios_test.dart`) quebra se um dado fora desse padrão entrar nos JSON.
- **Acadêmico:** disciplinas, notas, CR (7,25), integralização (87%), 32 aulas e 2 faltas na turma de Sinais, provas de dezembro. As disciplinas e os números vieram do Figma.
- **Documentos, perguntas frequentes e contatos da Ajuda:** textos de exemplo. A lista de documentos é proposta do design; falta a CTIC/secretaria dizer quais saem em PDF.
- **Hoje é sempre 25/11/2026** (`relogioDoAlpha`), porque os JSON têm datas fixas. "Em 8 dias" é calculado a partir dele.

## O que é simulado
- **Login:** confere CPF e senha de demonstração contra o JSON. O token é um texto fixo na memória. A senha de verdade nunca é guardada.
- **Espera da rede:** 400 a 900 ms na primeira leitura de cada arquivo (para o esqueleto aparecer); depois, cache de 5 min.
- **Digital:** o interruptor existe, mas não chama o leitor do aparelho.
- **Botões sem destino:** "Baixar" (não gera PDF), e-mail do docente e contatos (mostram o endereço fictício), "Atualizar no portal", "Política de privacidade", "Relatar um problema", "Ver tudo" das provas, sino de notificações (o ponto laranja é fixo) e seletor de semestre (só 2026.2). Todos mostram um aviso.
- **Preferências** (texto, contraste, animações, digital): só em memória; voltam ao padrão quando o app fecha.

## Fora do alpha
API real, banco, push, cache em disco, docente e servidor (tela "em breve"), Materiais e Atividades da turma (só o chip), edição de dados (abre o portal), tema escuro, tela de retorno com digital e convite de biometria (existem no código, fora das rotas).

## Antes de qualquer release fora do alpha
- `assets/mock/` está declarado no `pubspec.yaml` e **vai em todos os flavors**, inclusive `producao`. Ele traz a senha de demonstração. Antes de publicar nas lojas: tirar `assets/mock/` do `pubspec.yaml` (ou movê-lo para um flavor só do alpha) e trocar o `main_*` para a API real.
- Fora do alpha, os repositórios de dados lançam `UnimplementedError` (não há API); os flavors `dev`, `homologacao` e `producao` só funcionam até o login.
- O `release` Android ainda assina com a chave de debug.
- O CI usa `dart format --output=none --set-exit-code`; neste Dart o flag certo é `--set-exit-if-changed`.

## Mudanças de dependência e `pubspec.yaml` deste alpha
Pacote novo: `lucide_icons_flutter ^4.0.3` (ícones). Assets: `assets/mock/`. Fonte: Public Sans (OFL) em `assets/fonts/`. Versão: `0.0.1+1`. Sugestão: um PR só para o `pubspec.yaml` (e o que ele referencia), antes dos demais.

## Ainda não verificado
- Execução em Android e iOS reais, em modo profile (só tem o roteiro em `DESEMPENHO-ALPHA.md`). O build de iOS não foi tentado.
- A fluidez das transições e do `Hero` em aparelho.
- Leitores de tela (TalkBack e VoiceOver): os rótulos e estados foram testados em teste, não no aparelho.
- Alto contraste só foi visto em Configurações e Turmas.
- Telas que extrapolam o Figma (busca em Documentos e Ajuda, aba Notas, botão de voltar do Perfil, selos de limite, alto contraste): listadas em `DESIGN-SYSTEM.md`, aguardam o design.
