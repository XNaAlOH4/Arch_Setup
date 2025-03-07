#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>

int main(int argc, char** argv) {

	DIR *d;
	struct dirent *dir;
	char root[3] = "./";
	d = opendir(root);
	int ndx = 0;

	if(argc < 2) {
		//List the directory
		while(dir = readdir(d)) {
			if(!strncmp(dir->d_name, ".", 2) || !strncmp(dir->d_name, "..", 3)) continue;
			printf("%d: %s\n", ndx++, dir->d_name);
		}
		return 0;
	}

	ndx = atoi(argv[1]);

	for(int i = 0; i <= ndx; i++) {
		dir = readdir(d);
		if(!strncmp(dir->d_name, ".", 2) || !strncmp(dir->d_name, "..", 3)) i--;
	}

	printf("\"%s\"\n", dir->d_name);

	return 0;
}
