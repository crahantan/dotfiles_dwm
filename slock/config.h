#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/* user and group to drop privileges to */
static const char *user;
static const char *group;

static const char *colorname[NUMCOLS] = {
    [INIT] = "black",     /* after initialization */
    [INPUT] = "#005577",  /* during input */
    [FAILED] = "#CC3333", /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* Background image path, dynamically constructed */
static char background_image[256];

__attribute__((constructor)) static void init_user_and_paths(void) {
  struct passwd *pw = getpwuid(getuid());
  if (pw) {
    user = pw->pw_name;
    group = pw->pw_name;
  } else {
    user = group = "nobody";
  }

  // Construimos la ruta usando el usuario actual
  snprintf(background_image, sizeof(background_image),
           "/home/%s/.config/suckless/config/img/img.png", user);
}
