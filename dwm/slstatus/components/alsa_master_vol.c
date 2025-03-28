/* Created by William Rabbermann */
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "../util.h"

#define TMP_BUF_SIZE 22
#define VOL_BUF_SIZE 5

const char *
alsa_master_vol(const char *unused)
{
    char tmp_buf[TMP_BUF_SIZE];
    unsigned short i = 0;
    
    FILE *fp = popen("amixer get Master | grep -o '[0-9]*%' | head -n1", "r");
    if (!fp) return "Error";
    
    char vol_buf[VOL_BUF_SIZE];
    if (fgets(vol_buf, VOL_BUF_SIZE, fp) == NULL) {
        pclose(fp);
        return "Error";
    }
    pclose(fp);
    
    size_t len = strlen(vol_buf);
    if (len > 0) vol_buf[len - 1] = '\0'; // Elimina el último carácter
    
    return bprintf("%s", vol_buf);
}

