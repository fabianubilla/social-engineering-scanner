# Social Engineering Scanner

## ¿Se puede detectar phishing solo buscando palabras sospechosas?

Este proyecto intenta hacerlo. Y al probarlo, empiezan a aparecer los problemas.

Ahí está la parte interesante.

## De qué va esto

Cuando empecé a estudiar ciberseguridad, una de las primeras preguntas que me hice fue:

> ¿Cómo sabe un programa que un mensaje es una estafa?

La respuesta más obvia: buscar palabras sospechosas.

Así que construí eso. Un script Bash que busca palabras sospechosas y suma puntos.

Funciona para casos obvios. Pero cuando lo probé con mensajes reales, empezaron a aparecer cosas que no esperaba: correos legítimos marcados como fraude, estafas que el detector no encontraba y mensajes ambiguos donde el score no decía nada útil.

Esos problemas terminaron siendo la lección real del proyecto.

## Qué quise entender

Con este proyecto quise entender:

- cómo funciona un detector basado en palabras clave;
- qué es un falso positivo y por qué puede convertirse en un problema serio;
- cómo se puede evadir un detector con reglas fijas;
- por qué el contexto es difícil de capturar con reglas simples;
- por qué los sistemas reales necesitan más capas de análisis.

No intenté construir una herramienta lista para producción. La idea fue empezar por la aproximación más sencilla posible, ver hasta dónde podía llegar y entender por qué eventualmente deja de ser suficiente.

## Por qué Bash

Porque era una herramienta lo suficientemente simple para el nivel en el que estaba, quería entender la idea detrás del detector y no perderme todavía en tecnologías más complejas.

## Cómo usarlo

```bash
git clone https://github.com/fabianubilla/social-engineering-scanner.git
cd social-engineering-scanner
chmod +x scanner.sh
./scanner.sh
```

Requiere Bash. Sin dependencias externas. Funciona en Linux y macOS.

## Cómo funciona

El script analiza un mensaje buscando patrones asociados a ingeniería social.

Cuando encuentra ciertas palabras o expresiones, suma puntos y activa alertas.

Es un enfoque muy simple. Y justamente por eso me sirvió para entender qué estaba haciendo el detector, por qué llegaba a determinados resultados y en qué situaciones se equivocaba.

## Los cuatro ejemplos que probé

El script viene con cuatro casos en orden progresivo. Cada uno se muestra por etapas: primero el mensaje, luego el análisis, luego el resultado y finalmente la explicación. El ritmo se controla con Enter.

### 1. Correo limpio — la línea base

Un newsletter real. Sin urgencia, sin autoridad, sin promesas.

El detector no encuentra nada. Esa es la respuesta correcta.

**Por qué importa:** antes de buscar fraude, hay que entender cómo se ve un mensaje normal y comprobar que el detector no marque como amenaza todo lo que analiza.

### 2. CEO Fraud — cuando las reglas funcionan

Alguien finge ser el gerente y pide una transferencia urgente.

El detector lo atrapa porque el atacante usó exactamente las palabras que las reglas esperaban: gerente, directorio, hoy, ahora, cierre, bonos.

Pero la parte más importante del ejemplo no es solo que el detector acierte, sino entender por qué el mensaje es peligroso.

> “No lo comentes con el equipo todavía.”

Esa frase apunta al aislamiento: impedir que la víctima pueda verificar con alguien antes de actuar.

**Por qué importa:** el detector puede marcar señales visibles, pero el aprendizaje real está en entender la técnica detrás del mensaje. En este caso, no solo había urgencia y autoridad; también había aislamiento.

### 3. Falso positivo — cuando el detector se equivoca

Un correo legítimo de un banco avisando que una oferta vence hoy.

El detector activa alertas. El mensaje no es fraude.

**Por qué importa:** si un sistema se equivoca seguido, las personas dejan de confiar en él. Y cuando dejan de confiar, también pueden terminar ignorando las alertas reales.

### 4. Bypass — cuando el atacante gana

Una estafa escrita para evadir este detector. Si la lees, es evidente. El script no encuentra nada.

**Por qué importa:** las reglas fijas son predecibles. Un atacante que las conoce puede diseñar el mensaje para evitarlas. Siempre van a existir puntos ciegos.

## Los tres patrones que detecta

Los estafadores utilizan distintas técnicas psicológicas para empujar decisiones rápidas. El psicólogo Robert Cialdini documentó varios principios de persuasión, y este script intenta detectar tres patrones relacionados con ellos:

### Urgencia

Meter prisa para que no haya tiempo de verificar.

### Autoridad

Fingir ser el jefe, el banco, recursos humanos o soporte técnico.

### Promesa de beneficio

Ofrecer algo atractivo para que la persona baje la guardia.

## El problema de fondo: el contexto

`grep` no entiende significado. Solo compara texto.

Para una regla simple, estas dos frases pueden activar alertas parecidas:

> “Tu cuenta será suspendida. Ingresa aquí para verificar tus datos.”

> “Te recordamos que tu suscripción vence mañana.”

Pero no significan lo mismo. La primera presiona y pide una acción sensible. La segunda solo informa una fecha.

El sistema no comprende intención, legitimidad ni contexto. Y ese es uno de los motivos por los que detectar phishing real es difícil.

## Por qué las reglas no escalan

Agregar más palabras, más excepciones y más listas negras hace el detector más complejo, pero no necesariamente lo hace más inteligente.

Se pueden corregir casos concretos agregando una regla nueva, pero cada nueva regla también puede producir otros falsos positivos o dejar nuevas formas de evasión.

Ahí aparece la necesidad de combinar otros enfoques:

### Machine Learning

Aprender patrones desde muchos ejemplos, en vez de escribir todas las reglas a mano.

### Modelos de lenguaje

Analizar mejor el contexto, la intención y el significado completo del mensaje.

### Headers del correo + SPF / DKIM / DMARC

Revisar metadatos técnicos como los dominios, las rutas de envío, la autenticación y las firmas digitales.

Este proyecto no implementa nada de eso, pero me ayudó a entender por qué esas capas existen.

## Qué aprendí con este proyecto

Cuando empecé, la pregunta era si podía detectar phishing buscando palabras sospechosas.

Al probar el scanner, la pregunta terminó cambiando: ¿qué pasa cuando una regla parece funcionar en un ejemplo, pero falla apenas cambia la forma en que está escrito el mensaje?

Construirlo me permitió entender de forma práctica cómo aparecen los falsos positivos, por qué las reglas pueden ser fáciles de evadir y por qué agregar más palabras no soluciona necesariamente el problema. También me sirvió para entender un poco mejor el funcionamiento básico de Bash.

## El siguiente paso

A raíz de las limitaciones que aparecieron en este scanner, decidí probar una versión más completa del mismo problema.

El resultado fue [NotPhish](https://github.com/fabianubilla/notphish): un detector que mantiene la idea de las reglas, pero agrega más capas, como heurísticas, machine learning e interfaz web.

El scanner fue mi primera aproximación al problema. NotPhish nació de las preguntas que quedaron después de probarlo.

## Herramientas utilizadas

Bash · `grep` · `sed` · `tr`

Todas son herramientas estándar de Unix y el proyecto no necesita dependencias externas.

## Sobre este proyecto

Soy estudiante de Ingeniería Informática y Ciberseguridad. A la fecha de este proyecto, mis conocimientos de programación están en una etapa inicial: fundamentos, lógica y exploración práctica.

Lo construí usando Claude, de Anthropic, como herramienta de desarrollo. La IA tuvo un rol importante en la implementación y en algunas decisiones técnicas. Mi parte fue definir qué quería explorar, probar el programa, revisar sus resultados, encontrar situaciones donde fallaba, iterar sobre las ideas y entender cómo funcionaba cada parte.

Lo comparto como parte de mi proceso real de aprendizaje. Construir algo concreto, probarlo y encontrar sus límites me ayudó mucho más que limitarme a solo a la teoría.

## Licencia

MIT
