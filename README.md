# Social Engineering Scanner

Proyecto educativo de ciberseguridad enfocado en detectar posibles intentos de ingeniería social mediante análisis basado en reglas.

## Resumen

Social Engineering Scanner es una herramienta simple escrita en Bash que analiza mensajes buscando señales asociadas a ingeniería social.

El proyecto utiliza reglas fijas y palabras clave para detectar patrones como urgencia, autoridad y promesas de beneficio.

No es una herramienta lista para producción. Es un proyecto educativo creado para entender cómo funciona un detector basado en reglas, por qué puede servir en casos simples y por qué empieza a fallar cuando cambia el contexto.

## Objetivo

Con este proyecto quise entender:

- cómo funciona un detector basado en palabras clave
- cómo se puede asignar un puntaje de riesgo a un mensaje
- qué es un falso positivo
- por qué las reglas simples pueden ser evadidas
- por qué el contexto es difícil de capturar con reglas fijas
- por qué los sistemas reales necesitan más capas de análisis

## Funciones principales

- análisis de mensajes desde la terminal
- detección de palabras y expresiones sospechosas
- puntaje de riesgo basado en reglas
- alertas por patrones de ingeniería social
- ejemplos guiados por etapas
- explicación del resultado después de cada análisis
- ejecución sin dependencias externas

## Cómo funciona

El script analiza un mensaje buscando palabras, frases y patrones asociados a posibles intentos de ingeniería social.

Cuando encuentra una coincidencia, suma puntos al score del mensaje y muestra una explicación de las señales detectadas.

El enfoque es intencionalmente simple:

```text
buscar patrón → sumar puntos → mostrar alerta
```

Esto permite entender fácilmente por qué el sistema llega a un resultado determinado.

La misma simpleza también muestra sus límites. El script no entiende intención, legitimidad ni contexto. Solo compara texto contra reglas previamente definidas.

## Patrones que detecta

El scanner busca señales relacionadas con tres patrones frecuentes en mensajes de ingeniería social.

### Urgencia

Busca expresiones que intentan presionar a la persona para actuar rápido.

Ejemplos:

- hoy
- ahora
- urgente
- vence
- último aviso

### Autoridad

Busca señales donde el mensaje intenta apoyarse en una figura de poder o confianza.

Ejemplos:

- gerente
- banco
- soporte
- recursos humanos
- dirección

### Promesa de beneficio

Busca mensajes que intentan llamar la atención ofreciendo algo atractivo.

Ejemplos:

- premio
- bono
- beneficio
- regalo
- promoción

Estos patrones no prueban por sí solos que un mensaje sea fraude. Solo indican señales que pueden aumentar el riesgo.

## Casos incluidos

El proyecto incluye cuatro ejemplos en orden progresivo.

Cada caso se muestra por etapas: primero el mensaje, luego el análisis, después el resultado y finalmente una explicación. El ritmo se controla con Enter.

### 1. Correo limpio

Un mensaje legítimo usado como línea base.

El objetivo es comprobar que el scanner no marque como amenaza todo lo que analiza.

### 2. CEO Fraud

Un mensaje donde alguien finge ser una figura de autoridad y pide actuar con urgencia.

Este caso muestra cuándo las reglas pueden funcionar bien, especialmente cuando el atacante usa palabras que el sistema espera encontrar.

### 3. Falso positivo

Un mensaje legítimo que activa señales sospechosas.

Este caso muestra un problema importante: si un detector se equivoca demasiado, las personas pueden dejar de confiar en sus alertas.

### 4. Bypass

Un mensaje fraudulento escrito para evitar las reglas del scanner.

Este caso muestra que las reglas fijas son predecibles. Si alguien conoce cómo funciona el detector, puede intentar escribir el mensaje de una forma que no active alertas.

## Instalación y uso

Clonar el repositorio:

```bash
git clone https://github.com/fabianubilla/social-engineering-scanner.git
cd social-engineering-scanner
```

Dar permisos de ejecución:

```bash
chmod +x scanner.sh
```

Ejecutar el scanner:

```bash
./scanner.sh
```

Requiere Bash. Funciona en Linux y macOS.

No necesita dependencias externas.

## Estructura del proyecto

```text
social-engineering-scanner/
├── scanner.sh
└── README.md
```

## Archivo principal

### `scanner.sh`

Script principal del proyecto.

Contiene la lógica de detección, los mensajes de ejemplo, el sistema de puntaje y las explicaciones que se muestran durante la ejecución.

## Limitaciones

- No entiende el contexto del mensaje
- Puede generar falsos positivos
- Puede dejar pasar mensajes fraudulentos que no usen las palabras esperadas
- No analiza enlaces de forma profunda
- No revisa headers de correo
- No analiza archivos adjuntos
- No valida la identidad real del remitente
- Las reglas pueden ser evadidas si alguien conoce cómo funcionan
- No utiliza machine learning ni modelos de lenguaje

## Qué aprendí

Este proyecto me ayudó a entender que detectar phishing o ingeniería social solo con palabras clave puede funcionar en casos obvios, pero falla cuando el mensaje cambia de forma.

También me permitió ver cómo aparecen los falsos positivos. Un mensaje legítimo puede usar palabras como “urgente” o “vence hoy” sin ser una estafa.

La principal lección fue que agregar más palabras a una lista no hace que el sistema entienda mejor el mensaje. Puede mejorar algunos casos concretos, pero también puede crear nuevos errores.

Construir este scanner me permitió comprender mejor los límites de las reglas fijas y por qué los sistemas reales suelen combinar varias capas de análisis.

## Próximo paso

Las limitaciones de este proyecto llevaron al desarrollo de NotPhish.

NotPhish mantiene la idea de analizar señales sospechosas, pero agrega una interfaz web, más reglas, un modelo de machine learning y un sistema híbrido para combinar distintos resultados.

Social Engineering Scanner fue mi primera aproximación al problema. NotPhish nació a partir de las preguntas que quedaron después de probarlo.

## Tecnologías

Bash · grep · sed · tr

## Desarrollo asistido por IA

Este proyecto fue desarrollado con apoyo importante de Claude, de Anthropic, especialmente en la escritura del código, la estructura del script y algunas decisiones de implementación.

No presento este repositorio como una herramienta construida íntegramente de forma manual por mí. Lo comparto como un proyecto educativo y como parte de mi proceso real de aprendizaje en ciberseguridad e informática.

Mi rol fue definir qué quería explorar, probar el programa, revisar sus resultados, detectar casos donde fallaba, ajustar ideas, evaluar sus limitaciones y entender progresivamente cómo funcionaba la lógica del scanner.

Trabajar con este proyecto me ayudó a aprender más que solo leer teoría, porque pude probar un detector concreto, ver cuándo acertaba, cuándo fallaba y por qué las reglas simples no bastan para resolver el problema completo.

## Licencia

MIT