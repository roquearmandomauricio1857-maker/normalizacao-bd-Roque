# normalizacao-bd-Roque

# Normalização de Base de Dados — Sistema de Gestão de Funcionários

**Universidade Licungo — Faculdade de Ciências e Tecnologias**
Curso de Licenciatura em Informática — Trabalho II

## 1. Sobre o projeto

Este repositório contém a resolução completa do Trabalho II: análise e normalização (0FN → 4FN) de uma tabela não normalizada de funcionários de uma empresa moçambicana, culminando num esquema relacional bem desenhado, com Modelo Entidade-Relacionamento (MER), scripts SQL (DDL) e queries de exemplo com JOIN.

Ponto de partida: o ficheiro `Dados_Nao_Normalizados_Funcionarios.xlsx`, com 16 registos de funcionários, contendo grupos repetitivos (até 3 filhos e até 3 contactos telefónicos por funcionário) e dados não atómicos (endereço em texto livre), além de dependências transitivas entre cargo/função/localização geográfica.

## 2. Estrutura do repositório

```
.
├── documentos/
│   └── Analise_Normalizacao.docx   # Análise e justificação de cada forma normal (1FN a 4FN),
│                                    # com as tabelas resultantes de cada fase, cardinalidades
│                                    # e o diagrama MER embutido
├── diagramas/
│   └── mer_diagram.png             # Modelo Entidade-Relacionamento (MER), com cardinalidades
├── sql/
│   ├── 01_schema.sql               # DDL — criação de todas as 9 tabelas (PK e FK definidas)
│   ├── 02_dados.sql                # INSERT de todos os 16 funcionários já normalizados
│   └── 03_queries.sql              # 5 queries de exemplo com JOIN (reconstituição da info. original)
└── README.md                       # Este ficheiro
```

## 3. Resumo do processo de normalização

| Fase | Ação principal |
|---|---|
| **0FN → 1FN** | Eliminação dos grupos repetitivos "Filho 1-3" e "Celular 1-3" (extraídos para as tabelas `filho` e `telefone`); decomposição do campo "Endereço" em `tipo_via`, `nome_via`, `numero_porta`, `bairro`. |
| **1FN → 2FN** | Adoção de `id_funcionario` como chave substituta simples, eliminando qualquer dependência parcial que surgiria de uma chave composta. |
| **2FN → 3FN** | Extração das tabelas de referência `cargo`, `funcao`, `pais`, `provincia`, `cidade` e `posto_trabalho`, eliminando as dependências transitivas (ex.: Cód.Cargo → Cargo, Cidade → Província → País). |
| **3FN → 4FN** | Confirmação de que `filho` e `telefone`, já separadas, não misturam dependências multivaloradas independentes. |

## 4. Esquema final (9 tabelas)

`pais` · `provincia` · `cidade` · `cargo` · `funcao` · `posto_trabalho` · `funcionario` · `filho` · `telefone`

Todos os relacionamentos do modelo são **1:N** (nenhum N:M neste domínio) — ver detalhe e justificação na secção 8 do documento em `documentos/Analise_Normalizacao.docx`.

## 5. Como consultar os artefactos

1. **Análise completa (1FN a 4FN, cardinalidades, MER):** abrir `documentos/Analise_Normalizacao.docx`.
2. **Diagrama ER isolado:** abrir `diagramas/mer_diagram.png`.
3. **Testar o esquema SQL** (exemplo com SQLite, mas compatível com PostgreSQL/MySQL com pequenos ajustes de tipos):
   ```bash
   sqlite3 funcionarios.db < sql/01_schema.sql
   sqlite3 funcionarios.db < sql/02_dados.sql
   sqlite3 funcionarios.db < sql/03_queries.sql
   ```
   Os scripts foram validados: o schema e os dados carregam sem erros, e as 5 queries de `03_queries.sql` reconstituem corretamente a informação da tabela original (0FN) a partir do esquema normalizado.

## 6. Vídeo explicativo

Link do vídeo (YouTube, não listado) a adicionar aqui após gravação, conforme secção 5.2 do enunciado:
`[LINK DO VÍDEO AQUI]`

## 7. Autor

`[NOME DO ESTUDANTE]` — Curso de Licenciatura em Informática, Universidade Licungo.
