# Guía de Publicación en App Store - TicketProo

## ✅ Preparación Completada

- ✅ Íconos de app generados en todos los tamaños
- ✅ Bundle ID configurado: `com.example.ticketproo`
- ✅ Nombre de la app: **TicketProo**
- ✅ Versión: **1.0.0** (Build 1)
- ✅ Tema y colores configurados

---

## 📋 Paso a Paso para Publicar

### 1️⃣ Actualizar Bundle Identifier

Antes de continuar, **DEBES cambiar el Bundle ID** a uno único de tu cuenta de desarrollador:

```bash
# Abre el proyecto en Xcode
open ios/Runner.xcworkspace
```

En Xcode:
1. Selecciona el proyecto **Runner** en el navegador izquierdo
2. Selecciona el target **Runner**
3. En la pestaña **Signing & Capabilities**:
   - Marca "Automatically manage signing"
   - Selecciona tu **Team** (cuenta de desarrollador)
   - Cambia el **Bundle Identifier** de `com.example.ticketproo` a algo como:
     - `com.tunombre.ticketproo`
     - `com.tuempresa.ticketproo`

### 2️⃣ Configurar en App Store Connect

1. Ve a [App Store Connect](https://appstoreconnect.apple.com)
2. Haz clic en **Mis Apps** → **+** → **Nueva App**
3. Completa la información:
   - **Plataforma**: iOS
   - **Nombre**: TicketProo
   - **Idioma principal**: Español
   - **Bundle ID**: El que configuraste en el paso anterior
   - **SKU**: ticketproo-ios (o el que prefieras)
   - **Acceso de usuario**: Acceso completo

### 3️⃣ Preparar Información de la App

Necesitarás proporcionar:

**Capturas de pantalla** (requerido):
- iPhone 6.7" (iPhone 15 Pro Max): Mínimo 3 capturas
- iPhone 6.5" (opcional pero recomendado)

**Descripción de la app**:
```
TicketProo es tu herramienta de gestión de tickets profesional.

CARACTERÍSTICAS:
• Gestiona tus tickets de soporte técnico
• Filtra por estado y prioridad
• Crea nuevos tickets rápidamente
• Busca y organiza tu trabajo
• Recibe notificaciones de tickets pendientes
• Sincronización en tiempo real

Configura tu servidor TicketProo y mantén tu equipo conectado y productivo.
```

**Palabras clave**:
```
tickets, soporte, helpdesk, gestión, tareas, proyectos, productividad
```

**URL de soporte**: Tu sitio web o email de contacto
**URL de marketing**: (Opcional)

**Clasificación de contenido**:
- Selecciona "Ninguna" en las categorías de contenido sensible
- La app es apropiada para todas las edades (4+)

### 4️⃣ Configurar Privacidad

En App Store Connect → **Privacidad de la app**:

1. **¿Recopila datos?**: Sí
2. **Datos recopilados**:
   - Información de contacto → Email (para autenticación)
   - Identificadores → ID de usuario (para gestión de tickets)
3. **Uso de datos**: Funcionalidad de la app, autenticación
4. **Los datos están vinculados al usuario**: Sí

### 5️⃣ Crear el Build para Release

Ejecuta estos comandos en tu terminal:

```bash
# 1. Limpia el proyecto
cd '/Users/marlonfalcon/Documents/Apps Projects/ticketproo-ios'
flutter clean

# 2. Obtén las dependencias
flutter pub get

# 3. Genera el build de release
flutter build ios --release

# 4. (Alternativa) Genera el archivo .ipa directamente
flutter build ipa --release
```

### 6️⃣ Subir a App Store Connect

**Opción A: Usando Xcode (Recomendado)**

1. Abre el workspace en Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. En Xcode:
   - Selecciona **Product** → **Destination** → **Any iOS Device (arm64)**
   - Selecciona **Product** → **Archive**
   - Espera a que se complete el archivo
   - Se abrirá la ventana **Organizer**
   - Selecciona tu archivo y haz clic en **Distribute App**
   - Elige **App Store Connect**
   - Sigue el asistente y haz clic en **Upload**

**Opción B: Usando el archivo .ipa**

Si usaste `flutter build ipa`:

1. Instala Transporter de la App Store (si no lo tienes)
2. Abre **Transporter**
3. Arrastra el archivo `.ipa` desde:
   ```
   build/ios/ipa/ticketproo.ipa
   ```
4. Haz clic en **Entregar**

### 7️⃣ Procesar en App Store Connect

1. Ve a [App Store Connect](https://appstoreconnect.apple.com)
2. Espera 5-15 minutos a que se procese el build
3. En tu app → **TestFlight** → verás el build disponible
4. Agrega la información de prueba requerida
5. Una vez listo, ve a **App Store** → **Preparar para envío**
6. Selecciona el build que subiste
7. Completa toda la información faltante
8. Haz clic en **Enviar para revisión**

### 8️⃣ Revisión de Apple

- El proceso de revisión suele tomar 24-48 horas
- Apple puede solicitar más información o capturas
- Una vez aprobada, la app estará disponible en la App Store

---

## 🔧 Actualizaciones Futuras

Para subir una nueva versión:

1. Actualiza la versión en `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # Formato: versión+buildNumber
   ```

2. Repite los pasos 5-8

---

## 📸 Capturar Screenshots

Para tomar capturas de pantalla perfectas:

1. Ejecuta la app en el simulador:
   ```bash
   flutter run
   ```

2. Usa el simulador de iPhone 15 Pro Max

3. Navega a las pantallas principales:
   - Pantalla de login
   - Lista de tickets
   - Detalle de ticket
   - Crear ticket

4. Toma las capturas: **Cmd + S** en el simulador

5. Las capturas se guardan en el escritorio

---

## ⚠️ Notas Importantes

- **Bundle ID único**: Recuerda cambiarlo antes de subir
- **Certificados**: Asegúrate de que tu cuenta de desarrollador esté activa ($99/año)
- **Pruebas**: Prueba bien la app antes de enviarla a revisión
- **Privacidad**: La app hace llamadas a API, decláralo en la privacidad
- **Conectividad**: La app requiere conexión a internet para funcionar

---

## 🚀 Checklist Final

Antes de enviar a revisión:

- [ ] Bundle ID cambiado a uno único
- [ ] Firma configurada con tu cuenta de desarrollador
- [ ] Íconos verificados en Xcode
- [ ] Build compilado sin errores
- [ ] Build subido a App Store Connect
- [ ] Capturas de pantalla agregadas
- [ ] Descripción y palabras clave completadas
- [ ] URL de soporte proporcionada
- [ ] Información de privacidad completada
- [ ] Clasificación de contenido configurada
- [ ] App probada en dispositivo físico (recomendado)

---

¡Éxito con tu publicación! 🎉
