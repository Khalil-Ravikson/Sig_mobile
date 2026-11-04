# ADR 0001 — Stack e arquitetura do app

**Status:** proposta (aguardando validação com a CTIC)
**Data:** 2026-11

## Contexto
App Flutter para a UEMA (Android e iOS), piloto de ~3 mil usuários, 2 devs, hospedagem no servidor da UEMA, login do SIGUEMA (CPF + senha, escolha de vínculo) e integração com o SIGAA.

## Decisão proposta
- Estado: Riverpod. Navegação: go_router. HTTP: dio. Modelos: freezed + json_serializable.
- Tokens: flutter_secure_storage. Biometria: local_auth. Cache offline: drift, só onde necessário.
- Erros: Sentry self-hosted. Push: FCM com conteúdo genérico.
- Arquitetura: feature-first + MVVM + Repository; DTO + Mapper para o SIGAA/SIGUEMA.
- API: reaproveitar a API do SIGUEMA no MVP se for adequada; senão, BFF novo.

## Alternativas consideradas
Bloc, auto_route, http/retrofit, dart_mappable, Clean Architecture completa, Serverpod. Detalhes em `obsidian/SIGUEMA-Stack-Flutter-e-Design-Patterns.md`.

## Em aberto (bloqueiam o status "aceita")
1. A API do SIGUEMA existe e atende o app? 2. Linguagem do BFF. 3. Servidor: SO, Docker, exposição. 4. Firebase aceito (LGPD)? 5. Build do iOS. 6. Contas das lojas.

## Consequências
Padrão único para dois devs e testes simples. Custo: disciplina nas fronteiras de camada e geração de código no CI.
