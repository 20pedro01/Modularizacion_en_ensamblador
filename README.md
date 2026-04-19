# Simulador de Ahorro para el Retiro (Ensamblador x86)

Este proyecto presenta un **Simulador de ahorro para el retiro** desarrollado íntegramente en Lenguaje Ensamblador x86 para la asignatura de **Lenguajes de Interfaz** en el **Instituto Tecnológico Superior de Valladolid (ITSVA)**.

El objetivo principal es demostrar la evolución arquitectónica de un sistema informático, pasando de una estructura **monolítica** (secuencial y dependiente) a una **modular** (basada en procedimientos y macros), optimizando la mantenibilidad, legibilidad y eficiencia del código.

---

## 🚀 Características principales

- **Diferenciación Arquitectónica**: Provee dos versiones del mismo sistema para comparar el impacto de la modularización.
- **Motor Financiero**: Implementa cálculos de interés compuesto utilizando **aritmética de punto fijo** (factor de escala 100) permitiendo manejar centavos con alta precisión sin la complejidad de la FPU.
- **Validación Multicanal**: Filtra entradas no numéricas y valores negativos en tiempo real.
- **Interfaz de consola**: Diseñada para una interacción fluida utilizando la librería **Irvine32**.

---

## 📂 Contenido del repositorio

| Archivo | Descripción |
| :--- | :--- |
| `monolitico.asm` | Versión inicial del simulador. Todo el flujo lógico reside en el procedimiento principal, lo que genera redundancia y dificultad de depuración. |
| `modulado.asm` | Versión optimizada. Implementa una jerarquía funcional clara mediante macros para la abstracción de interfaz y procedimientos para la lógica de negocio. |

---

## 🛠️ Requisitos de ejecución

Para ensamblar y ejecutar estos programas, necesitarás:

1. **MASM (Microsoft Macro Assembler)** o Visual Studio configurado para Ensamblador.
2. **Librería Irvine32**: Incluida generalmente en el entorno de estudio de [Kip Irvine] (http://kipirvine.com/asm/).
3. **Sistema operativo**: Windows (x86/x64).

### Instrucciones de compilación (línea de comandos)

Si utilizas el entorno estándar de Irvine:

```bash
# Para la versión Modular
ml -Zi -c -Fl modulado.asm
link /DEBUG /SUBSYSTEM:CONSOLE /LIBPATH:C:\Irvine modulado.obj irvine32.lib kernel32.lib user32.lib

# Para la versión Monolítica
ml -Zi -c -Fl monolitico.asm
link /DEBUG /SUBSYSTEM:CONSOLE /LIBPATH:C:\Irvine monolitico.obj irvine32.lib kernel32.lib user32.lib
```

---

## 📊 Funcionamiento del sistema

El simulador solicita al usuario los siguientes datos:
1. Meta de ahorro (para comparación).
2. Capital inicial.
3. Ahorro mensual constante.
4. Tasa de interés anual (%).
5. Plazo en años.

**Lógica de escalamiento:**
Para evitar el uso de punto flotante, el sistema convierte `$10.50` en el entero `1050`. Al final del ciclo de vida del programa, el motor de salida formatea el resultado separando los últimos dos dígitos como decimales.

---

## 👥 Integrantes (Equipo 6°C)

- **Cauich Pat Pedro Antonio**
- **Chan Xooc Brenda Argelia**
- **Corona Noh Gabriel Danneshe**
- **Pat Canche Karla Cristina**

**Profesor:** ISC. Luis Adrian Balam Espadas

---

## 📄 Licencia

Este proyecto fue realizado con fines académicos para la Unidad 3 de la materia Lenguajes de Interfaz.
