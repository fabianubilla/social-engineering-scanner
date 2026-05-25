# ¿Se puede detectar phishing solo buscando palabras sospechosas?

Este proyecto intenta hacerlo. Y al probarlo, empiezan a aparecer los problemas.

Ahí está la parte interesante.

---

## De qué va esto

Cuando empecé a estudiar ciberseguridad, una de las primeras preguntas que me hice fue:

> ¿cómo sabe un programa que un mensaje es una estafa?

La respuesta más obvia: buscar palabras sospechosas.

Así que construí eso. Un script Bash que busca palabras sospechosas y suma puntos.

Funciona para casos obvios. Pero cuando lo probé con mensajes reales, empezaron a aparecer cosas que no esperaba: correos legítimos marcados como fraude, estafas que el detector no encontraba, mensajes ambiguos donde el score no decía nada útil.

Esos problemas son la lección real del proyecto.

---

## Qué vas a aprender

- Cómo funciona un detector basado en palabras clave
- Qué es un falso positivo y por qué es un problema serio
- Cómo se evade un detector con reglas fijas (bypass)
- Por qué el contexto es difícil de capturar con reglas simples
- Qué inventaron después para resolver esto: ML, LLMs, SPF/DKIM/DMARC

---

## Por qué Bash

Porque Bash deja ver las reglas sin esconderlas detrás de frameworks.

No hay modelos entrenados, no hay análisis semántico.
Solo texto, patrones y lógica básica.

Eso hace más fácil entender desde cero cómo funciona una detección por reglas — y por qué eventualmente deja de ser suficiente.

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

## Cómo funciona

El script analiza un mensaje buscando patrones asociados a ingeniería social.

Cuando encuentra ciertas palabras o expresiones, suma puntos y activa alertas.

Es un enfoque muy simple. Y justamente por eso sirve para aprender — puedes ver exactamente qué está haciendo y por qué se equivoca.

---

## Los cuatro ejemplos guiados

El script viene con cuatro casos en orden pedagógico. Cada uno se muestra por etapas: primero el mensaje, luego el análisis, luego el resultado, luego la explicación. Tú controlas el ritmo con Enter.

### 1. Correo limpio — la línea base

Un newsletter real. Sin urgencia, sin autoridad, sin promesas.

El detector no encuentra nada. Esa es la respuesta correcta.

**Por qué importa:** antes de buscar fraude, hay que entender cómo se ve un mensaje normal.

### 2. CEO Fraud — cuando las reglas funcionan

Alguien finge ser el gerente y pide una transferencia urgente.

El detector lo atrapa — el atacante usó exactamente las palabras que las reglas esperan.

**Por qué importa:** las reglas funcionan cuando el atacante no sabe que existen. Pero hay una señal que el script no puede ver: el pedido de silencio al final del mensaje. *"No lo comentes con el equipo todavía"* es la parte más peligrosa, y ninguna lista de palabras la captura.

### 3. Falso positivo — cuando el detector se equivoca

Un correo legítimo de un banco avisando que una oferta vence hoy.

El detector activa alertas. El mensaje no es fraude.

**Por qué importa:** si un sistema se equivoca seguido, las personas dejan de confiar en él. Y cuando dejan de confiar, también ignoran las alertas reales.

### 4. Bypass — cuando el atacante gana

Una estafa escrita para evadir este detector. Si la lees, es evidente. El script no encuentra nada.

**Por qué importa:** las reglas fijas son predecibles. Un atacante que las conoce puede diseñar el mensaje para evitarlas. Siempre van a existir puntos ciegos.

---

## Los tres patrones que detecta

Los estafadores usan técnicas psicológicas para empujar decisiones rápidas. El psicólogo Robert Cialdini las documentó como principios de persuasión. Este script detecta tres:

**Urgencia** — meter prisa para que no haya tiempo de verificar.

**Autoridad** — fingir ser el jefe, el banco, RRHH, soporte técnico.

**Promesa de beneficio** — ofrecer algo atractivo para bajar la guardia.

---

## El problema de fondo: contexto

`grep` no entiende significado. Solo compara texto.

Para una regla simple, estas dos frases pueden activar alertas parecidas:

> "Tu cuenta será suspendida. Ingresa aquí para verificar tus datos."

> "Te recordamos que tu suscripción vence mañana."

Pero no significan lo mismo. La primera presiona y pide una acción sensible. La segunda solo informa una fecha.

El sistema no comprende intención, legitimidad ni contexto. Y ese es uno de los motivos por los que detectar phishing real es difícil.

---

## Por qué las reglas no escalan

Durante años se intentó mejorar este tipo de detección agregando más palabras, más excepciones, más listas negras.

El problema es que el detector se vuelve cada vez más complejo sin realmente entender el mensaje.

Ahí aparece la necesidad de otros enfoques.

---

## Qué vino después

**Machine Learning** — aprender patrones desde miles de ejemplos en vez de escribir reglas a mano.

**LLMs** — analizar contexto, intención y significado como lo haría un humano.

**SPF / DKIM / DMARC** — verificar si el remitente realmente es quien dice ser, mirando los metadatos del correo.

También existe otra capa: los headers del correo, donde aparecen dominios, rutas de envío y autenticación. Eso lo explora el siguiente proyecto de esta serie.

---

## Proyecto relacionado

[NotPhish →](https://github.com/fabianubilla/notphish) — misma pregunta, pero con reglas + machine learning y una interfaz para usuarios reales.

---

## Herramientas usadas

Bash · `grep` · `sed` · `tr` — estándar de Unix, sin dependencias.

---

## Sobre este proyecto

Soy estudiante de ingeniería informática y ciberseguridad.

Lo construí usando Claude (Anthropic) como herramienta de desarrollo. La IA tuvo un rol importante en la implementación y en las decisiones técnicas. Mi parte fue definir qué quería explorar, probar el programa, iterar y entender cómo funcionaba cada cosa.

Lo comparto porque construir algo concreto me ayudó más que solo leer teoría. Espero que también le sirva a otros.
