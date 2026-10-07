# MicroProyecto 2 - Computación en la Nube 

Aplicación de comercio electrónico basada en microservicios, desplegada con infraestructura como código, balanceo de carga con HAProxy y orquestación con Kubernetes.

## Microservicios

| Servicio | Puerto | Imagen en Docker Hub |
|---|---|---|
| users-service | 3001 | xcamilaavila/users-service:v1 |
| products-service | 3002 | xcamilaavila/products-service:v1 |
| orders-service | 3003 | xcamilaavila/orders-service:v1 |

## Estructura del repositorio

| Carpeta | Contenido | Problema |
|---|---|---|
| `entrega/terraform` | Archivos de Terraform que crean las dos VMs en Azure (red, IPs públicas, grupos de seguridad) | 1 |
| `entrega/ansible` | Playbooks `site.yml` (Docker y contenedores) y `balanceo.yml` (HAProxy), con la plantilla `haproxy.cfg.j2` | 1 y 2 |
| `entrega/deploy.sh` y `entrega/destroy.sh` | Crean y destruyen todo el entorno con un solo comando | 1 |
| `entrega-k8s` | Manifiestos de Kubernetes (MySQL, tres servicios, Ingress) y scripts SQL | 3 |
| `Vagrantfile` | Define la máquina de control (Terraform y Ansible) | 1 |

## Problema 1: aprovisionamiento

Desde la máquina de control, Terraform crea `vm-haproxy` y `vm-microservices` en Azure (Chile Central). Ansible instala Docker, levanta los contenedores con `restart: always` e instala HAProxy.

```
./deploy.sh
./destroy.sh
```

`destroy.sh` borra las VMs y `deploy.sh` las recrea de forma idéntica, sin pasos manuales.

## Problema 2: balanceo con HAProxy

HAProxy escucha en el puerto 80 y enruta por prefijo de ruta:

- `/api/users` hacia el backend de usuarios (puertos 3001 y 3011)
- `/api/products` hacia el backend de productos (puertos 3002 y 3012)
- `/api/orders` hacia el backend de órdenes (puertos 3003 y 3013)

Cada backend usa balanceo `roundrobin` con comprobación de salud. El panel de estadísticas está en el puerto 8080 (`/stats`) y está protegido con usuario y contraseña. La contraseña se genera al desplegar y no se guarda en el repositorio.

## Problema 3: Kubernetes

Cada microservicio corre como un Deployment de 2 réplicas dentro del namespace `microapp`, expuesto con un Service `ClusterIP`. Un Ingress enruta `/api/users`, `/api/products` y `/api/orders` hacia el Service correcto. El servicio de órdenes se escaló a 4 réplicas sin interrupción.

Se probó en dos clústeres:

- **Minikube** (local), con `05-ingress.yaml` (clase `nginx`).
- **AKS** (Azure), con `05-ingress-aks.yaml` (clase `webapprouting.kubernetes.azure.com`).

Para desplegar, desde la carpeta `entrega-k8s`:

```
bash 00-preparar.sh
kubectl apply -f 01-mysql.yaml
kubectl apply -f 02-users.yaml -f 03-products.yaml -f 04-orders.yaml
kubectl apply -f 05-ingress.yaml
```

En AKS se usa `05-ingress-aks.yaml` en lugar de `05-ingress.yaml`.

## Notas

- Las contraseñas (MySQL, Flask, panel de HAProxy) se generan al desplegar y no están escritas en ningún archivo.
- Los archivos de estado de Terraform y la carpeta `secrets/` no se suben (ver `.gitignore`).
- Una respuesta `401` en `/api/orders` es lo esperado: el servicio exige identificación de usuario.
