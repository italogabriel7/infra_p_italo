# Atividade Avaliativa Prática 01 — Infra de TI

Repositório pronto para você **baixar e subir no GitHub**. Inclui:
- API Flask (Python) + Dockerfile
- Manifests Kubernetes (Deployment + Service)
- Terraform configurado para **LocalStack** por padrão (opção de AWS real)
- Coleção Postman para testes
- Passo a passo com comandos e checklist final

> Curso: Engenharia de Software • Disciplina: Infraestrutura de TI  
> Aluno: Ítalo Gabriel Oliveira Gomes • Turma: Engenharia de Software — 4º período

---

## 🧱 Estrutura

```
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
└─ README.md
```

---

## 1) API Flask + Docker

### Build e execução local
```bash
cd api
docker build -t infra-prova-api:latest .
docker run --rm -p 5000:5000 infra-prova-api:latest
# Em outro terminal, teste:
curl http://localhost:5000/
curl -X POST http://localhost:5000/sum -H "Content-Type: application/json" -d '{"a":3,"b":4.5}'
```

> Saída esperada do `GET /`:
```json
{"message":"API de teste - Infraestrutura","status":"ok"}
```

### Parar o container
Ctrl+C no terminal onde ele está rodando, ou:
```bash
docker ps
docker stop <CONTAINER_ID>
```

---

## 2) Kubernetes (Minikube **ou** Kind)

> **Minikube** (recomendado em ambientes locais)
```bash
# subir minikube
minikube start

# carregar imagem local no minikube
minikube image load infra-prova-api:latest

# aplicar manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# pegar URL e testar
minikube service infra-prova-api-svc --url
# Exemplo de teste se a URL for http://127.0.0.1:XXXXX
curl http://127.0.0.1:XXXXX/
```

> **Kind**
```bash
# criar cluster (se ainda não existir)
kind create cluster --name infra-cluster
# carregar imagem para o cluster
kind load docker-image infra-prova-api:latest --name infra-cluster

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# opcional: port-forward
kubectl port-forward deployment/infra-prova-api 5000:5000
curl http://localhost:5000/
```

---

## 3) Terraform (LocalStack por padrão)

### Pré-requisitos
- **LocalStack** rodando localmente (via pip, docker ou app)
- **AWS CLI** instalado

### Iniciar o LocalStack (ex. via docker)
```bash
# usando Docker
docker run -d --name localstack -p 4566:4566 -p 4571:4571 localstack/localstack
# ver logs
docker logs -f localstack
```

### Provisionar com Terraform
```bash
cd terraform
terraform init
terraform apply -auto-approve
terraform output
```

> O output mostrará o `bucket_name` criado (ex.: `infra-prova-ab12cd34`).

### Testar upload para S3 (LocalStack)
```bash
# supondo bucket_name=infra-prova-ab12cd34
aws --endpoint-url=http://localhost:4566 s3 cp ../api/app.py s3://infra-prova-ab12cd34/app.py
aws --endpoint-url=http://localhost:4566 s3 ls s3://infra-prova-ab12cd34/
```

### Usando AWS real (opcional)
- Edite `terraform/main.tf`: remova o bloco `endpoints { ... }` e as flags `skip_*`.
- Configure credenciais: `aws configure`.
- Execute `terraform apply` novamente.

---

## 4) Testes com Postman/Insomnia

Importe a coleção: `postman/infra-prova-api.postman_collection.json`  
Contém:
- **GET /** — saúde da API
- **POST /sum** — soma `a + b`

Demonstração de teste via `curl`:
```bash
curl http://localhost:5000/
curl -X POST http://localhost:5000/sum -H "Content-Type: application/json" -d '{"a":10,"b":2.5}'
```

---

## 5) Git — Entrega

```bash
# na pasta /infra-prova-pratica
git init
git add .
git commit -m "Atividade Avaliativa Prática 01 - Infra de TI"
git branch -M main
git remote add origin https://github.com/<seu-usuario>/<seu-repo>.git
git push -u origin main
```

Inclua no README do GitHub (ou aqui mesmo no repo):
- Link do repositório
- Prints dos comandos/saídas (docker build/run, kubectl get pods/svc, terraform output, curl)
- Print do Postman/Insomnia (requisições OK)

---

## 6) Troubleshooting (rápido)

- **Porta ocupada 5000** → troque a porta do `docker run -p 5000:5000` para `-p 5001:5000` e ajuste os testes.
- **Pod ImagePullBackOff (Kind/Minikube)** → garanta que a imagem `infra-prova-api:latest` foi carregada no cluster (`minikube image load` ou `kind load docker-image`).
- **Terraform falha com credenciais** → usando LocalStack, mantenha as flags `skip_*` e o bloco `endpoints`. Para AWS real, remova ambos e configure `aws configure`.
- **LocalStack não sobe** → confira se a porta 4566 está livre e os logs do container (`docker logs -f localstack`).

---

## ✅ Checklist final

- [ ] API Flask roda localmente via Docker e responde `GET /` e `POST /sum`
- [ ] Imagem Docker carregada no cluster (Minikube/Kind)
- [ ] Deployment/Service aplicados e endpoint testado (URL ou port-forward)
- [ ] Terraform `apply` concluído com `bucket_name` nos outputs
- [ ] Upload `app.py` para S3 (LocalStack ou AWS real) validado
- [ ] Testes Postman/Insomnia com evidências
- [ ] Repositório Git publicado com README + prints

Boa prática e bons estudos! ✨

---

## 📸 Evidências (prints)
Coloque suas capturas de tela na pasta **/prints**.  
Use o roteiro **prints/INSTRUCOES.md** para saber exatamente **o que fotografar** e **como nomear** os arquivos.
