# Como contribuir

## Fluxo
1. Pegue uma issue do quadro e mova para "Fazendo".
2. Atualize a `main` e crie a branch:
   ```bash
   git switch main && git pull && git switch -c feat/nome-curto
   ```
3. Faça commits pequenos no padrão Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.
4. Antes do PR: `dart format .`, `flutter analyze`, `flutter test`.
5. Abra o PR preenchendo o template. Use `Closes #n` para fechar a issue.
6. O **outro dev** revisa em até 24 h. Ninguém aprova o próprio PR.
7. Squash merge e apague a branch.

## Regras
- Nunca dê push direto na `main`.
- PR pequeno (~400 linhas). Mudança em `pubspec.yaml`, `core/` ou no contrato da API vai em PR separado.
- Atualize sua branch todo dia: `git pull --rebase origin main`.
- Sem CPF, senha, token ou dado real em código, logs, prints, issues ou prompts de IA.
- O PR só é aprovado com o CI verde.

## Definition of Done
Está no template de PR. Em resumo: formatado, sem erros no analyze, testes passando, testado em aparelho ou emulador, sem dados sensíveis, docs atualizados se mudou uma decisão.

## Worktrees (opcional)
Para trabalhar em duas branches ao mesmo tempo na sua máquina:
```bash
git worktree add ../siguema-fix fix/nome
```
Rode `flutter pub get` em cada worktree.
