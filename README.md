# TicketProo - Sistema de Gestión de Tickets

Aplicación móvil Flutter para gestionar tickets del sistema TicketProo.

## Características

- **Configuración de URL**: Configura la URL de tu servidor TicketProo (por defecto: https://ticketproo.com)
- **Autenticación**: Login seguro con usuario y contraseña
- **Lista de Tickets**: Visualiza todos tus tickets con filtros por estado y prioridad
- **Búsqueda**: Busca tickets por título o descripción
- **Detalle de Ticket**: Ve información completa de cada ticket
- **Crear Tickets**: Crea nuevos tickets con categoría, prioridad, empresa, etc.
- **Persistencia**: Mantiene la sesión activa

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── user.dart
│   ├── ticket.dart
│   ├── category.dart
│   └── company.dart
├── providers/                # Gestión de estado (Provider)
│   ├── auth_provider.dart
│   └── ticket_provider.dart
├── services/                 # Servicios de API
│   └── api_service.dart
└── screens/                  # Pantallas de la UI
    ├── splash_screen.dart
    ├── config_screen.dart
    ├── login_screen.dart
    ├── home_screen.dart
    ├── ticket_detail_screen.dart
    └── create_ticket_screen.dart
```

## Configuración

### Requisitos

- Flutter SDK 3.0 o superior
- Dart SDK 3.0 o superior

### Instalación

1. Clona el repositorio
2. Instala las dependencias:

```bash
flutter pub get
```

3. Ejecuta la aplicación:

```bash
flutter run
```

## Dependencias

- `provider`: Gestión de estado
- `http`: Llamadas a la API REST
- `shared_preferences`: Almacenamiento local
- `intl`: Formateo de fechas

## API

La aplicación se conecta a la API REST de TicketProo. Por defecto, usa `https://ticketproo.com` pero puedes configurar cualquier URL.

### Endpoints utilizados

- `POST /api/auth/login/` - Autenticación
- `GET /api/tickets/` - Lista de tickets
- `GET /api/tickets/{id}/` - Detalle de ticket
- `POST /api/tickets/` - Crear ticket
- `PATCH /api/tickets/{id}/` - Actualizar ticket
- `GET /api/categories/` - Lista de categorías
- `GET /api/companies/` - Lista de empresas

## Uso

1. **Primera vez**: La app te pedirá configurar la URL del servidor (propone https://ticketproo.com)
2. **Login**: Ingresa tu usuario y contraseña
3. **Ver tickets**: Navega por la lista de tickets, busca y filtra
4. **Crear ticket**: Usa el botón flotante "Nuevo Ticket" para crear uno
5. **Ver detalles**: Toca un ticket para ver su información completa

## Filtros disponibles

- Estado: Abierto, En Progreso, Resuelto, Cerrado
- Prioridad: Baja, Media, Alta, Urgente
- Búsqueda por texto en título y descripción
