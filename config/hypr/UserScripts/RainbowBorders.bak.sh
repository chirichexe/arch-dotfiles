#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Smooth border cycling effect using Wallust palette or full rainbow

# Possible values: "wallust_random", "rainbow", "gradient_flow"
EFFECT_TYPE="gradient_flow"

WALLUST_COLORS_SOURCE="$HOME/.config/hypr/wallust/wallust-hyprland.conf"

WALLUST_COLORS=()

# ---------- LOAD WALLUST COLORS ----------
if [[ "$EFFECT_TYPE" == "wallust_random" || "$EFFECT_TYPE" == "gradient_flow" ]]; then
    # wallust writes `$colorN = rgb(RRGGBB)`; normalize to rgba(RRGGBBff)
    mapfile -t WALLUST_COLORS < <(
        grep -E '^\$color[0-9]+' "$WALLUST_COLORS_SOURCE" |
            sed -nE 's/.*rgb\(([0-9A-Fa-f]{6})\).*/rgba(\1ff)/p'
    )

    if (( ${#WALLUST_COLORS[@]} == 0 )); then
        # If wallust colors can't be loaded, fall back to random_hex
        EFFECT_TYPE="rainbow"
    fi
fi

# ---------- RANDOM WALLUST COLORS ----------
function wallust_random() {
    echo "${WALLUST_COLORS[RANDOM % ${#WALLUST_COLORS[@]}]}"
}

# ---------- RAINBOW COLORS ----------
function random_hex() {
    echo "rgba($(openssl rand -hex 3)ff)"
}

# ---------- FLOW MODE ----------
BASE_COLOR="${WALLUST_COLORS[10]}"
GRAD1_COLOR="${WALLUST_COLORS[14]}"
GRAD2_COLOR="${WALLUST_COLORS[13]}"
GLOW_COLOR="${WALLUST_COLORS[15]}"

MAX_POS=10
GLOW_POS=0

function gradient_flow_color() {
    local pos=$1
    local d=$(( pos - GLOW_POS ))

    # wrap distance (-9..9)
    if (( d >  MAX_POS/2 )); then d=$((d - MAX_POS)); fi
    if (( d < -MAX_POS/2 )); then d=$((d + MAX_POS)); fi

    case "${d#-}" in
        0) echo "$GLOW_COLOR" ;;
        1) echo "$GRAD1_COLOR" ;;
        2) echo "$GRAD2_COLOR" ;;
        *) echo "$BASE_COLOR" ;;
    esac

    if (( pos == MAX_POS - 1 )); then
        GLOW_POS=$(( (GLOW_POS + 1) % MAX_POS ))
    fi
}

# ---------- Main function ---------- 

function get_color() {
    if [[ "$EFFECT_TYPE" == "wallust_random" && ${#WALLUST_COLORS[@]} -gt 0 ]]; then
        wallust_random
    elif [[ "$EFFECT_TYPE" == "gradient_flow" && ${#WALLUST_COLORS[@]} -ge 16 ]]; then
        gradient_flow_color "$1"
    else
        random_hex
    fi
}

# border effect for ACTIVE window (Lua config: set the gradient with hyprctl eval)
colors=()
for i in $(seq 0 9); do colors+=("\"$(get_color "$i")\""); done
hyprctl eval "hl.config({ general = { col = { active_border = { colors = { $(IFS=,; echo "${colors[*]}") }, angle = 270 } } } })" >/dev/null
