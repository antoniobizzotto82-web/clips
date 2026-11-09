# GBM SERVICIOS

Proyecto inicial Flutter para Android.

## Estado de esta entrega
Incluye la primera interfaz:
- selección de foto;
- selección de canción;
- selector de estilo musical;
- botón para iniciar;
- espacios de vista previa y galería.

**Todavía no genera videoclips.** Falta integrar un backend de IA para analizar la letra, crear escenas consistentes con la persona de la foto, montar el audio y exportar el MP4. Los servicios de generación pueden tener límites o costos; no se puede garantizar generación ilimitada gratuita.

## Compilar
1. Instalar Flutter en un entorno de desarrollo o usar CI.
2. Ejecutar `flutter pub get`.
3. Ejecutar `flutter build apk --release`.

## Codemagic
Subir el contenido del proyecto a la raíz de un repositorio GitHub. Codemagic permite compilar proyectos Android con un `codemagic.yaml` ubicado en la raíz del repositorio.
