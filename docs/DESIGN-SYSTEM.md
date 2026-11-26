# Design System — SIGUEMA Mobile

> Valores extraídos de `lib/core/theme/` e dos widgets. Origem: Figma "SIGUEMA Mobile — UI/UX Research" e site da UEMA. Se mudar o código, mude aqui.

**Figma:** [SIGUEMA Mobile — UI/UX Research](https://www.figma.com/design/1mlDbgjkCV77fX1cJGnthM/SIGUEMA-Mobile-%E2%80%94-UI-UX-Research?node-id=190-2). Fonte do design; o código segue o Figma.

## Modelo de apresentação do Figma (estrutura de páginas)
Reorganizado em 2026-11-25. Cada página começa com um "Cabeçalho da página" (objetivo, status, ordem de leitura). Só o que é decidido fica nas páginas numeradas; o resto vai para o Arquivo.

| Página | Conteúdo | Quem usa |
|---|---|---|
| 00 — Capa | Capa, versão e mapa do projeto | todos |
| 01 — Guia e mapa | Como usar o arquivo, personas e críticas | time |
| 02 — Pesquisa | Referências, inventário do portal, fichas REF-* | design |
| 03 — Fundamentos | Cores (claro e escuro), medidas (espaço e raios), texto, ícones | design e dev |
| 04 — Componentes | Componentes do app, do MVP e do login (propriedades de texto, variantes) | design e dev |
| 05 — Acesso (login oficial) | 1 wireframe, 2 alta fidelidade, 3 escolha do vínculo, 4 estados e especificação | todos |
| 06 — Discente | Telas do MVP (Início, Turma, Notas, Perfil) e propostas de Home | design e chefia |
| 06b — Apresentação do MVP | Para a chefia: 11 telas do discente em 4 grupos (Acesso, Navegação principal, Turma virtual, Perfil), cada uma com wireframe cinza em cima e tela final embaixo. São **cópias** das telas da 06 e da 05: se mudar a tela, refazer a cópia. A tela "Escolha do vínculo" ainda é a proposta antiga (escura), a refazer no estilo do login | chefia e time |
| 07 — Docente | Wireframes do professor | design |
| 08 — Fluxos | Fluxos com as ações entre telas | chefia e backend |
| 09 — Handoff | Endpoints, dados por tela, regras, tokens para o código, checklist | dev e backend |
| [FUTURO] Servidor, Admin | Pausados | — |
| Arquivo · Telas antigas | Telas v1 e v2; apagar quando não houver mais uso | — |

Convenções: cada tela tem **wireframe (cinza) → alta fidelidade → estados → especificação**; só instâncias da página 04, só variáveis (nada de cor fixa); dados sempre fictícios; nomes em português.

**Decisões de design registradas**
- Login: vale o estilo da página 05 (cabeçalho cheio com borda curva e filete laranja; telas: login, erro com teclado, retorno com digital, digital não reconhecida, convite). As propostas antigas foram apagadas.
- Home do discente (decisão de 2026-11-25, **substitui a "Hoje"**): tom limpo e leve; **Resumo do semestre primeiro** (CR e integralização), depois provas e atividades, mensagens e avisos e atalhos (notas, comprovante, histórico); sino de notificações e foto de perfil no topo. **Sem aulas de hoje** na Home. Rascunho em `06 — Discente` › "Home · rascunho Flat 2.0". Usa as variáveis `SIGUEMA / Tema UEMA (código)` e os estilos de texto do arquivo (fonte Inter só no Figma; no código a fonte é a do sistema). A seção antiga DISC-02H ("Hoje") fica como alternativa descartada até ser apagada.
- **Navegação inferior com 3 abas (2026-11-25, substitui as 4):** barra **flutuante** (solta das bordas, alinhada à margem de 24, branca, cantos 20, sombra suave) com 3 itens iguais; a **aba ativa sobe numa bolha azul** com o ícone, e a barra faz um recorte suave ao redor dela (referência: barra de navegação com bolha). O rótulo fica sempre embaixo, em negrito na ativa. A versão com botão central fixo foi descartada ("feia e desconectada").
- **Cabeçalho (2026-11-25):** como o cartão herói não sobrepõe mais, a altura caiu de 214 (Home) e 252 (Perfil) para **184 nas duas telas**, com 24 px até o primeiro cartão. No Perfil, foto e nome ficam em linha. Forma: curva `radius/40` nas telas do app. **O filete laranja voltou (2026-11-25, pedido do autor, para ficar no mesmo design do login):** é uma sombra sólida de 3 px (y 3, desfoque 0) na cor `laranja`, ligada à variável, que acompanha a curva do cabeçalho; aplicada no componente Cabeçalho e nas telas Início, Turmas, Perfil, Turma virtual, Mapa de frequência e Documentos. No código: `BoxShadow` sem desfoque, deslocamento (0, 3). O login segue com a curva de 28.
- **Turma virtual (tela de detalhe, sem barra inferior):** cabeçalho com voltar, nome da disciplina e horário; **frequência como herói** (anel de presença, faltas, mínimo de 75%, selo "Dentro do limite"); depois Notas (N1, N2, N3 e média), Próxima prova e Mensagens do professor. Sem o menu de topo do portal. Em `06 — Discente` › "Turma virtual (oficial)". Em aberto: Materiais e fórum entram agora? A frequência data a data abre ao tocar no anel?
- **Turma virtual, redesenho (2026-11-25, aguardando escolha):** o autor achou a versão anterior "paia" e a turma do portal tem informação demais. Ficam só frequência, notas, próxima avaliação, avisos do professor e contato; fora do MVP: estatísticas da turma, linha do tempo do portal, grupos, enquetes, questionários, chat, fóruns e lista de colegas (LGPD). Três propostas Flat 2.0 em `06 — Discente` › "Turma virtual · 3 variações": A (anel como herói), B (bento) e C (abas e linha do tempo). Dados fictícios. Escolhida a combinação A + C (abaixo); as 3 variações e a seção "Turma virtual (oficial)" antiga foram apagadas do Figma.
- **Turma virtual, escolha (2026-11-25): anel (A) + áreas em abas (C).** Resumo enxuto com o anel de frequência como herói; abaixo do cabeçalho, uma fileira de chips rolável (Resumo, Frequência, Notas, Materiais, Atividades), chip ativo em `azul-acao` e inativos em `fundo-campo`, no lugar da barra segmentada dentro do cabeçalho (estava fora do padrão). Cada aba é uma "área" que o aluno abre quando quiser. **Frequência:** mapa detalhado (anel menor, um ponto por aula, lista por mês com Presente/falta). **Materiais e Atividades:** fase 2, fora do MVP, desenhadas para mostrar que a turma cresce sem pesar o Resumo. Em `06 — Discente` › "Turma virtual · escolhida: anel (A) + áreas em abas (C)". Em aberto: Notas como aba própria (detalhe com 2ª chamada e final)? Contato do docente fica no Resumo?
- **Documentos (aba, 2026-11-25):** cabeçalho marinho (184) e barra inferior com a aba Documentos ativa. Grupo "Mais usados" (comprovante de matrícula, histórico escolar, relatório de notas) com botão tonal "Baixar"; grupo "Declarações e atestados", com selo de estado em texto e ponto: "Disponível" (PDF na hora) ou "Sob pedido" (retirada na secretaria). Em `06 — Discente` › "Documentos (oficial)". **Lista de documentos é proposta do design**: confirmar com a CTIC/secretaria quais saem em PDF.
- **Turmas (aba):** lista de cartões do semestre; cada cartão tem disciplina, horário e 3 fichas (frequência, última nota, próxima prova) e leva à turma virtual. Seletor de semestre no topo. Em `06 — Discente` › "Turmas (oficial)". Em aberto: mostrar o professor? semestres anteriores pelo seletor?
- **Perfil: refeito em versão enxuta (2026-11-26). Escolhida a variação C (identidade centralizada); A e B foram apagadas.** A página 06 só tem as telas oficiais; propostas antigas foram movidas para "Arquivo · Telas antigas". Perfil principal curto: cabeçalho (estilo do login, filete laranja), "Seu curso" com anel de integralização, CR, período e horas que faltam, **4 atalhos** (Meus dados, Meus documentos, Configurações, Ajuda) e Sair. Detalhes vão para telas filhas: **Meus dados** (só leitura; edição abre o portal, que pede senha; dados bancários e socioeconômicos ficam só no portal), **Configurações** (vínculo, digital, tamanho do texto, alto contraste, reduzir animações, privacidade, sobre) e **Ajuda** (FAQ, CTIC para problema do app, secretaria para questão acadêmica, relatar problema). Variações A (lista), B (bento) e C (identidade centralizada) em `06 — Discente` › "Perfil · 3 variações"; filhas em "Perfil · telas filhas". Dados fictícios. A seção "Perfil (oficial)" antiga fica até a escolha. Depende da API: horas que faltam (carga horária), foto, bio e período.
- **Perfil (escolhido: B, painel com anel):** abre pela foto do topo, sem barra inferior. Cabeçalho marinho com avatar, nome e vínculo; cartão "Seu curso" com anel de integralização e selo de matrícula ativa; fichas (CR, período); grupo Conta (trocar vínculo, digital, tamanho do texto); botão Sair isolado. Em `06 — Discente` › "Perfil (oficial)". Documentos não ficam no Perfil (aba Documentos). Em aberto: a foto vem do SIGUEMA? O período aparece em todos os cursos?
- **Anel de progresso** no herói da Home: integralização do curso (87% no exemplo) em anel azul sobre trilha azul clara, com o CR ao lado. Substitui a barra de progresso.
- **Espaçamentos (grade de 8):** margem lateral 24; entre grupos 24; título a 8 px do cartão; padding interno dos cartões 20; itens de lista a 16 px. Abas: Início, Turmas e Documentos (comprovantes, histórico, relatório de notas em PDF). **Perfil** abre pela foto no topo. **Notificações:** só o sino do topo (oficial); não há segundo ícone nem cartão de mensagens na Home. Sem cartões de atalho na Home. Situação sempre com texto e ícone, não só cor.
- **Princípios de UX da Home:** hierarquia visual clara (1 herói logo abaixo do cabeçalho, **sem sobreposição** (o autor testou a sobreposição e achou feia; escolha dele, 2026-11-25), depois provas, depois navegação); proximidade (título a 10 px do cartão, grupos a 24 px, itens do mesmo cartão a 12 px); Lei de Hick (poucas escolhas: 3 abas, 1 herói, 1 lista). **Decidido: herói A, "Resumo do semestre"** (CR e integralização), em `06 — Discente` › "Home do aluno (oficial) · Flat 2.0". A opção B (Próxima aula), o rascunho anterior e a Home "Hoje" foram apagados. Em aberto: "Ver tudo" em provas abre lista ou calendário? O CR aparece em todos os cursos?
- Selos usam `SIGUEMA / Cores` › `status/success|warning|danger` (e `-subtle`), que **existem no Figma mas não no `AppColors`**: `sucesso` e `aviso` já existem no `AppColors` (alpha); os fundos `-subtle` ainda não. Ícones ainda são placeholders.
- Medidas: variáveis `SIGUEMA / Medidas`, mais `radius/14` e `radius/28`, que o código usa.
- Componentes essenciais (página 04): **Botão** (Primário, Tonal, Texto × Padrão, Desabilitado, Carregando; o antigo "Contorno" virou "Tonal", sem borda), **Cabeçalho** (Cheio, Compacto, Com voltar), **Barra inferior** (aba ativa: Início, Turmas, Notas, Perfil; falta o selo de contador) e **Estado da tela** (Carregando, Vazio, Sem conexão, Sessão expirada). As mensagens de "Sem conexão" e "Sessão expirada" vêm do código; as de "Vazio" e os textos de apoio são propostas.
- **Estilo visual: Flat 2.0** (decisão do autor, 2026-11-25): design plano, **sem bordas duras**, cartões brancos com sombra suave (y 4, desfoque 16, 8% de azul-marinho), cantos grandes (16 a 28), tons de azul claro e muito espaço. Aplicado na Home e nos componentes essenciais da página 04 (Botão, Barra inferior, Estado da tela, Cartão de aula, Atalho); nova variável `radius/24`. Ainda no estilo anterior: os componentes do login (Campo e Botões, com borda), o Cabeçalho (mantém marinho e filete laranja, como o login oficial) e as telas do MVP da página 06. O autor ainda vai trazer referências (ex.: Pinterest) para ajustar; depois, atualizar Fundamentos, Componentes e este arquivo. No código: sombra e raios viram constantes novas.

## Cores (`AppColors`)
| Token | Hex | Uso |
|---|---|---|
| `marinho` | `#0F1E44` | Cabeçalhos, barra inferior; semente do `ColorScheme` |
| `marinhoClaro` | `#16295F` | Só formas decorativas do cabeçalho |
| `azulAcao` | `#2C46C9` | Botões, links, foco dos campos (`primary`) |
| `laranja` | `#FF7302` | Filetes, selos, destaques (`tertiary`) |
| `tinta` | `#262930` | Texto principal |
| `textoSecundario` | `#6B7080` | Texto secundário |
| `textoSuave` | `#A8ADBA` | Texto de apoio fraco |
| `textoSobreMarinho` | `#AEB9DD` | Texto sobre fundo marinho |
| `branco` | `#FFFFFF` | Superfícies (cartões) e texto sobre marinho |
| `fundoTela` | `#F6F7FB` | Fundo das telas do app (Flat 2.0) |
| `sucesso` | `#167A43` | Figma `status/success` (claro). Sempre com texto e ícone |
| `aviso` | `#8F6A00` | Figma `status/warning` (claro). Sempre com texto e ícone |
| `sucessoFundo` | `#DDF3E6` | Fundo do selo de sucesso (`status/success-subtle`) |
| `perigo` | `#C42128` | Figma `status/danger` (claro): falta, acima do limite |
| `perigoFundo` | `#FBE3E3` | Fundo do selo de perigo (`status/danger-subtle`) |
| `avisoFundo` | `#FDF3C9` | Fundo do selo de atenção (`status/warning-subtle`); o texto do selo "Sob pedido" fica em marinho |
| `borda` | `#D9DBE3` | Bordas |
| `fundoHero` | `#F2F2F5` | Fundo do hero da Home |
| `fundoCampo` / `fundoCampoFoco` | `#F0F3FC` / `#E9EEFF` | Campo de texto normal / em foco |
| `fundoCampoErro` | `#FCEEEE` | Campo com erro |
| `erro` | `#C73333` | Erro |
| `azulClaro` | `#E6EBFF` | Quadrado tonal atrás de ícones, fichas, trilha do anel |

Marinho e laranja foram lidos do site; trocar pelo manual de marca quando a UEMA enviar.

## Tema (`AppTheme`)
- Material 3 (`useMaterial3: true`), `ColorScheme.fromSeed(marinho)` com `primary`, `onPrimary`, `tertiary` e `error` sobrescritos.
- Fundo das telas: branco.
- **Só existe tema claro.** `App` não define `darkTheme`.
- `fontFamily: PublicSans` no tema. Estilos de texto do Figma em `AppText` (`titulo24`, `display32`, `subtitulo18`, `corpo15`, `corpo13`, `legenda11`); sem `textTheme` nem `componentTheme` customizados.

## Tipografia
**Decisão do autor (2026-11-25): fonte Public Sans** (no Figma, em todas as páginas e nos estilos de texto, no lugar da Inter). **No código (alpha, 2026-11-26):** Public Sans Regular, Medium, SemiBold e Bold empacotadas em `assets/fonts/` (licença OFL em `assets/fonts/OFL.txt`) e declaradas no `pubspec.yaml`; nada é baixado em tempo de execução. Alternativa considerada: Atkinson Hyperlegible (baixa visão). Tamanhos e pesos usados inline:
- Tamanhos: 11, 12, 13, 14, 15, 18, 22, 24, 26 (13 é o mais comum).
- Pesos: `w600` (mais usado) e `w700`.

## Espaçamento e forma
- Padding lateral das telas: 24 (login), 14–20 (cartões).
- Espaços verticais comuns: 6, 10, 14, 20 (`SizedBox`).
- Raios: **14** (padrão, em campos e cartões), 12, 16, 18, 30; cabeçalho com borda curva de 28; 999 para pílulas.
- Constantes em `core/theme/`: `AppRadius` (r8…r40, pílula), `AppSpace` (grade de 8, margem 24, toque 44), `AppShadows` (cartão, filete laranja, bolha) e `Motion` (150/250/400/900 ms, curvas, escala 0,97). Widgets novos usam essas constantes; o código do login ainda tem números soltos.

## Componentes
| Componente | Arquivo | Função |
|---|---|---|
| `CabecalhoLogin` | `features/auth/presentation/widgets/` | Cabeçalho marinho com borda curva e filete laranja |
| `BrasaoUema` | idem | Brasão |
| `CampoLogin` | idem | Campo de texto (CPF, senha) com estados foco/erro |
| `CartaoAjuda` | idem | Cartão de ajuda no login |
| `CartaoVinculo` | idem | Opção de vínculo |
| `HeroHome`, `CartaoTurma`, `MenuConta` | `features/home/presentation/widgets/` | Hero, turma, avatar com menu (Trocar vínculo, Sair) |
| `ConviteBiometriaSheet` | `features/auth/presentation/` | Convite para ativar a digital |

Componentes compartilhados do alpha ficam em `core/widgets/`: `CabecalhoApp` (184, curva 40, filete laranja), `CartaoPressionavel` (Flat 2.0, escala 0,97), `AnelProgresso` + `NumeroAnimado`, `BrilhoEsqueleto`/`CaixaEsqueleto`, `ConteudoAssincrono` (esqueleto → dados/vazio/erro com `AnimatedSwitcher`), `EntradaEscalonada`, `AvatarPerfil` (com `Hero`), `BotaoSino`, `CabecalhoVoltar` (Cabeçalho com voltar, altura do conteúdo, 22 px), `SeloSituacao` (ponto + texto, sucesso ou perigo), `mostrarAviso` e `paginaSuave` (transição de página). A barra inferior está em `features/shell/` (`BarraBolha`: bolha que desliza, recorte na barra). Os componentes do login seguem dentro de `features/auth/`.

## Ícones
**Decisão do autor (2026-11-26): Lucide.** Conjunto de 27 componentes no Figma, página `03 — Fundamentos` › "Ícones · Lucide (oficial do app)" (traço 2 px, grade 24, licença ISC). Lista de papéis e tamanhos em `docs/ALPHA-0.0.1.md`. **No código (alpha):** pacote `lucide_icons_flutter ^4.0.3` e todos os ícones novos passam por `core/theme/app_icons.dart` (um papel, um ícone). Papel extra `expandir` (chevron-down), que substitui o glifo "▾" do seletor de semestre (a Public Sans não tem esse caractere). O login ainda usa Material Icons.

**Fluxo do app:** mapa com miniaturas e setas em `08 — Fluxos` › "Fluxo do app · Alpha v0.0.1". **Escolha do vínculo (oficial):** refeita no estilo do login em `05 — Acesso` › "Escolha do vínculo (oficial) · estilo do login" (seleção em `azul-claro` com marca de check, sem borda dura).

## Regras de uso
- Cores só via `AppColors`; nada de hex solto.
- Laranja **não** vai como cor de texto sobre branco (contraste baixo).
- Azul de ação para ações e foco; marinho para estrutura.
- Textos e mensagens em português, sem dado pessoal.

## Em aberto
Decisões do autor: tema escuro fica para uma atualização futura; o Figma terá um design system organizado (tokens → componentes → telas); o autor vai buscar fonte, manual de marca e acessibilidade.

1. Fonte oficial da UEMA (a buscar).
2. Cores oficiais do marinho e do laranja (manual de marca, a buscar).
3. Acessibilidade (eMAG/WCAG): nível-alvo, toque mínimo, escala de fonte (a buscar).
4. Link do arquivo no Figma.
5. Escala de espaçamento e tipografia do Figma, para virar tokens no código.
6. Tema escuro: futuro, sem data.
7. **Pendência de acabamento no Figma (pedido do autor, 2026-11-25):** na apresentação final do MVP, cada tela com **wireframe (cinza) ao lado da alta fidelidade**; **barra inferior bonita já com a aba certa selecionada** em Início, Turmas e Documentos; tudo alinhado, com espaçamentos da grade de 8 e visual polido ("perfeitinho").


## Turma virtual no código (alpha M2, 2026-11-26)
Implementada a escolha A + C: cabeçalho com voltar, chips rolantes (Resumo, Frequência, Notas, Materiais, Atividades) e a área da aba. Resumo, Mapa de frequência e demais áreas seguem o Figma (`06 — Discente` › "Turma virtual · escolhida"). Diferenças e extrapolações, para o Figma alcançar:
- **Cabeçalho muda por aba:** título "Mapa de frequência" na Frequência (Figma); em Notas, Materiais e Atividades o título é o nome da aba e o voltar leva ao Resumo (extrapolado).
- **Notas (sem design ainda):** o mesmo cartão N1, N2, N3 e Média do Resumo, mais uma lista (Nota 1, 2, 3, 2ª chamada, prova final, média). Precisa ser desenhada.
- **Materiais e Atividades:** só o chip e um cartão "chegam em breve" (a versão da fase 2 do Figma não entra no alpha).
- **Mapa de frequência:** lista por mês com **mais recentes primeiro** (o Figma mostra setembro em ordem crescente) e rolagem infinita de 20 dias por vez; um ponto por aula. "Acima do limite" e "Abaixo do mínimo" (selo de perigo) não têm tela no Figma.
- **Toque:** chips com área de 44 (o chip visível segue com 35) e botão de voltar com 44.
- **Docente:** tocar mostra o e-mail fictício (o alpha não abre o app de e-mail).

## Documentos no código (alpha M3, 2026-11-26)
Segue o Figma (`06 — Discente` › "Documentos (oficial)"): cabeçalho marinho de 184 sem círculo decorativo e com o texto encostado embaixo, grupos "Mais usados" (botão tonal "Baixar") e "Declarações e atestados" (selo Disponível ou Sob pedido). Extrapolações a confirmar com o design:
- **Campo de busca (não existe no Figma):** entre o cabeçalho e os grupos, no estilo dos campos do app (`fundoCampo`, raio 16, sem borda), com botão de limpar. Filtra por título e subtítulo, sem acento, 300 ms depois da última tecla; sem resultado mostra "Nenhum documento encontrado para ...". Se o design não quiser a busca, é só tirar o `CampoBusca`.
- **Toque:** a linha inteira é tocável; no alpha só mostra um aviso (não há PDF real).
- **Lista:** os 5 itens do Figma; a lista real de documentos continua dependendo da CTIC/secretaria.

## Perfil e telas filhas no código (alpha M4, 2026-11-26)
Segue o Figma (`06 — Discente` › "Perfil (oficial) · identidade centralizada" e "Perfil · telas filhas"): Perfil (foto de 88 com `Hero`, resumo CR, período e integralização, 4 atalhos, Sair), Meus dados (só leitura, edição "no portal"), Configurações e Ajuda. Cabeçalhos com quadrado inclinado de 18° no canto (`DecoracaoCabecalho.quadradoInclinado`); `CabecalhoVoltar.filha` (título de 24, topo 64, base 28). Componentes novos em `core/widgets/`: `FundoCabecalho`, `CartaoLista` + `LinhaMenu`, `Interruptor` (50 × 28), `SeletorSegmentado`. Ícones novos: `informacao` (info) e `politica` (message-square). Extrapolações a confirmar com o design:
- **Botão de voltar no Perfil** (chevron no canto): o Figma não desenha, mas sem ele o iOS não tem como sair (a transição própria não tem o gesto de arrastar).
- **Trocar vínculo** só aparece com mais de um vínculo (o Figma mostra sempre).
- **Ajuda:** as perguntas abrem a resposta ali mesmo (o Figma mostra uma seta, sem tela de resposta) e há um campo de busca (não existe no Figma; mesmo estilo dos Documentos, debounce de 300 ms). Contatos abrem um diálogo com e-mail, telefone e horário fictícios.
- **Configurações:** "Reduzir animações" e "Tamanho do texto" (Pequeno 0,9, Médio 1, Grande 1,15 do tamanho do sistema) já valem no app todo; "Alto contraste" vale no app todo (M5). Tudo fica só em memória. "Entrar com a digital" é simulado. "Sobre o app" mostra `Versão 0.0.1 (alpha)` (`core/config/versao_app.dart`, manter igual ao `pubspec`).
- **Meus documentos** (atalho do Perfil) leva à aba Documentos.

## Alto contraste e movimento reduzido (alpha M5, 2026-11-26)
O Figma não desenha o modo de alto contraste; esta é a proposta implementada (`core/theme/contraste_app.dart`), a confirmar com o design: fundo das telas e preenchimentos tonais viram branco, a sombra suave sai, e cartões, fichas, chips, campos, seletores e selos ganham borda de 1,5 px em marinho (no selo, na cor do próprio selo). Fios de lista, setas e interruptor desligado usam `textoSecundario`; a trilha do anel usa `textoSuave`; a barra inferior ganha contorno. Vale também quando o sistema pede contraste alto. Movimento reduzido, medição e pontos de atenção: `docs/DESEMPENHO-ALPHA.md`.
