# PRD — SIGUEMA Mobile

> Atualize quando o escopo mudar. Fontes: `AGENTS.md`, `obsidian/SIGUEMA-Ata-Reuniao-2026-11-04.md`, código.

## Problema
O app mobile atual do sistema é antiquado: serve só para ver notas rápido. Várias funções exigem abrir o sistema no navegador, que é ruim no celular. O app novo deve tirar essa necessidade de usar o navegador.

## Público
- Discentes e docentes da UEMA (também servidores: o mock tem o vínculo `servidor`).
- Piloto: ~3 mil usuários (campus Paulo VI). Meta: ~29 mil.
- Plataformas: Android (Play Store) e iOS (App Store).

## Alpha v0.0.1 (2026-11-26)
Protótipo navegável do discente com dados fictícios, para mostrar o fluxo (notas em `docs/NOTAS-ALPHA-0.0.1.md`).

## Objetivo atual (Product Goal, ata de 2026-11-04)
Tela de login e vínculo para docentes e discentes, com dados mockados, enquanto a API não é liberada.

## Features
| Feature | Estado | Observação |
|---|---|---|
| Login por CPF e senha | feito | `lib/features/auth`; contra o mock |
| Escolha de vínculo (pulada se só houver 1) | feito | `POST /auth/vinculo` troca o token temporário pelo definitivo |
| Token seguro + interceptor Bearer | feito | `flutter_secure_storage` |
| Início e Turmas (alpha) | feito, **JSON fictício** | `features/inicio`, `features/turmas`; `assets/mock/`; sem API. Substitui a Home antiga |
| Entrar com a digital (retorno, falha, convite) | em andamento | branch `feat/login-biometria`; telas e view models existem, **ainda não ligados ao router** (no alpha, só o interruptor simulado em Configurações) |
| Turma virtual (Resumo, Frequência, Notas) | feito (alpha), **JSON fictício** | `features/turmas`; Materiais e Atividades só o chip "em breve" |
| Documentos com busca | feito (alpha), **JSON fictício** | PDF não é gerado; lista de documentos é proposta do design |
| Perfil, Meus dados, Configurações e Ajuda | feito (alpha), **JSON fictício** | preferências em memória; alto contraste e texto ajustável |
| Avisos, Horários | planejado | só pastas vazias (`.gitkeep`) |
| Push (FCM, texto genérico) | planejado | depende de decisão sobre Firebase/LGPD |
| Cache offline (drift) | planejado | "só onde precisar"; `drift` ainda não está no `pubspec.yaml` |
| Erros com Sentry self-hosted | planejado | idem |

## MVP (decisão do autor, 2026-11-25)
**Turmas, notas, matrícula e perfil.** Documentos como atestado: alguns saem em PDF, nem todos (ver "Em aberto").

## Como o portal atual é organizado (observado em prints do SIGAA, sem dados pessoais)
- **Home do discente:** notícias, mensagens, atualização de foto e perfil, turmas do semestre (com local, horário em código e chat), últimas atualizações, atividades e provas marcadas, comunidades virtuais, fórum do curso, dados institucionais (matrícula, curso, status), índices acadêmicos (CR, integralização) e atalhos de menu (Ensino, Pesquisa, Extensão, Biblioteca, Bolsas e outros).
- **Turma virtual** (ao clicar numa turma): funciona como uma "home da disciplina". Menu no topo com Turma, Alunos, Materiais, Atividades, Estatística e Ajuda. Barra lateral com notícias, enquete, atividades, avaliações e mensagens dos fóruns. A **frequência** (mapa data a data: presente ou nº de faltas) é a tela que o aluno mais consulta, junto com provas e mensagens do professor.
- **Relatório de notas:** uma tabela por semestre, com colunas Nota 1, 2 e 3, 2ª chamada, prova final, média, faltas e situação (matriculado, aprovado, reprovado, aprovado por nota).
- **Regra de frequência exibida no portal:** aprova por presença quem tiver pelo menos 75% das aulas ministradas.
- O portal avisa que a "transação também está disponível pelo celular", mas o app atual é antiquado e várias funções exigem o navegador.

## Home do aluno (decisão do autor, 2026-11-25)
Conteúdo: resumo do semestre (CR e integralização) no topo; provas e atividades marcadas; mensagens e avisos; atalhos (notas, comprovante, histórico); sino de notificações e foto de perfil. Fora da Home: aulas de hoje. Tom limpo e leve. Estilo visual Flat 2.0. Atualização (2026-11-25): navegação de 3 abas (Início, Turmas, Documentos); Perfil pela foto do topo; notificações só pelo sino; sem cartões de atalho nem cartão de mensagens na Home. Notas por turma ficam dentro de Turmas; histórico e relatório de notas em Documentos.

## Princípio de design (autor)
Reunir as características principais do portal e casá-las com um design acessível a todos, sem complicações.

## Fora de escopo
- Push e cache offline ficaram **fora do primeiro corte** (ata de 2026-11-04). A biometria entrou depois (confirmado pelo autor).
- Perfil servidor: atualização futura.
- Guardar senha no aparelho (proibido por LGPD/segurança).

## Restrições
- Hospedagem no servidor da UEMA (on-premises); exposição à internet ainda não definida.
- API real do SIGUEMA (Java) sem acesso liberado; o app usa um contrato proposto (`mock/openapi.yaml`) e um mock em Docker.
- LGPD: sem CPF, senha, token ou dado de aluno em log, issue, PR ou prompt.
- Equipe: 2 devs, 1 infra/suporte, 1 chefe de departamento, 1 designer. Sem PO nem Scrum Master formais.

## Prioridades (decisão do autor)
1. Design no Figma (hoje é o gargalo: faltam a ideia e o design do app).
2. Depois, usuários e funcionalidades.
- Servidores entram numa atualização futura; o MVP é para discentes e docentes.
- Teto de usuários: ~29 mil (total de alunos).
- Sem previsão de publicação nas lojas.

## Métricas de sucesso
Nenhuma definida por enquanto (decisão do autor). Referência: teto de ~29 mil usuários.

## Em aberto
1. Quais são as 3–5 funcionalidades do MVP (T-33)? Falta decidir, depois do Figma.
2. Quais funções do navegador do SIGAA os alunos mais precisam no celular? (levantar com alunos)
3. Biometria: confirmada como parte do app (a ata de 04/11 está desatualizada nesse ponto).
