# GuardianArea Mobile App 📱

GuardianArea es una aplicación móvil diseñada para mejorar la seguridad y el bienestar de personas vulnerables, como adultos mayores con Alzheimer y niños pequeños, a través de un sistema de monitoreo en tiempo real con geo-cercas inteligentes.

## 🌟 Características Principales

- 🗺️ Monitoreo en tiempo real con geo-cercas personalizables
- ⚡ Alertas instantáneas cuando la persona monitoreada sale de zonas seguras
- 📊 Historial de movimientos para análisis de patrones
- 👥 Soporte para múltiples cuidadores
- 📱 Interfaz intuitiva y fácil de usar

## 🛠️ Tecnologías Utilizadas

- Flutter
- Clean Architecture & DDD (Domain-Driven Design)
- Riverpod para gestión de estado
- Google Maps API para geolocalización
- Firebase para backend y notificaciones

## 📁 Estructura del Proyecto

```
lib/
├── config/               # Configuración general de la app
├── features/            # Funcionalidades principales
│   ├── activities/      # Gestión de actividades
│   ├── auth/           # Autenticación
│   ├── chat/           # Sistema de chat
│   ├── devices/        # Gestión de dispositivos
│   ├── geofences/      # Sistema de geo-cercas
│   ├── home/           # Pantalla principal
│   ├── navigation/     # Navegación
│   ├── profile/        # Perfil de usuario
│   ├── settings/       # Configuración
│   └── vital-signs/    # Monitoreo de signos vitales
└── shared/             # Componentes compartidos
```

## 🚀 Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/Salchichon057/guardian-area.git
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Configura las variables de entorno:
- Crea un archivo `.env` en la raíz del proyecto
- Añade las siguientes variables:
  ```
  MAP_API_TOKEN=tu_api_key (De preferencia de mapbox)
  API_URL=url_de_tu_api
  ```

4. Ejecuta la aplicación:
```bash
flutter run
```

## 🏗️ Arquitectura

La aplicación sigue los principios de Clean Architecture y Domain-Driven Design (DDD), organizando el código en tres capas principales:

- **Domain**: Contiene la lógica de negocio y las entidades
- **Infrastructure**: Implementa las interfaces definidas en el dominio
- **Presentation**: Maneja la UI y la interacción con el usuario

## 📱 Aplicación Móvil
 **Devices**: En esta pantalla se muestra la lista de dispositivos que se han registrado en la aplicación y se puede seleccionar uno para ver los datos que se han registrado en el dispositivo.

  <div style="text-align: center;">
  <img src="https://github.com/Desarrollo-de-Soluciones-IOT-Grupo-03/Report_Digital-Dart/blob/develop/images/chapter-06/sprint-03/mobile-devices-list.png?raw=true" alt="Guardian area mobile"  width="40%"/>
  </div>

 **Home**: En esta pantalla se muestra la ubicación actual del dispositivo móvil y si es que está dentro de la zona de seguridad que se ha configurado en la aplicación.
  <div style="text-align: center;">
  <img src="https://github.com/Desarrollo-de-Soluciones-IOT-Grupo-03/Report_Digital-Dart/blob/develop/images/chapter-06/sprint-03/mobile-home.png?raw=true" alt="Guardian area mobile"  width="40%"/>
  </div>

 **Activites**: En esta pantalla se muestra el historial de actividades que ha notificado la aplicación.
  <div style="text-align: center;">
  <img src="https://github.com/Desarrollo-de-Soluciones-IOT-Grupo-03/Report_Digital-Dart/blob/develop/images/chapter-06/sprint-03/mobile-activities.png?raw=true" alt="Guardian area mobile"  width="40%"/>
  </div>

 **Vital Signs**: En esta pantalla se muestra una gráfica donde é+l promedio de los datos que se registran en un tiempo determinado.
 <div style="text-align: center;">
 <img src="https://github.com/Desarrollo-de-Soluciones-IOT-Grupo-03/Report_Digital-Dart/blob/develop/images/chapter-06/sprint-03/mobile-vital-signs.png?raw=true" alt="Guardian area mobile"  width="40%"/>
  </div>

 **Geofences**: En esta pantalla se muestra la lista de zonas de seguridad que se han configurado en la aplicación.

  <div style="text-align: center;">
  <img src="https://github.com/Desarrollo-de-Soluciones-IOT-Grupo-03/Report_Digital-Dart/blob/develop/images/chapter-06/sprint-03/mobile-geofences.png?raw=true" alt="Guardian area mobile"  width="40%"/>
  </div>

 **Profile**: En esta pantalla se muestra la información del usuario que ha iniciado sesión en la aplicación.
  <div style="text-align: center;">
  <img src="https://github.com/Desarrollo-de-Soluciones-IOT-Grupo-03/Report_Digital-Dart/blob/develop/images/chapter-06/sprint-03/mobile-profile.png?raw=true" alt="Guardian area mobile"  width="40%"/>
  </div>

 También podemos apreciar que debajo de la barra de navegación se encuentra un indicador de bpm y SpO2 que son los datos que se están registrando en tiempo real.

## 🔗 Enlaces Relacionados

- [Repositorio Completo de las aplicaciones](https://github.com/orgs/Desarrollo-de-Soluciones-IOT-Grupo-03/repositories)
