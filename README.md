# Todo List App
TO-DO List, Version 1: App simple para generar una lista de tareas, Desarrollada utilizando los lenguajes de programación React 
(Frontend Web), Flutter (Frontend Movil), Python3 (Backend) y PostgreSQL como gestor de base de datos

Stack: FastAPI + PostgreSQL + React + Flutter

## Construir el contenedor con Docker (Backend + React)

```bash
docker compose up --build
```

## Levantar el contenedor con Docker (Backend + React + PostGreSQL)
```bash
docker compose up -d
```

## Detener el contenedor con Docker (Backend + React + PostGreSQL)
```bash
docker compose down
```

- API: http://localhost:8000
- Docs API: http://localhost:8000/docs
- React: http://localhost:3000

## Flutter (APK)

```bash
cd frontend-flutter
flutter pub get
flutter run          # emulador/dispositivo
flutter build apk    # genera APK en build/app/outputs/flutter-apk/
```

> El APK usa `http://10.0.2.2:8000` (emulador Android → localhost).
> Para dispositivo físico, cambia `baseUrl` en `lib/services/api_service.dart` por la IP de tu máquina.

## Endpoints API

| Método | Ruta        | Descripción      |
|--------|-------------|------------------|
| GET    | /tasks      | Listar tareas    |
| POST   | /tasks      | Crear tarea      |
| GET    | /tasks/{id} | Obtener tarea    |
| PUT    | /tasks/{id} | Actualizar tarea |
| DELETE | /tasks/{id} | Eliminar tarea   |
| GET    | /users      | Listar usuarios  |
| POST   | /users      | Crear usuario    |
