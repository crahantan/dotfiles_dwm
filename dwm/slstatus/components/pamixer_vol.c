#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define VOL_BUF_SIZE 4
#define VOL_MUTED 5

static const char *paximer_vol(){
	static char *volume_str;
	FILE *fp;

	// volume status
	fp = popen("pamixer --get-volume-human","r");

	// if its null
	if(fp == NULL){
		return "Error";
	}

	// ift its muted	
	char muted[VOL_MUTED];
	if(fgets(muted,VOL_MUTED,fp) != NULL){
		pclose(fp);
		return "MUTED";
	}

	// set volume
	fgets(volume_str,VOL_BUF_SIZE,fp);

	// close stream
	pclose(fp);


	// return volume
	return volume_str;

}
