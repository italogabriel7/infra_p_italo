README — Atividade Avaliativa Prática 01 (Infra de TI)

Aluno: Ítalo Gabriel Oliveira Gomes
Turma: Engenharia de Software — 4º período
Disciplina: Infraestrutura de TI

Descrição do projeto

Repositório contendo artefatos para a Atividade Avaliativa Prática 01: uma API simples em Flask com Docker, manifests Kubernetes, scripts Terraform para criação de um bucket S3 (configurado para LocalStack por padrão), e coleção Postman para teste. Inclui também instruções e roteiro de evidências (prints) para entrega.

O objetivo é demonstrar habilidades em:

Containerização (Docker)

Orquestração (Minikube/Kind)

Provisionamento (Terraform + LocalStack ou AWS real)

Testes de API (Postman/Insomnia)

Documentação e evidências

Estrutura do repositório
infra-prova-pratica/
├─ api/
│  ├─ app.py
│  ├─ requirements.txt
│  └─ Dockerfile
├─ k8s/
│  ├─ deployment.yaml
│  └─ service.yaml
├─ terraform/
│  ├─ main.tf
│  ├─ variables.tf
│  └─ outputs.tf
├─ postman/
│  └─ infra-prova-api.postman_collection.json
├─ prints/
│  ├─ INSTRUCOES.md
│  ├─ 01-docker-build.png (placeholder)
│  └─ ... (placeholders para prints)
├─ README.md            <- este arquivo
└─ .gitignore
