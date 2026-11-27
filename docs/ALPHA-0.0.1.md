# Alpha v0.0.1 — protótipo navegável (sem API, sem banco)

> Objetivo: **mostrar o fluxo e a sensação do app**, com dados de um JSON local. Não é produção. Atualize quando o escopo ou o design mudar. Design: Figma (páginas 06, 06b) e `docs/DESIGN-SYSTEM.md`.

## Escopo do alpha
**Entra (discente):** login e vínculo (já existem), Início, Turmas, Turma virtual (abas Resumo e Frequência; Notas simples), Documentos, Perfil (+ Meus dados, Configurações, Ajuda).
**Fica de fora:** API real, banco, push, cache em disco, docente, Materiais e Atividades (só o chip "em breve"), edição de dados (abre o portal: no alpha, só um aviso).
**Versão:** `0.0.1+1` no `pubspec.yaml` (feito no M6). `core/config/versao_app.dart` mostra a versão em "Sobre o app" e um teste confere que as duas batem.

## Dados: só JSON, tudo fictício
Pasta `assets/mock/` (declarar em `pubspec.yaml`, PR separado). Nada de CPF, nome ou nota reais.
| Arquivo | Conteúdo |
|---|---|
| `aluno.json` | nome, iniciais, matrícula fictícia, curso, nível, status (`ativo`, `trancado` ou `concluido`), entrada, período, CR, integralização (`percentual`, `horasObrigatoriasFaltam`, `horasOptativasFaltam`), e-mail e telefone fictícios, vínculos |
| `turmas.json` | lista do semestre: id, disciplina, horário, resumo (frequência %, última nota, próxima prova) |
| `turma_<id>.json` | `turma` (código), notas (N1, N2, N3, média, 2ª chamada, final), avaliações (data, hora, descrição), docente (nome, e-mail), avisos (no JSON, ainda sem tela) |
| `frequencia_<id>.json` | `minimoPercentual` (75) e `aulas[]`: um item por dia de aula com `data`, `aulas` e `faltas` (ausente ou 0 = presente) |
| `documentos.json` | itens: título, subtítulo, tipo, estado (`disponivel` ou `sob_pedido`) |
| `ajuda.json` | perguntas frequentes e contatos (CTIC, secretaria), textos fictícios |
O app lê pelos **Repositories** (`Result<T>`), com implementações `Json*Repository` trocadas por override no `main_alpha.dart`. A UI não sabe que é JSON: quando a API existir, troca-se a implementação.

## Fluxo e rotas (go_router)
```
/login → /vinculo (se houver mais de um) → shell com 3 abas
  /inicio        /turmas              /documentos
                   └ /turmas/:id?aba=resumo|frequencia|notas|materiais|atividades
  foto no topo → /perfil → /perfil/dados · /perfil/config · /perfil/ajuda
```
- A barra inferior só aparece nas 3 abas. Turma virtual e Perfil abrem **por cima** (sem barra), com voltar.
- O estado da aba da turma vive na URL (`?aba=`): voltar e compartilhar funcionam.
- `redirect` continua dependendo só da `Sessao`.

## Ícones (decisão do autor, 2026-11-26: Lucide)
Os ícones oficiais são **Lucide** (traço de 2 px, pontas arredondadas, grade de 24; licença ISC), em quadrado tonal `azul-claro` com o ícone em `azul-acao`. O conjunto está no Figma, página `03 — Fundamentos` › "Ícones · Lucide (oficial do app)": 27 componentes `icon/<papel>`, cada um com o nome do Lucide de origem.
- **No código:** usar um pacote Lucide para Flutter (**pacote novo: confirmar nome e versão no pub.dev e avisar antes de instalar**). Alternativa sem pacote: copiar os SVG dos ícones usados para `assets/icons/` (precisa de renderizador de SVG, que também é pacote).
- **Todos os ícones passam por `core/theme/app_icons.dart`** (um papel → um ícone), para trocar num lugar só. Papéis: `inicio` (house), `turmas` (book-open), `documentos` (file-text), `perfil` (user), `meusDados` (id-card), `configuracoes` (sliders-horizontal), `ajuda` (circle-question-mark), `trocarVinculo` (arrow-left-right), `digital` (fingerprint-pattern), `textoTamanho` (a-large-small), `contraste` (contrast), `privacidade` (shield-check), `sair` (log-out), `voltar` (chevron-left), `seta` (chevron-right), `externo` (arrow-up-right), `sino` (bell), `calendario` (calendar), `pdf` (file-down), `sucesso` (check), `erro` (circle-x), `materiais` (folder), `atividades` (clipboard-check), `busca` (search), `email` (mail), `telefone` (phone), `vinculoDiscente` (graduation-cap).
- Tamanhos: 24 (abas), 22 (dentro do quadrado tonal), 18 (botões e linhas). Área de toque mínima de 44.

## Movimento (o app não pode parecer duro)
Regra geral: **animar o que explica uma mudança**, nunca decorar o que é frequente. Sem pacote: Flutter nativo.
| Tokens | Valor |
|---|---|
| `Motion.rapido` | 150 ms (toque, troca de ícone) |
| `Motion.padrao` | 250 ms (estados, abas, selos) |
| `Motion.suave` | 400 ms (entrada de tela, listas) |
| `Motion.anel` | 900 ms (anel de progresso e contagem de números) |
| Curvas | `easeOutCubic` (entrada), `easeInCubic` (saída), `easeInOutCubicEmphasized` (troca de aba) |
Onde:
1. **Troca de aba:** a bolha azul da barra desliza até a nova aba (`AnimatedPositioned`/`TweenAnimationBuilder`); o conteúdo troca com `AnimatedSwitcher` (fade + 8 px de deslocamento).
2. **Abrir turma e perfil:** transição de página própria (`CustomTransitionPage`): fade + leve subida; a foto do topo usa `Hero` até o Perfil.
3. **Anel de frequência e de integralização:** de 0 até o valor em `Motion.anel`, `easeOutCubic`; o número acima conta junto.
4. **Listas:** entrada **escalonada** (cada item ~40 ms depois do anterior, no máximo 8 itens animados), uma vez só por abertura.
5. **Toque:** cartões e botões reduzem a 0,97 ao pressionar e voltam (150 ms); ripple discreto.
6. **Estados:** `AnimatedSwitcher` entre carregando (esqueleto), conteúdo, vazio e erro. Nada pula.
7. **Chips da turma:** o chip ativo troca de cor com `AnimatedContainer`; a fileira rola até o chip.
8. **Acessibilidade:** respeitar `MediaQuery.disableAnimations`: sem deslocamento, só troca de opacidade curta ou nenhuma. Há a opção "Reduzir animações" no Perfil.
Evitar: `Opacity` em listas grandes, animações em loop sempre ligadas, bounce exagerado, animação que atrasa o toque.

## Desempenho: o que se aplica ao alpha (e o que não)
Verdade simples: parte dessa lista é de **backend**, que o alpha não tem. Aqui vai o que faz sentido sem servidor, e o que fica só preparado.
| Item | No alpha |
|---|---|
| **Skeleton** | Sim. Esqueleto com brilho (feito à mão com `ShaderMask`/`AnimatedBuilder`, sem pacote) para Início, Turmas, Turma, Documentos. O Repository simula 400 a 900 ms de espera para o esqueleto aparecer. |
| **Imagens WebP/AVIF** | **WebP** nos assets (brasão, avatar de exemplo). AVIF depende do sistema e não tem suporte estável em todo aparelho: **não usar no alpha**. Dimensionar com `cacheWidth`/`cacheHeight`. |
| **Debounce** | Sim, 300 ms na busca de Documentos e do FAQ da Ajuda. |
| **Paginação** | Sim, simulada: Mapa de frequência carrega 20 aulas por vez (rolagem infinita sobre o JSON); `ListView.builder`. |
| **Cache** | Sim, em memória no Repository, com validade (ex.: 5 min), para não reler o JSON a cada abertura. Sem disco (drift fica fora). |
| **N+1** | Evitar no desenho: Início e Turmas vêm de **um** `ResumoSemestre` (um carregamento), não de uma chamada por turma. |
| **CDN** | Não se aplica sem servidor. Assets vão no pacote do app. |
| **Fila** | Não se aplica no alpha. Deixar a interface do Repository pronta para uma fila de ações offline no futuro. |
| **Índices** | Não se aplica sem banco. No JSON, indexar por `id` (mapas) em vez de varrer listas. |
Boas práticas de renderização: `const` onde der, `RepaintBoundary` em anéis e listas animadas, sem `build()` pesado, medir em **modo profile** (não em debug) e conferir o DevTools (sem quadros acima de 16 ms). Impeller já é o padrão do iOS.

## Marcos do alpha (cada um termina com format, analyze e test limpos)
1. **M0 Base:** `main_alpha.dart`, `assets/mock`, tokens (`AppColors`, `AppRadius`, `AppSpace`, `Motion`), fonte, `app_icons.dart`, `ShellRoute` com a barra de bolha.
2. **M1 Início e Turmas** (com esqueleto, cache e animação do anel).
3. **M2 Turma virtual** (Resumo, Frequência paginada, chips por URL).
4. **M3 Documentos** (busca com debounce).
5. **M4 Perfil** e telas filhas.
6. **M5 Polimento:** movimento, "Reduzir animações", alto contraste, revisão em modo profile.
7. **M6 Release alpha:** versão `0.0.1+1`, notas do que é fictício (`NOTAS-ALPHA-0.0.1.md`). **Todos os marcos (M0 a M6) estão feitos.**

## Login falso (decisão do autor, 2026-11-26)
O alpha **não chama API nenhuma**: o login confere CPF e senha contra `assets/mock/usuarios.json`. Cada usuário tem CPFs **fictícios** (os de `mock/README.md`), uma **senha de demonstração** só para o alpha, nome, iniciais e a lista de vínculos (um usuário com um vínculo e outro com vários, para mostrar as duas rotas). Regras: nunca CPF, senha ou nome reais, nem aqui nem nos testes; a senha de demonstração **não** vai para release; o app continua sem guardar senha no aparelho (só um token falso de sessão em memória). Erro de senha mostra o estado de erro do login. A digital também é simulada.
O login falso vive em `JsonAuthRepository`, trocado por override no `main_alpha.dart`; o `AuthRepository` real continua igual.

## Fonte
**Public Sans** (decisão do autor). Empacotar em `assets/fonts` e declarar no `pubspec.yaml` (**PR pequeno e separado**), sem baixar do Google em tempo de execução. Pesos usados: Regular, Medium, SemiBold, Bold.

## Em aberto
1. ~~Pacote Lucide~~: `lucide_icons_flutter ^4.0.3` (confirmado no pub.dev; os 27 ícones existem).
2. Telas ainda não desenhadas: aba Notas da turma, Materiais e Atividades (fase 2).
3. Contatos reais da CTIC e da secretaria para a Ajuda (hoje fictícios).
