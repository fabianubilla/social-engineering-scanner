#!/bin/bash
# =============================================================================
# social-engineering-scanner
# learning project by Fabian Ubilla
# License: MIT
#
# A script to learn why detecting digital manipulation is a hard problem.
# Searches for words associated with social engineering techniques and scores them.
# The point is not what it detects — it is understanding where and how it fails.
#
# Requires: Bash. No external dependencies.
# =============================================================================


# ── Colors ───────────────────────────────────────────────────────────────────
ROJO='\033[1;31m'
VERDE='\033[1;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
BLANCO='\033[1;37m'
GRIS='\033[0;37m'
NC='\033[0m'

# ── Global variables ─────────────────────────────────────────────────────────
PUNTOS=0
TEXTO=""
LECCION_FINAL=""
VEREDICTO_GUIADO=""   # Overrides the generic result block in guided examples


# ── UI functions ─────────────────────────────────────────────────────────────

cabecera() {
    clear
    echo -e "${CYAN}┌─────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}  ${BLANCO}social-engineering-scanner${NC}                         ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${GRIS}learning project${NC}                          ${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────┘${NC}"
    echo ""
}

pausar() {
    echo ""
    echo -e "${GRIS}[ presiona Enter para continuar ]${NC}"
    read -r
}

pausar_seccion() {
    # Pausa entre secciones — más visible que pausar()
    echo ""
    echo -e "${CYAN}·····················································${NC}"
    echo -e "${GRIS}  [ Enter para continuar ]${NC}"
    echo -e "${CYAN}·····················································${NC}"
    read -r
    clear
    echo -e "${CYAN}┌─────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}  ${BLANCO}social-engineering-scanner${NC}                         ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${GRIS}learning project by fivur${NC}                          ${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────┘${NC}"
    echo ""
}

separador() {
    echo -e "${AZUL}──────────────────────────────────────────────────────${NC}"
}

titulo_seccion() {
    echo ""
    echo -e "${MAGENTA}▌ $1${NC}"
    separador
}

linea_bloque() {
    local color="$1"
    local texto="$2"
    echo -e "${color}│${NC}  $texto"
}

linea_vacia() {
    local color="$1"
    echo -e "${color}│${NC}"
}


# ── Text normalization ───────────────────────────────────────────────────────
# Lowercase + replace accented characters.
# Prevents "URGENTE" or "urgente" (with accents) from bypassing detection.
normalizar() {
    echo "$1" \
        | tr '[:upper:]' '[:lower:]' \
        | sed 'y/áéíóúüñÁÉÍÓÚÜÑ/aeiouunAEIOUUN/'
}


# ── Search engine ────────────────────────────────────────────────────────────
# For each matched word: prints the alert and adds 1 point to the score.
buscar_señales() {
    local nombre="$1"
    local descripcion="$2"
    shift 2
    local palabras=("$@")
    local encontradas=""

    for palabra in "${palabras[@]}"; do
        if echo "$texto_min" | grep -q "$palabra"; then
            encontradas="${encontradas}${AMARILLO}'${palabra}'${NC} "
            (( PUNTOS++ ))
        fi
    done

    if [ -n "$encontradas" ]; then
        echo -e "${ROJO}  [ DETECTADO ]  $nombre${NC}"
        echo -e "      ${GRIS}$descripcion${NC}"
        echo -e "      Palabras encontradas: $encontradas"
    else
        echo -e "${VERDE}  [ sin señales ]  $nombre${NC}"
    fi
    echo ""
}


# ── Full analysis — split into stages with pauses ────────────────────────────
analizar() {
    PUNTOS=0
    texto_min=$(normalizar "$TEXTO")

    # ── ETAPA 1: mostrar el texto ──────────────────────────────────────────
    titulo_seccion "TEXTO ANALIZADO"
    echo -e "${GRIS}${TEXTO:0:600}${NC}"
    if [ ${#TEXTO} -gt 600 ]; then
        echo -e "${GRIS}[continúa — el motor analizó el mensaje completo]${NC}"
    fi

    pausar_seccion

    # ── ETAPA 2: señales detectadas ────────────────────────────────────────
    echo ""
    echo -ne "${AMARILLO}  Analizando "
    for i in {1..20}; do echo -ne "·"; sleep 0.03; done
    echo -e " listo${NC}"

    titulo_seccion "SEÑALES DETECTADAS"

    # ── SIGNAL 1: URGENCY
    # Creates pressure to act before verifying.
    buscar_señales \
        "URGENCIA — te meten prisa para que no pienses" \
        "Buscan que actúes antes de verificar si el mensaje es real." \
        "urgente" "expira" "inmediato" "hoy" "ahora" "24 horas" \
        "plazo" "suspension" "bloqueo" "ultimo aviso" "consecuencias" \
        "accion requerida" "limite" "rapido" "vence" "cierre"

    # ── SIGNAL 2: AUTHORITY
    # Impersonates a figure of power to trigger automatic obedience.
    buscar_señales \
        "AUTORIDAD — fingen ser alguien con poder" \
        "Explotan el respeto a jerarquías para que obedezcas sin preguntar." \
        "gerente" "director" "ceo" "legal" "policia" "sii" "hacienda" \
        "jefe" "banco" "soporte" "admin" "seguridad" "oficial" \
        "auditor" "abogado" "judicial" "rrhh" "superior"

    # ── SIGNAL 3: BENEFIT PROMISE
    # Offers something unexpected to lower the recipient's guard.
    buscar_señales \
        "PROMESA DE BENEFICIO — algo demasiado bueno para ser verdad" \
        "Usan recompensas para distraerte del riesgo real." \
        "ganaste" "bono" "premio" "regalo" "gratis" "oferta" \
        "reembolso" "beneficio" "seleccionado" "exclusivo" \
        "descuento" "recompensa" "saldo" "acreditado"

    pausar_seccion

    # ── ETAPA 3: resultado ─────────────────────────────────────────────────
    echo ""
    echo -e "${MAGENTA}▌ RESULTADO${NC}"
    separador

    if [ -n "$VEREDICTO_GUIADO" ]; then
        echo -e "$VEREDICTO_GUIADO"
    else
        if [ "$PUNTOS" -eq 0 ]; then
            echo -e "  Nivel:  ${VERDE}SIN SEÑALES${NC}  ($PUNTOS puntos)"
            echo ""
            echo -e "  ${GRIS}El detector no encontró coincidencias con sus reglas."
            echo -e "  Eso no significa que el mensaje sea legítimo."
            echo -e "  Solo significa que evitó las palabras de la lista.${NC}"
        elif [ "$PUNTOS" -le 3 ]; then
            echo -e "  Nivel:  ${AMARILLO}SEÑALES LEVES${NC}  ($PUNTOS puntos)"
            echo ""
            echo -e "  ${GRIS}El texto contiene palabras que aparecen en mensajes"
            echo -e "  fraudulentos — pero también en mensajes legítimos."
            echo -e "  El detector no puede distinguir el contexto.${NC}"
        else
            echo -e "  Nivel:  ${ROJO}SEÑALES FUERTES${NC}  ($PUNTOS puntos)"
            echo ""
            echo -e "  ${GRIS}El texto activó múltiples reglas."
            echo -e "  Eso aumenta la sospecha, pero no prueba que sea fraude."
            echo -e "  El detector reconoce patrones, no intenciones.${NC}"
        fi
    fi

    separador

    # ── ETAPA 4: lección (solo en ejemplos guiados) ────────────────────────
    if [ -n "$LECCION_FINAL" ]; then
        pausar_seccion
        echo -e "$LECCION_FINAL"
    fi
}


# =============================================================================
# GUIDED EXAMPLES
#
# Pedagogical order — tells a story:
#   1. Clean email       → detector works. Baseline.
#   2. CEO Fraud         → detector works. Real case.
#   3. False positive    → detector fails: alert on a legitimate message.
#   4. Bypass            → detector fails: misses a real scam.
# =============================================================================

ejemplo_limpio() {
    echo ""
    echo -e "${VERDE}┌─ Qué vas a ver ─────────────────────────────────────${NC}"
    linea_vacia $VERDE
    linea_bloque $VERDE "Un newsletter real. No hay intención de engañar."
    linea_vacia $VERDE
    linea_bloque $VERDE "${GRIS}Pregunta antes de ver el resultado:${NC}"
    linea_bloque $VERDE "${BLANCO}¿qué esperas que detecte el script?${NC}"
    linea_vacia $VERDE
    echo -e "${VERDE}└─────────────────────────────────────────────────────${NC}"
    pausar

    TEXTO="Hola,

Esta semana en la plataforma: nuevos cursos de Python, diseño UX
y fundamentos de redes. También publicamos el resumen del mes
con los contenidos más vistos por la comunidad.

Puedes gestionar tus preferencias o cancelar la suscripción
en cualquier momento desde tu perfil.

Equipo de contenidos"

    VEREDICTO_GUIADO="  Nivel:  ${VERDE}SIN SEÑALES${NC}

  ${GRIS}Este mensaje es un newsletter legítimo.
  El detector no encontró ninguna coincidencia.
  En este caso, esa es la respuesta correcta.${NC}"

    LECCION_FINAL="
${VERDE}┌─ Qué ocurrió ───────────────────────────────────────${NC}
${VERDE}│${NC}
${VERDE}│${NC}  El detector funcionó bien.
${VERDE}│${NC}
${VERDE}│${NC}  El texto no tiene palabras de urgencia,
${VERDE}│${NC}  autoridad ni promesas.
${VERDE}│${NC}  Es solo información — no hay nada que atrapar.
${VERDE}│${NC}
${VERDE}└─────────────────────────────────────────────────────${NC}

${GRIS}┌─ La pregunta que importa ───────────────────────────${NC}
${GRIS}│${NC}
${GRIS}│${NC}  ¿Puede un estafador escribir un mensaje
${GRIS}│${NC}  igual de limpio?
${GRIS}│${NC}
${GRIS}│${NC}  Sí.
${GRIS}│${NC}
${GRIS}│${NC}  Por eso 'sin señales' no significa 'seguro'.
${GRIS}│${NC}  Solo significa que no usó las palabras de la lista.
${GRIS}│${NC}
${GRIS}└─────────────────────────────────────────────────────${NC}"

    analizar
}

ejemplo_ceo_fraud() {
    echo ""
    echo -e "${ROJO}┌─ Qué vas a ver ─────────────────────────────────────${NC}"
    linea_vacia $ROJO
    linea_bloque $ROJO "Alguien finge ser el jefe y pide una transferencia."
    linea_vacia $ROJO
    linea_bloque $ROJO "Es uno de los fraudes más costosos para empresas."
    linea_bloque $ROJO "El FBI lo llama Business Email Compromise (BEC)."
    linea_vacia $ROJO
    linea_bloque $ROJO "${GRIS}Pregunta antes de ver el resultado:${NC}"
    linea_bloque $ROJO "${BLANCO}¿cuántas señales crees que va a detectar?${NC}"
    linea_vacia $ROJO
    echo -e "${ROJO}└─────────────────────────────────────────────────────${NC}"
    pausar

    TEXTO="Hola, soy Roberto Sánchez, gerente general.

Estoy en reunión con el directorio y no puedo hablar
por teléfono ahora.

Necesito que hagas una transferencia hoy antes del
cierre bancario a un proveedor nuevo.

El monto es de \$2.800.000 y está relacionado con los
bonos aprobados para el cierre del trimestre.

Te voy a enviar los datos de la cuenta por este medio.

No lo comentes todavía con el resto del equipo hasta
que esté cerrado.

Gracias"

    VEREDICTO_GUIADO="  Nivel:  ${ROJO}SEÑALES FUERTES${NC}

  ${GRIS}Este mensaje es un CEO Fraud real.
  El detector lo atrapó — el atacante usó palabras
  que están dentro de sus reglas.${NC}"

    LECCION_FINAL="
${ROJO}┌─ Qué ocurrió ───────────────────────────────────────${NC}
${ROJO}│${NC}
${ROJO}│${NC}  El detector funcionó aquí.
${ROJO}│${NC}
${ROJO}│${NC}  Autoridad:   'gerente', 'directorio'
${ROJO}│${NC}  Urgencia:    'hoy', 'ahora', 'cierre'
${ROJO}│${NC}  Beneficio:   'bonos'
${ROJO}│${NC}
${ROJO}└─────────────────────────────────────────────────────${NC}

${AMARILLO}┌─ La señal que el script no detecta ────────────────${NC}
${AMARILLO}│${NC}
${AMARILLO}│${NC}  'No lo comentes con el equipo todavía.'
${AMARILLO}│${NC}
${AMARILLO}│${NC}  Eso se llama aislamiento.
${AMARILLO}│${NC}  Es la señal más característica del CEO Fraud real:
${AMARILLO}│${NC}  impedir que la víctima pueda verificar con alguien
${AMARILLO}│${NC}  antes de actuar.
${AMARILLO}│${NC}
${AMARILLO}│${NC}  El detector lo atrapó por las palabras.
${AMARILLO}│${NC}  Pero el verdadero peligro estaba en el aislamiento.
${AMARILLO}│${NC}
${AMARILLO}└─────────────────────────────────────────────────────${NC}"

    analizar
}

ejemplo_falso_positivo() {
    echo ""
    echo -e "${AMARILLO}┌─ Qué vas a ver ─────────────────────────────────────${NC}"
    linea_vacia $AMARILLO
    linea_bloque $AMARILLO "Un correo ${BLANCO}completamente legítimo${NC} de un banco real."
    linea_vacia $AMARILLO
    linea_bloque $AMARILLO "No hay engaño. Es marketing bancario."
    linea_vacia $AMARILLO
    linea_bloque $AMARILLO "${GRIS}Pregunta antes de ver el resultado:${NC}"
    linea_bloque $AMARILLO "${BLANCO}¿lo va a marcar como peligroso?${NC}"
    linea_vacia $AMARILLO
    echo -e "${AMARILLO}└─────────────────────────────────────────────────────${NC}"
    pausar

    TEXTO="Estimado cliente,

Tu oferta de tasa preferencial vence hoy.

Si contratas el crédito antes del cierre de operaciones,
el banco aplica la tasa especial del 0,8% mensual.

Esta oferta es exclusiva para clientes seleccionados.

Para más información comunícate con tu ejecutivo
o visita nuestra sucursal más cercana.

Banco Estado — Área Comercial"

    VEREDICTO_GUIADO="  Nivel:  ${ROJO}SEÑALES FUERTES${NC}  — pero el mensaje es legítimo.

  ${AMARILLO}Esto es un falso positivo.${NC}

  ${GRIS}El detector encontró: 'vence', 'hoy', 'cierre',
  'banco', 'oferta', 'seleccionado'.

  Pero el correo es real.
  Es marketing de Banco Estado.${NC}"

    LECCION_FINAL="
${AMARILLO}┌─ Qué ocurrió ───────────────────────────────────────${NC}
${AMARILLO}│${NC}
${AMARILLO}│${NC}  El detector activó una alerta.
${AMARILLO}│${NC}  El mensaje no es una estafa.
${AMARILLO}│${NC}
${AMARILLO}│${NC}  Esto se llama falso positivo.
${AMARILLO}│${NC}
${AMARILLO}└─────────────────────────────────────────────────────${NC}

${GRIS}┌─ Por qué ocurrió ──────────────────────────────────${NC}
${GRIS}│${NC}
${GRIS}│${NC}  El detector no entiende contexto.
${GRIS}│${NC}
${GRIS}│${NC}  No sabe si 'banco' es el remitente real
${GRIS}│${NC}  o alguien intentando imitarlo.
${GRIS}│${NC}
${GRIS}│${NC}  No sabe si 'vence hoy' es una oferta comercial
${GRIS}│${NC}  o presión artificial de un estafador.
${GRIS}│${NC}
${GRIS}│${NC}  Solo cuenta palabras.
${GRIS}│${NC}
${GRIS}└─────────────────────────────────────────────────────${NC}

${CYAN}┌─ Por qué importa ──────────────────────────────────${NC}
${CYAN}│${NC}
${CYAN}│${NC}  Si el detector falla así con frecuencia,
${CYAN}│${NC}  las personas dejan de confiarle.
${CYAN}│${NC}
${CYAN}│${NC}  Y cuando dejan de confiarle, lo ignoran.
${CYAN}│${NC}  También cuando acierta.
${CYAN}│${NC}
${CYAN}└─────────────────────────────────────────────────────${NC}

${CYAN}┌─ Cómo se enfrenta ─────────────────────────────────${NC}
${CYAN}│${NC}
${CYAN}│${NC}  · [técnica] Clasificador con ML:
${CYAN}│${NC}
${CYAN}│${NC}    Entrenar un modelo con miles de ejemplos reales.
${CYAN}│${NC}    El modelo aprende que 'vence hoy' del banco
${CYAN}│${NC}    tiene una distribución estadística distinta
${CYAN}│${NC}    a 'vence hoy' en un mensaje anónimo.
${CYAN}│${NC}
${CYAN}│${NC}  · [técnica] Verificar el origen del mensaje:
${CYAN}│${NC}
${CYAN}│${NC}    SPF: confirma que el servidor tiene permiso
${CYAN}│${NC}    para enviar desde ese dominio.
${CYAN}│${NC}
${CYAN}│${NC}    DKIM: firma digital que verifica que el mensaje
${CYAN}│${NC}    no fue alterado en tránsito.
${CYAN}│${NC}
${CYAN}│${NC}    DMARC: coordina SPF y DKIM, y define qué
${CYAN}│${NC}    hacer si alguno falla.
${CYAN}│${NC}
${CYAN}└─────────────────────────────────────────────────────${NC}"

    analizar
}

ejemplo_bypass() {
    echo ""
    echo -e "${MAGENTA}┌─ Qué vas a ver ─────────────────────────────────────${NC}"
    linea_vacia $MAGENTA
    linea_bloque $MAGENTA "Un mensaje diseñado para ${BLANCO}evadir este detector${NC}."
    linea_vacia $MAGENTA
    linea_bloque $MAGENTA "Si lo lees, es claramente una estafa."
    linea_bloque $MAGENTA "El script no va a encontrar nada."
    linea_vacia $MAGENTA
    linea_bloque $MAGENTA "${GRIS}Pregunta antes de ver el resultado:${NC}"
    linea_bloque $MAGENTA "${BLANCO}¿por qué crees que lo va a evadir?${NC}"
    linea_vacia $MAGENTA
    echo -e "${MAGENTA}└─────────────────────────────────────────────────────${NC}"
    pausar

    TEXTO="Hola, soy Carolina, del área de finanzas.

Necesito que proceses el pago a este proveedor
antes de las 15:00.

El monto es de \$4.200.000. Te paso los datos
de la cuenta por este medio para que lo hagas
tú directamente.

Es para cerrar el trimestre. Habla conmigo después
si necesitas más detalles, pero primero haz
la transferencia.

Gracias"

    VEREDICTO_GUIADO="  Nivel:  ${VERDE}SIN SEÑALES${NC}  — pero el mensaje es una estafa.

  ${MAGENTA}El detector falló completamente.${NC}

  ${GRIS}El atacante evitó todas las palabras de la lista.
  El script no encontró nada.
  El mensaje es fraude.${NC}"

    LECCION_FINAL="
${MAGENTA}┌─ Qué ocurrió ───────────────────────────────────────${NC}
${MAGENTA}│${NC}
${MAGENTA}│${NC}  El detector no encontró señales.
${MAGENTA}│${NC}  Pero el mensaje es una estafa.
${MAGENTA}│${NC}
${MAGENTA}│${NC}  Esto se llama bypass.
${MAGENTA}│${NC}
${MAGENTA}└─────────────────────────────────────────────────────${NC}

${GRIS}┌─ Por qué ocurrió ──────────────────────────────────${NC}
${GRIS}│${NC}
${GRIS}│${NC}  El atacante conoce cómo funciona el detector.
${GRIS}│${NC}
${GRIS}│${NC}  No usó 'urgente'. No mencionó 'gerente'.
${GRIS}│${NC}  No ofreció premios.
${GRIS}│${NC}  Usó lenguaje cotidiano de oficina.
${GRIS}│${NC}
${GRIS}│${NC}  Las reglas fijas son predecibles.
${GRIS}│${NC}  Si el atacante sabe qué activa el detector,
${GRIS}│${NC}  puede diseñar el mensaje para evitarlo.
${GRIS}│${NC}
${GRIS}└─────────────────────────────────────────────────────${NC}

${CYAN}┌─ Cómo se enfrenta ─────────────────────────────────${NC}
${CYAN}│${NC}
${CYAN}│${NC}  · [técnica] Clasificador ML:
${CYAN}│${NC}
${CYAN}│${NC}    Un modelo entrenado con miles de ejemplos
${CYAN}│${NC}    aprende patrones estadísticos completos,
${CYAN}│${NC}    no palabras específicas. Un atacante que evita
${CYAN}│${NC}    'urgente' no evita el patrón del fraude real.
${CYAN}│${NC}
${CYAN}│${NC}  · [técnica] Modelos de lenguaje (LLMs):
${CYAN}│${NC}
${CYAN}│${NC}    Comprenden semántica real — leen el mensaje
${CYAN}│${NC}    como lo haría un humano. ChatGPT y Claude
${CYAN}│${NC}    son ejemplos de esta tecnología.
${CYAN}│${NC}
${CYAN}│${NC}  · [proceso] Separar detección de ejecución:
${CYAN}│${NC}
${CYAN}│${NC}    Para transferencias y acciones de alto riesgo,
${CYAN}│${NC}    ningún detector debería ser la única barrera.
${CYAN}│${NC}    Siempre verificar por un canal distinto.
${CYAN}│${NC}    Esto no es código — es una política.
${CYAN}│${NC}
${CYAN}└─────────────────────────────────────────────────────${NC}"

    analizar
}


# =============================================================================
# MAIN MENU
# =============================================================================

while true; do
    cabecera

    echo -e "${BLANCO}  Selecciona qué quieres hacer:${NC}"
    echo ""
    echo -e "  ${VERDE}1)${NC} Correo limpio          ${GRIS}— el detector no encuentra nada${NC}"
    echo -e "  ${ROJO}2)${NC} CEO Fraud              ${GRIS}— el detector lo atrapa${NC}"
    echo -e "  ${AMARILLO}3)${NC} Falso positivo         ${GRIS}— correo legítimo que activa alertas${NC}"
    echo -e "  ${MAGENTA}4)${NC} Bypass                 ${GRIS}— estafa que evade el detector${NC}"
    echo ""
    echo -e "  ${AZUL}5)${NC} Analizar texto propio  ${GRIS}— pega un mensaje manualmente${NC}"
    echo -e "  ${AZUL}6)${NC} Analizar archivo       ${GRIS}— carga un .txt${NC}"
    echo ""
    echo -e "  ${GRIS}7) Salir${NC}"
    echo ""

    read -p "  Opción (1-7): " opcion
    echo ""

    case $opcion in

        1)
            cabecera
            echo -e "  ${CYAN}── EJEMPLO 1 — Correo limpio ──${NC}"
            ejemplo_limpio
            pausar
            ;;

        2)
            cabecera
            echo -e "  ${CYAN}── EJEMPLO 2 — CEO Fraud ──${NC}"
            ejemplo_ceo_fraud
            pausar
            ;;

        3)
            cabecera
            echo -e "  ${CYAN}── EJEMPLO 3 — Falso positivo ──${NC}"
            ejemplo_falso_positivo
            pausar
            ;;

        4)
            cabecera
            echo -e "  ${CYAN}── EJEMPLO 4 — Bypass ──${NC}"
            ejemplo_bypass
            pausar
            ;;

        5)
            LECCION_FINAL=""
            VEREDICTO_GUIADO=""
            cabecera
            echo -e "  ${AZUL}── Texto manual ──${NC}"
            echo ""
            echo -e "${AMARILLO}  Pega el texto línea por línea.${NC}"
            echo -e "${GRIS}  Escribe 'fin' en una línea vacía para analizar.${NC}"
            echo -e "${GRIS}  Escribe 'cancelar' para volver al menú.${NC}"
            echo ""
            TEXTO=""
            while IFS= read -r linea; do
                [ "$linea" = "cancelar" ] && { TEXTO=""; break; }
                [ "$linea" = "fin" ] && break
                TEXTO="$TEXTO$linea"$'\n'
            done
            if [ -z "$TEXTO" ]; then
                echo -e "${GRIS}  Volviendo al menú.${NC}"
                sleep 1
            else
                analizar
                pausar
            fi
            ;;

        6)
            LECCION_FINAL=""
            VEREDICTO_GUIADO=""
            cabecera
            echo -e "  ${AZUL}── Cargar archivo ──${NC}"
            echo ""
            echo -e "${GRIS}  Escribe 'cancelar' para volver al menú.${NC}"
            echo ""
            read -rp "  Ruta del archivo .txt: " archivo
            if [ "$archivo" = "cancelar" ] || [ -z "$archivo" ]; then
                echo -e "${GRIS}  Volviendo al menú.${NC}"
                sleep 1
            elif [ -f "$archivo" ]; then
                TEXTO=$(cat "$archivo")
                if [ -z "$TEXTO" ]; then
                    echo -e "${ROJO}  El archivo está vacío.${NC}"
                    sleep 2
                else
                    analizar
                    pausar
                fi
            else
                echo -e "${ROJO}  Archivo no encontrado: $archivo${NC}"
                echo -e "${GRIS}  Verifica la ruta e intenta de nuevo.${NC}"
                sleep 2
            fi
            ;;

        7)
            echo -e "  ${GRIS}Saliendo.${NC}"
            echo ""
            exit 0
            ;;

        *)
            echo -e "  ${ROJO}Opción inválida.${NC}"
            sleep 1
            ;;
    esac

    # Reset for the next analysis run
    PUNTOS=0
    TEXTO=""
    LECCION_FINAL=""
    VEREDICTO_GUIADO=""

done
