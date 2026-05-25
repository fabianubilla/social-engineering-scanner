# Detectar phishing con reglas simples — y por qué siempre falla

Un script Bash interactivo para aprender los fundamentos de detección
de ingeniería social: cómo funcionan las reglas, cuándo fallan y qué
inventaron los ingenieros para resolverlo.

No necesitas saber programar para seguir los ejemplos.
El script hace el trabajo y explica lo que está pasando en cada paso.

---

## Qué vas a aprender

- Qué es un detector basado en palabras clave y cómo funciona internamente
- Qué es un **falso positivo** y por qué destruye la confianza en un sistema
- Qué es un **bypass** y cómo un atacante diseña mensajes para evadir reglas
- Por qué el **contexto** es el problema central que las reglas no pueden resolver
- Qué inventaron para ir más allá: ML, LLMs, SPF/DKIM/DMARC

---

## La idea detrás del proyecto

La respuesta más obvia a "¿cómo detecta un programa que un mensaje es fraude?"
es: **busca palabras sospechosas**.

Eso es exactamente lo que hace este script.

Y al probarlo con mensajes reales, empiezan a aparecer los problemas.
Esos problemas son la lección.

---

## Cómo usarlo

```bash
git clone https://github.com/fivur-cs/social-engineering-scanner.git
cd social-engineering-scanner
chmod +x scanner.sh
./scanner.sh
```

Requiere Bash. Sin dependencias externas. Funciona en Linux y macOS.

---

## Los cuatro ejemplos guiados

El script incluye cuatro casos en orden pedagógico.
Cada uno se muestra en etapas — primero el mensaje, luego el análisis,
luego el resultado, luego la explicación. Tú controlas el ritmo.

---

### 1. Correo limpio — la línea base

Un newsletter real. Sin urgencia, sin autoridad, sin promesas.

El detector no encuentra nada — y esa es la respuesta correcta.

**Lo que enseña:** antes de buscar fraude, necesitas saber cómo se ve
un mensaje cuando no hay manipulación.

---

### 2. CEO Fraud — cuando el detector funciona

Alguien finge ser el gerente y pide una transferencia urgente.
Es uno de los fraudes más costosos del mundo — el FBI lo llama
*Business Email Compromise* (BEC).

El detector lo atrapa porque el atacante usó exactamente las palabras
que el script sabe reconocer.

**Lo que enseña:** las reglas funcionan cuando el atacante no sabe que existen.
Pero hay una señal que el script no puede detectar: el **aislamiento**.
*"No lo comentes con el equipo todavía"* es la parte más peligrosa del mensaje,
y ninguna lista de palabras la captura.

---

### 3. Falso positivo — cuando el detector se equivoca

Un correo legítimo de un banco avisando que una oferta vence hoy.

El detector activa alertas. El mensaje no es fraude.

**Lo que enseña:** un detector que se equivoca demasiado se vuelve inútil.
Si las personas reciben falsas alarmas con frecuencia, dejan de confiar
en el sistema — y también ignoran las alertas reales.

---

### 4. Bypass — cuando el atacante gana

Una estafa escrita para evadir este detector.
Si la lees, es claramente manipulación.
El script no encuentra nada.

**Lo que enseña:** las reglas fijas son predecibles.
Un atacante que las conoce puede diseñar el mensaje para evitarlas.
Siempre existirán puntos ciegos.

---

## Los tres patrones que detecta

Los estafadores usan técnicas psicológicas documentadas para empujar
decisiones rápidas y reducir el análisis crítico.
El psicólogo **Robert Cialdini** las llamó *principios de persuasión*.
Este script detecta tres:

**Urgencia** — meten prisa para que no tengas tiempo de verificar.

**Autoridad** — fingen ser tu jefe, el banco, RRHH, soporte técnico.

**Promesa de beneficio** — ofrecen algo atractivo o inesperado para bajar la guardia.

---

## Por qué falla — la parte más importante

**Falsos positivos altos.**
"Urgente" aparece en correos de trabajo legítimos. "Banco" aparece cuando
alguien habla de su banco real. El script no sabe la diferencia — solo ve la palabra.

**Se evade fácil.**
Escribir "hazlo antes de las 15:00" en lugar de "urgente" evita
completamente la detección. Las reglas fijas siempre tienen puntos ciegos.

**No entiende contexto.**
`grep` no sabe si "suspensión de cuenta" es un fraude o un aviso legítimo.
Solo procesa cadenas de texto.

**El score no escala.**
Sumar 1 punto por palabra hace que un correo legítimo con mucha urgencia
tenga el mismo score que un phishing real.

---

## Qué inventaron para resolverlo

Cada limitación apunta a una solución real:

**Machine Learning** — en lugar de buscar palabras exactas, un modelo
entrenado con miles de ejemplos aprende patrones completos. El foco pasa
de *"¿aparece la palabra urgente?"* a *"¿el comportamiento del mensaje
se parece a fraude?"*

**Modelos de lenguaje (LLMs)** — entienden contexto y semántica real.
Pueden evaluar si una solicitud tiene sentido, no solo si contiene ciertas
palabras. ChatGPT y Claude son ejemplos.

**Verificación del remitente (SPF, DKIM, DMARC)** — protocolos que
confirman si el correo realmente viene del dominio que dice ser.
Resuelven el problema de identidad que el texto solo no puede resolver.

---

## El siguiente paso en esta serie

Este script analiza el **contenido** del mensaje — las palabras.

Hay otra capa igual de importante: los **headers del correo**.
Son los metadatos que revelan por qué servidores pasó el mensaje,
si las firmas digitales son válidas, si el dominio del remitente es real.

Un mensaje puede tener texto completamente normal y aun así mostrar
señales claras de fraude en sus headers. El ejemplo de Chilexpress falso
que aparece en el README del siguiente proyecto lo demuestra.

*[header-analyzer — próximamente]*

Y si quieres ver cómo evoluciona un detector cuando agregas ML y más capas:

[NotPhish →](https://github.com/fivur-cs/notphish)

---

## Herramientas usadas

Bash · `grep` · `sed` · `tr` — herramientas estándar de Unix.
Sin instalación, sin dependencias.

---

## Sobre este proyecto

Construido con asistencia de Claude (Anthropic) como parte de un proceso
de aprendizaje en ingeniería informática y ciberseguridad.

El objetivo no es mostrar código — es facilitar el entendimiento
de problemas reales que cualquier estudiante de seguridad va a encontrar.

---

*fivur — estudiante de ingeniería informática y ciberseguridad*
