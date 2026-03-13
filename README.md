# Cloud Infrastructure Lab

Laboratorio para enseñar:

- Aprovisionamiento cloud
- Infraestructura como código
- Arquitectura Frontend / Backend / DB
- Autoscaling
- Pruebas de carga

Arquitectura:

Frontend → VM con IP pública  
Backend → Cloud Run  
DB → Cloud SQL

---

# Requisitos

Instalar:

- Terraform
- gcloud CLI
- Docker
- JMeter

---

# 1 Configurar proyecto

```bash
gcloud auth login
gcloud config set project PROJECT_ID


2 Construir imagen del backend
cd backend

gcloud builds submit --tag gcr.io/memos-tablet/backend


3 Aprovisionar infraestructura
cd terraform

terraform init

terraform apply


4 Obtener direcciones
Terraform mostrará:
frontend_ip
backend_url

5 Actualizar frontend
Editar:
frontend/index.html
reemplazar:
BACKEND_URL

por:
backend_url


6 Subir frontend a la VM
scp index.html USER@FRONTEND_IP:/var/www/html/


7 Probar aplicación
Abrir navegador:
http://FRONTEND_IP


8 Prueba de carga
Abrir JMeter
Configurar:
Thread Group:
Users: 300
Ramp-up: 20
Endpoint:
GET backend_url/products


9 Observar autoscaling
Ir a:
Cloud Run → Metrics
Ver cómo aumentan las instancias.


Orden ideal de explicación:

1️⃣ Mostrar repo  
2️⃣ Explicar arquitectura  
3️⃣ Ejecutar terraform  
4️⃣ Mostrar IP frontend  
5️⃣ Hacer prueba con JMeter  
6️⃣ Ver escalamiento en Cloud Run  

Eso te permite explicar:

- aprovisionamiento
- autoscaling
- elasticidad
- DevOps

en **30 minutos de clase**.
