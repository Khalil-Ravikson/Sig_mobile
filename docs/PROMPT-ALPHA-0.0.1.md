# Prompt — SIGUEMA Mobile Alpha v0.0.1

> Cole o bloco abaixo no agente (Claude Code, Codex etc.), na raiz do projeto. Ele segue o que a documentação oficial do Flutter recomenda para agentes: **planejar antes**, nomear os padrões, dar restrições claras, exigir **ponto de parada** antes do código e **limpar o contexto entre marcos**. Revise cada arquivo gerado.

---

Você é um engenheiro Flutter sênior. Vamos construir o **alpha v0.0.1** do app SIGUEMA Mobile (UEMA): um protótipo navegável, **fluido e animado**, que **mostra o fluxo** usando só **arquivos JSON locais**. Sem API, sem banco.

## 1. Leia antes de qualquer coisa (obrigatório)
`AGENTS.md`, `docs/PRD.md`, `docs/ARCHITECTURE.md`, `docs/DESIGN-SYSTEM.md` e **`docs/ALPHA-0.0.1.md`** (escopo, dados, rotas, ícones, movimento, desempenho e marcos). Se algum deles conflitar com este prompt, vale o documento. Leia também `lib/features/auth/` (referência de padrão) e `lib/core/theme/`.
O design vem do **Figma** (páginas `06 — Discente`, `06b — Apresentação do MVP`, `05 — Acesso`). Não invente visual: se faltar uma decisão de design, **pare e pergunte**.

## 2. O que construir
Telas do discente: Início, Turmas, Turma virtual (abas Resumo, Frequência e Notas; Materiais e Atividades só como chip "em breve"), Documentos, Perfil, Meus dados, Configurações e Ajuda. Barra inferior flutuante com bolha (3 abas); Turma virtual e Perfil abrem sem barra. Detalhes de cada tela, rotas e campos do JSON estão em `docs/ALPHA-0.0.1.md`.

## 3. Regras de arquitetura (não negociáveis)
- **Feature-first + MVVM + Repository**, **Riverpod**, **go_router**, `freezed`/`json_serializable`. `presentation → domain ← data`. A UI nunca lê asset nem chama `dio`.
- Repository devolve `Result<T>` (`core/error`), nunca lança. DTO + Mapper para o JSON. Modelo de domínio não herda o formato do JSON.
- Os dados vêm de `Json*Repository` lendo `assets/mock/*.json`; trocar a implementação por override em `lib/main_alpha.dart`. Simular latência de 400 a 900 ms **só** nessa camada.
- Estados de tela com `AsyncValue`/sealed classes: carregando (esqueleto), dados, vazio, erro. Sem lógica de negócio em `build()`.
- Cores só por `AppColors`; raios, espaços e movimento por constantes (`AppRadius`, `AppSpace`, `Motion`). Ícones só por `core/theme/app_icons.dart`.
- Dados 100% fictícios. Nunca CPF, nome, nota ou e-mail reais, nem em teste.

## 4. Experiência: fluida, nada de "duro"
Siga a seção **Movimento** de `docs/ALPHA-0.0.1.md`: tokens de tempo e curva, bolha da barra deslizando, troca de aba com `AnimatedSwitcher`, transições de página próprias, `Hero` da foto até o Perfil, anel de progresso e números animando de 0 ao valor, listas com entrada escalonada (máximo 8 itens), escala 0,97 ao tocar, `AnimatedSwitcher` entre esqueleto, conteúdo, vazio e erro. Respeite `MediaQuery.disableAnimations` e a opção "Reduzir animações". Nenhuma animação pode atrasar um toque. **Sem pacote de animação**: use Flutter nativo.

## 5. Desempenho (aplique só o que cabe no alpha)
Esqueleto com brilho feito à mão; busca com **debounce de 300 ms** (Documentos e FAQ); **paginação** simulada de 20 itens no Mapa de frequência; **cache em memória** com validade no Repository; **evitar N+1** (Início e Turmas vêm de um único `ResumoSemestre`); imagens em **WebP** com `cacheWidth`/`cacheHeight`; `const`, `RepaintBoundary` em anéis e listas animadas, `ListView.builder`. **CDN, fila e índices de banco não se aplicam sem backend**: não invente; deixe só a interface do Repository pronta. AVIF: não usar. Meça em **modo profile**, não em debug.

## 6. Como trabalhar (processo)
1. **Plano primeiro.** Antes de escrever código, entregue: árvore de arquivos que vai criar ou mudar, esquema de cada JSON, tabela de rotas, lista de providers e uma estimativa por marco (M0 a M6 do documento). **Pare e espere minha aprovação.**
2. **Um marco por vez.** Ao fim de cada marco: `dart format .`, `flutter analyze`, `flutter test` limpos, resumo curto do que mudou e **pare** para eu revisar. Eu limpo o contexto entre marcos.
3. **Testes junto com a regra:** Repositories (JSON, cache, paginação, debounce), view models e um teste de widget por tela principal. TDD quando fizer sentido.
4. **Pergunte antes de:** instalar qualquer pacote, mexer em `pubspec.yaml` (assets, fonte, versão: PR separado), mudar `core/` ou o contrato `mock/openapi.yaml`, ou tomar decisão de design.
5. **Não faça commit nem push.** Sugira a mensagem (Conventional Commits) e a divisão em PRs pequenos (~400 linhas).

## 7. Pronto quando
O app roda com `flutter run --flavor dev -t lib/main_alpha.dart`; o fluxo login → Início → Turma → Frequência → Documentos → Perfil funciona só com os JSON; as transições são suaves em modo profile; não há erro no analyze; os testes passam; nenhum dado real; e você relata **o que foi feito, o que não foi e o que não foi verificado**, inclusive falhas.

Comece **só pelo plano** (passo 1 da seção 6).
