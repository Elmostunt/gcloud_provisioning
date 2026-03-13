# 1️⃣ Qué vamos a configurar

En la base de datos (Cloud SQL PostgreSQL):

Crearemos:

```text
database: cloudlab
user: clouduser
password: cloudpass123
table: products
```

Arquitectura final:

```text
Frontend (VM)
     │
     ▼
Backend (Cloud Run - FastAPI)
     │
     ▼
Cloud SQL (PostgreSQL)
```

---

# 2️⃣ Crear la base de datos con Terraform

Agrega esto en **terraform/sql.tf**.

## Crear base de datos

```hcl
resource "google_sql_database" "database" {

  name     = "cloudlab"
  instance = google_sql_database_instance.postgres.name

}
```

---

## Crear usuario

```hcl
resource "google_sql_user" "users" {

  name     = "clouduser"
  instance = google_sql_database_instance.postgres.name
  password = "cloudpass123"

}
```

---

# 3️⃣ Permitir conexión desde Cloud Run

La forma moderna es usar **Cloud SQL connection name**.

Agrega esto al output:

```hcl
output "connection_name" {

 value = google_sql_database_instance.postgres.connection_name

}
```

Ejemplo de resultado:

```text
project:us-central1:cloudlab-db
```

---

# 4️⃣ Configurar conexión en Cloud Run

Editar **cloudrun.tf**

Agregar volumen Cloud SQL:

```hcl
template {

  spec {

    containers {

      image = "gcr.io/${var.project_id}/backend"

      env {

        name  = "DB_NAME"
        value = "cloudlab"

      }

      env {

        name  = "DB_USER"
        value = "clouduser"

      }

      env {

        name  = "DB_PASS"
        value = "cloudpass123"

      }

    }

  }

}
```

---

# 5️⃣ Conectar Cloud Run a Cloud SQL

Agregar esta sección:

```hcl
metadata {
  annotations = {
    "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.postgres.connection_name
  }
}
```

Esto monta automáticamente el socket:

```text
/cloudsql/PROJECT:REGION:INSTANCE
```

---

# 6️⃣ Backend FastAPI conectado a PostgreSQL

Modificar **backend/main.py**

```python
import os
import psycopg2
from fastapi import FastAPI

app = FastAPI()

DB_USER=os.getenv("DB_USER")
DB_PASS=os.getenv("DB_PASS")
DB_NAME=os.getenv("DB_NAME")

connection = psycopg2.connect(
    host="/cloudsql/YOUR_CONNECTION_NAME",
    user=DB_USER,
    password=DB_PASS,
    dbname=DB_NAME
)

@app.get("/products")

def products():

    cursor = connection.cursor()

    cursor.execute("SELECT id,name FROM products")

    rows = cursor.fetchall()

    return [{"id":r[0],"name":r[1]} for r in rows]
```

---

# 7️⃣ Crear tabla de ejemplo

Conéctate a Cloud SQL:

```bash
gcloud sql connect cloudlab-db --user=clouduser
```

Luego ejecutar:

```sql
CREATE TABLE products (

id SERIAL PRIMARY KEY,
name TEXT

);
```

Insertar datos:

```sql
INSERT INTO products(name) VALUES
('Laptop'),
('Mouse'),
('Keyboard'),
('Monitor');
```

---

# 8️⃣ Probar backend

Probar endpoint:

```text
https://cloud-run-url/products
```

Resultado esperado:

```json
[
 {"id":1,"name":"Laptop"},
 {"id":2,"name":"Mouse"},
 {"id":3,"name":"Keyboard"},
 {"id":4,"name":"Monitor"}
]
```

---

# 9️⃣ Flujo completo del laboratorio

En clase puedes mostrar esto:

```text
Terraform
   │
   ▼
Cloud SQL
   │
   ▼
crear DB
crear usuario
crear tabla
   │
   ▼
Backend Cloud Run
   │
   ▼
consulta SQL
   │
   ▼
Frontend
```

---

# 🔟 Qué puedes explicar pedagógicamente

| concepto                    | ejemplo                  |
| --------------------------- | ------------------------ |
| Infraestructura como código | Terraform                |
| Provisioning                | crear DB automáticamente |
| Backend API                 | FastAPI                  |
| Persistencia                | PostgreSQL               |
| Arquitectura cloud          | 3 capas                  |
| Escalabilidad               | Cloud Run autoscaling    |

---

# 💡 Tip para la demo (muy bueno en clase)

Antes de la prueba de carga ejecuta:

```sql
INSERT INTO products(name)
SELECT 'Producto ' || generate_series(1,1000);
```

Entonces cuando hagan:

```text
GET /products
```

verán muchos registros y **más carga en backend**.

---

# Si quieres, Guillermo, te puedo dejar el **laboratorio perfecto para profesor**:

Incluye:

* repo completo listo para GitHub
* Terraform funcionando
* backend conectado a DB
* frontend funcionando
* autoscaling visible
* test de carga listo
* **diagramas para PPT**
* **script para que los alumnos lo ejecuten**

Te juro que con ese laboratorio **tu clase queda nivel arquitecto cloud real**.
