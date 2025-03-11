#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

int main(void) {
	printf("Welcome to the C Shell!\n");
	int done = 0;
	char key[2048];

	char filename[] = "__temporary_cshell.c";
	FILE* fp = fopen(filename, "w+");

	fprintf(fp, "int main() {\n}");
	fseek(fp, -1, SEEK_CUR);
	
	while(!done) {
		printf("> ");

		memset(key, 0, 2048);
		fgets(key, 2048, stdin);

		switch(*key) {
			case 'q':
				printf("\n");
				done = 1;
				continue;
			case '~':
				fclose(fp);
				fp = fopen(filename, "w+");
				fprintf(fp, "int main(){\n");
				continue;
			case '`':
				{
					long off = ftell(fp);
					fseek(fp, 0, SEEK_SET);
					char mem[2048] = {0};
					fread(mem, 1, 2048, fp);
					printf("%s\n", mem);
					fseek(fp, off, SEEK_SET);
				}continue;
			case 10:
				{
					char cmd[100] = {0};
					sprintf(cmd, "gcc %s -o %s.exe;", filename, filename);
					system(cmd);
					memset(cmd, 0, 100);

					sprintf(cmd, "./%s.exe;", filename, filename);
					system(cmd);
				}continue;
			case '@':
				{
				fseek(fp, -2, SEEK_CUR);
				int i = 0;
				while(fgetc(fp) != '\n') {
					fseek(fp, -2, SEEK_CUR);
					i++;
				}
				}continue;
		}

		fwrite(key, 1, strlen(key), fp);
		fprintf(fp, "}");

		fflush(fp);

		fseek(fp, -1, SEEK_CUR);

		char cmd[100] = {0};
		sprintf(cmd, "gcc %s -o %s.exe;", filename, filename);
		system(cmd);

		printf("\n");
	}

	fclose(fp);

	char cmd[100];
	sprintf(cmd, "rm %s %s.exe", filename, filename);
	system(cmd);

	return 0;
}
