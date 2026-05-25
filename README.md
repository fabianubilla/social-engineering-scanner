# ¿Se puede detectar phishing solo buscando palabras sospechosas?

Este proyecto intenta hacerlo.

Y falla.

Ese fracaso es justamente la lección.

---

# Detectar phishing con reglas simples

A muchos de nosotros, cuando empezamos a aprender ciberseguridad,
nos pasa algo parecido:

vemos conceptos como phishing, ingeniería social,
falsos positivos o bypass… pero entenderlos de verdad cuesta más
cuando solo los leemos en teoría.

Este proyecto nació justamente de eso.

La idea fue construir un detector extremadamente simple,
para entender desde dentro:

- cómo funcionan las reglas básicas
- por qué parecen buenas al inicio
- dónde empiezan a fallar
- y por qué eventualmente aparecieron sistemas más complejos

---

## Qué vamos a aprender

- Cómo funcionan los detectores basados en reglas
- Qué son los falsos positivos y los bypass
- Por qué el contexto es tan difícil de detectar
- Qué limitaciones tienen herramientas simples como `grep`
- Cómo evolucionaron los sistemas modernos:
  ML, LLMs y verificación de identidad

---

## La idea detrás del proyecto

Cuando uno empieza en seguridad suele pensar algo como:

> “Si un correo dice urgente, banco o transferencia,
> probablemente es phishing.”

Y honestamente, tiene sentido.

Este proyecto funciona exactamente así:
busca patrones sospechosos usando reglas simples.

El problema aparece cuando empiezas a probar mensajes reales.

Ahí empiezan a aparecer cosas incómodas:

- correos legítimos marcados como fraude
- ataques que evaden el detector fácilmente
- mensajes ambiguos
- problemas de contexto
- límites del análisis textual

Y ahí es donde realmente empieza el aprendizaje.

---

## ¿Por qué Bash?

Porque Bash obliga a trabajar con reglas simples y explícitas.

No hay IA ni modelos entrenados:
solo texto, patrones y lógica básica.

Eso ayuda mucho a entender cómo funcionaban muchos detectores tempranos y por qué eventualmente dejaron de ser suficientes.

---

# Cómo usarlo

```bash
git clone https://github.com/fabianubilla/social-engineering-scanner.git

cd social-engineering-scanner

chmod +x scanner.sh

./scanner.sh
```

![Inicio del scanner](screenshots/inicio.png)

Funciona en:

- Linux
- macOS
- WSL

Sin dependencias externas.

---

# Cómo funciona

El script analiza mensajes buscando patrones asociados a ingeniería social.

Por ejemplo:

- urgencia
- autoridad
- presión
- promesas
- solicitudes sensibles

Cuando encuentra ciertas palabras o expresiones:

- suma puntos
- activa alertas
- clasifica el riesgo

Es un enfoque extremadamente simple.

Y justamente por eso sirve para aprender.

---

# Los cuatro ejemplos guiados

El proyecto incluye cuatro escenarios pensados para mostrar problemas reales de detección.

El script muestra:

```text
mensaje → análisis → resultado → explicación
```

La idea es ir viendo paso a paso qué detecta,
qué no detecta y por qué ocurren ciertos errores.

---

## 1. Correo limpio — la línea base

Un newsletter legítimo.

El detector no encuentra nada.

Y esa es la respuesta correcta.

### Lo importante

Antes de detectar fraude,
primero necesitamos entender cómo se ve un mensaje normal.

---

## 2. CEO Fraud — cuando las reglas funcionan

Un atacante finge ser un gerente y pide una transferencia urgente.

El detector logra marcarlo porque el mensaje usa exactamente las palabras que las reglas esperan encontrar.

### Lo importante

Las reglas funcionan…
mientras el atacante no se adapte.

---

## 3. Falso positivo — cuando el detector se equivoca

Ahora aparece un correo legítimo de un banco.

El detector activa alertas.

Pero el mensaje no es fraude.

### Lo importante

Si un sistema se equivoca demasiado:

- las personas dejan de confiar
- empiezan a ignorar alertas
- el detector pierde utilidad real

---

## 4. Bypass — cuando el atacante gana

Ahora aparece una estafa escrita específicamente para evadir este detector.

La manipulación sigue ahí.

Pero las palabras cambiaron.

Resultado:

el detector no encuentra nada.

### Lo importante

Las reglas fijas son predecibles.

Y cualquier sistema predecible puede ser evadido.

---

# Patrones psicológicos detectados

## Urgencia

Reducir el tiempo de análisis.

Ejemplos:

- “última oportunidad”
- “acción inmediata”
- “tu cuenta será suspendida”

---

## Autoridad

Fingir legitimidad o poder.

Ejemplos:

- gerente
- banco
- soporte técnico
- RRHH

---

## Beneficio

Bajar defensas ofreciendo algo atractivo.

Ejemplos:

- premios
- bonos
- descuentos
- reembolsos

---

# El verdadero problema: contexto

Herramientas como `grep` no entienden significado.

Solo comparan texto.

Para el script:

```text
“Tu cuenta será suspendida”
```

y

```text
“Tu cuenta será suspendida si no pagas”
```

son simplemente cadenas de caracteres.

El sistema no comprende:

- intención
- legitimidad
- contexto
- relaciones humanas

Y ese es justamente uno de los motivos por los que detectar phishing real es tan difícil.

---

# Por qué las reglas no escalan bien

Durante años se intentó mejorar estos sistemas agregando:

- más palabras
- más excepciones
- más listas negras

El problema es que el detector se volvía cada vez más complejo…
sin realmente entender el mensaje.

---

# Qué apareció después

## Machine Learning

Aprender patrones completos en vez de buscar palabras exactas.

---

## LLMs

Entender contexto, intención y semántica.

---

## SPF / DKIM / DMARC

Verificar si el remitente realmente es quien dice ser.

---

# El siguiente paso

Este proyecto analiza únicamente el contenido del mensaje.

La siguiente capa importante son los headers del correo:

- dominios
- rutas de envío
- firmas digitales
- autenticación

Porque un correo puede parecer completamente legítimo…
y aun así revelar fraude en sus metadatos.

---

# Hacia sistemas más avanzados

Después de entender los límites de las reglas simples,
el siguiente paso natural es combinar múltiples capas de análisis:

- heurísticas
- Machine Learning
- contexto
- análisis híbrido

Ese es justamente el objetivo de:

## :contentReference[oaicite:0]{index=0}

Un proyecto donde el detector ya no depende solamente de palabras,
sino también de contexto y múltiples señales combinadas.

---

# Herramientas usadas

- Bash
- grep
- sed
- tr

Herramientas estándar de Unix/Linux.

Sin frameworks.
Sin dependencias.
Sin abstracciones complejas.

---

# Sobre este proyecto

Soy estudiante de ingeniería informática y ciberseguridad.

Desarrollé este proyecto usando Claude (Anthropic) como herramienta de apoyo durante el proceso de aprendizaje y construcción del detector.

Gran parte de la implementación fue iterativa:
probar ideas, leer el código, modificar cosas, romperlas, volver a entenderlas y descubrir progresivamente por qué estos sistemas funcionan… y por qué fallan.

Construir algo, aunque sea simple, me ayudó muchísimo más a entender estos conceptos que solo leer teoría,
y espero que a otros estudiantes también les pueda servir ese mismo proceso.
