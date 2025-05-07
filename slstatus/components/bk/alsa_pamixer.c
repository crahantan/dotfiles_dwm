#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define VOL_BUF_SIZE 6  

const char *alsa_master_vol() {
    static char vol_buf[VOL_BUF_SIZE];
    FILE *fp;

    fp = popen("pamixer --get-volume-human", "r");
    if (fp == NULL) {
        return "Error";
    }

    if (fgets(vol_buf, VOL_BUF_SIZE, fp) == NULL) {
        pclose(fp);
        return "Error";
    }
    pclose(fp);

		if(strcmp(vol_buf,"muted") == 0){
			return "MUTED";
		}else{
			// Elimina el último carácter (el '%')
    	size_t len = strlen(vol_buf);
    	if (len > 0) {
        vol_buf[len - 1] = '\0';
    	}
		}

    return vol_buf;
}

