# Desempenho e movimento — alpha v0.0.1

> Revisão do M5. O que foi aplicado, o que **não** se aplica sem servidor, e como medir no aparelho. Atualize quando algo mudar.

## Aplicado
| Item | Onde |
|---|---|
| Esqueleto com brilho feito à mão (um controlador para todos os blocos; parado com "Reduzir animações") | `core/widgets/brilho_esqueleto.dart` |
| Cache em memória com validade de 5 min; leituras simultâneas dividem uma espera; falha não fica no cache | `core/mock/fonte_json.dart` |
| Um só carregamento para Início e Turmas (sem N+1) | `ResumoSemestre`, `resumoSemestreProvider` |
| Debounce de 300 ms (Documentos e FAQ da Ajuda) | `core/util/debouncer.dart` |
| Paginação simulada de 20 dias no Mapa de frequência; lista lazy (`SliverList.builder`); pontos desenhados de uma vez só (`CustomPaint`) | `frequencia_view_model.dart`, `pontos_frequencia.dart` |
| `RepaintBoundary` em anéis, na barra inferior, nos pontos e em cada item que entra escalonado | widgets de `core/` |
| Entrada escalonada limitada a 8 itens, uma vez por abertura | `entrada_escalonada.dart` |
| Abas mantidas vivas (`Offstage` + `TickerMode`): a aba escondida não anima nem repinta | `container_abas.dart` |
| Sem `Opacity` em listas grandes; `Opacity(1)` não cria camada | — |
| Sem pacote de animação nem de imagem; nenhuma imagem de rede | — |

## Não se aplica ao alpha (sem backend)
CDN, fila de ações offline, índices de banco. O que existe é a **interface** dos Repositories, pronta para a API. AVIF: não usar. WebP e `cacheWidth`/`cacheHeight`: o app ainda não tem nenhuma imagem (a foto é um círculo com iniciais e o brasão é um círculo com a sigla); vale quando a UEMA enviar o brasão e a API tiver foto.

## Movimento e acessibilidade
- "Reduzir animações" (Perfil › Configurações) e o ajuste do sistema viram `MediaQuery.disableAnimations`. Com ele: sem deslocamento, sem `Hero` da foto, páginas com um fade de ~150 ms, anel e números aparecem prontos, esqueleto parado, botões e cartões sem escala, interruptor, chips e campo trocam de cor na hora.
- Botões e cartões reduzem a 0,97 ao toque (`CartaoPressionavel`, `EscalaAoPressionar`).
- "Alto contraste" (ou o ajuste do sistema): fundo branco, sem tom azul claro, sem sombra suave, borda de 1,5 px em marinho em cartões, fichas, chips, campos, seletores e selos, fios mais escuros, trilha do anel visível, contorno na barra inferior. Não vale nas telas de login e escolha de vínculo (anteriores ao Perfil).
- Tamanho do texto: 0,9 / 1 / 1,15 vezes o tamanho do sistema.

## Como medir (modo profile, em aparelho)
Não meça em debug: ele é bem mais lento e dá falso alarme.

```powershell
flutter run --profile -d <id-do-aparelho> --flavor dev -t lib/main_alpha.dart
```

No DevTools (aba Performance, "Track widget builds" desligado), percorra o fluxo e olhe se há quadros acima de 16 ms (60 Hz) ou 8 ms (120 Hz):
1. login (CPF `00000000001`) → Início (anel e número contando);
2. trocar de aba na barra (bolha deslizando);
3. Turmas → uma turma → chips → Frequência, rolando até carregar a 2ª página;
4. Documentos (digitar na busca);
5. foto do topo → Perfil (`Hero`) → Configurações (interruptores, tamanho do texto).

Prefira um aparelho Android modesto: é ali que o brilho do esqueleto e as sombras desfocadas dos cartões aparecem primeiro. Repita com "Reduzir animações" ligado e com "Alto contraste" ligado.

## Pontos de atenção (candidatos se houver quadro caro)
- Sombra desfocada (blur 16) em muitos cartões ao mesmo tempo: se pesar, trocar por sombra menor ou só na borda.
- O brilho do esqueleto usa `ShaderMask` em tela cheia enquanto carrega.
- `BarraBolha` reconstrói os 3 itens a cada quadro da animação da bolha (barato, mas é o ponto mais quente da navegação).
- Turmas e Início usam `Column` (poucos itens). Com dezenas de turmas, trocar por `ListView.builder`.
