#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

int list_dir(char*, FILE*, char, char, uint64_t*);

int list_dir(char *path, FILE *fp, char depth, char max_depth, uint64_t *size) {
	DIR *d;
	struct dirent *dir;
	d = opendir(path);
	char new_path[255] = {0};
	memcpy(new_path, path, strlen(path));
	if(!d) {
		printf("%s is not a directory\n", path);
		return 1;
	}

	while((dir = readdir(d)) != NULL) {
		if(!strncmp(dir->d_name, ".", 2) || !strncmp(dir->d_name, "..", 3))
			continue;
		for(int i = 0; i < depth; i++) fputc(' ', fp);
		sprintf(new_path, "%s/%s", new_path, dir->d_name);

		if(dir->d_type == DT_DIR) {
			fprintf(fp, "d: %s\n", dir->d_name);
		}else {
			FILE *f = fopen(new_path, "rb");
			if(f) { 
				fseek(f, 0, SEEK_END);
				*size += ftell(f);
				fprintf(fp, "f: %s\tsize(bytes):(%d)\n", dir->d_name, ftell(f));
				fclose(f);
			}else
				fprintf(fp, "f: %s\n", dir->d_name);

		}

		if(dir->d_type == DT_DIR && depth != max_depth) {
			list_dir(new_path, fp, depth+1, max_depth, size);
		}
		new_path[strlen(path)] = 0;
	}
	closedir(d);
}

int main(int argc, char** argv)
{
	char root[255] = "/";
	char max_depth = 1;
	uint64_t size = 0;
	switch(argc) {
		case 3:
			max_depth = atoi(argv[2]);
		case 2:
			memcpy(root, argv[1], strlen(argv[1]));
			break;
	}
	
	FILE * fp = fopen("Files.txt", "w");

	list_dir(root, fp, 0, max_depth, &size);
	fprintf(fp, "SIZE: %llu\n", size);

	fclose(fp);

	return 0;
}
