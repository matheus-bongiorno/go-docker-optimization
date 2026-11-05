# Go Hello World — Docker Image Optimization

## 🎯 Objetivo

Este projeto tem como objetivo estudar técnicas de otimização de imagens Docker utilizando a linguagem Go.

O foco é reduzir o tamanho da imagem final através de:

- Multi-stage builds;
- Compilação estática;
- Remoção de informações de debug;
- Compressão de executáveis com UPX;
- Utilização da imagem base `scratch`.

## 📁 Estrutura do projeto

```text
go/
├── Dockerfile
├── main.go
└── README.md
```

## 🐳 Docker Multi-stage Build

O Dockerfile utiliza três etapas para construir e otimizar a imagem final.

### Stage 1 — Builder (Compilação)

**Imagem base:** `golang:1.26`

Contém o compilador Go e as ferramentas necessárias para transformar o código-fonte em um executável.

### Stage 2 — Compressor (Otimização)

**Imagem base:** `debian:bookworm-slim` + UPX

Recebe o executável gerado na etapa anterior e utiliza o UPX (Ultimate Packer for Executables) para comprimi-lo, reduzindo seu tamanho.

### Stage 3 — Produção (Imagem final)

**Imagem base:** `scratch`

Recebe somente o executável comprimido e executa a aplicação.

A imagem `scratch` é vazia, não contendo sistema operacional, shell ou ferramentas adicionais.

## 📊 Resultado da otimização

| Descrição | Tamanho |
|---|---:|
| Imagem original | 2,31 MB |
| Imagem otimizada | 1,13 MB |
| Redução | **51,1%** |

## 🚀 Executando o projeto

Executar o container:

```bash
docker build -t hello-go-upx .
```

Executar o container:

```bash
docker run --rm hello-go-upx
```

---

**Tecnologias utilizadas:** Go · Docker · Multi-stage Build · UPX · Scratch