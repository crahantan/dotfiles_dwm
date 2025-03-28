#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define VOL_BUF_SIZE 6  // Máximo "[100]"

const char *alsa_master_vol() {
    static char vol_buf[VOL_BUF_SIZE];
    FILE *fp;

    // Verifica si el audio está muteado
    fp = popen("amixer get Master | grep -o '\\[off\\]'", "r");
    if (fp == NULL) {
        return "Error";
    }

    char mute_check[6]; // Buffer para leer "[off]"
    if (fgets(mute_check, sizeof(mute_check), fp) != NULL) {
        pclose(fp);
        return "MUTE"; // Si encuentra "[off]", retorna "MUTE"
    }
    pclose(fp);

    // Si no está muteado, obtener el volumen
    fp = popen("amixer get Master | grep -o '[0-9]*%' | head -1", "r");
    if (fp == NULL) {
        return "Error";
    }

    if (fgets(vol_buf, VOL_BUF_SIZE, fp) == NULL) {
        pclose(fp);
        return "Error";
    }
    pclose(fp);

    // Elimina el último carácter (el '%')
    size_t len = strlen(vol_buf);
    if (len > 0) {
        vol_buf[len - 1] = '\0';
    }

    return vol_buf; // Retorna solo el volumen sin "%"
}

