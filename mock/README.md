# Mock da API do app

Servidor de mentira que segue o contrato de `openapi.yaml`, para desenvolver sem a API real do SIGUEMA. Todos os dados são fictícios.

## Subir

```bash
cd mock
docker compose up -d
```

Responde em `http://localhost:4010`. No emulador Android o mesmo servidor é `http://10.0.2.2:4010` (já é o padrão do flavor `dev`). Em aparelho físico, use o IP do PC com `--dart-define=API_BASE_URL=http://<ip>:4010`.

Para parar: `docker compose down`.

## CPFs fictícios (senha `senha123`)

| CPF | Resultado |
|---|---|
| `00000000001` | 1 vínculo (aluno): a escolha de vínculo é pulada |
| `00000000002` | 2 vínculos (graduação e pós) |
| `00000000003` | docente e servidor (2 vínculos) |
| `00000000004` | discente sem nenhum vínculo ativo: aparece o aviso para procurar a secretaria |
| qualquer outro, ou senha errada | 401 `CREDENCIAIS_INVALIDAS` |

`POST /auth/vinculo` aceita um token `Bearer tmp-...` (o que o login devolve) e responde 200. Sem esse cabeçalho, 401.

## Alterar

Edite os JSONs em `wiremock/mappings/`; o WireMock lê a pasta ao subir (`docker compose restart`). Mantenha `openapi.yaml` e os mapeamentos em sincronia.
