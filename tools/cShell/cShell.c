#include <stdio.h>
#include <string.h>
#include <pthread.h>

#define USED_FLAG (info->flag&1)
#define GOT_FLAG (info.flag&2)
#define NDONE_FLAG !(info.flag&4)

struct INFO{
	char key[2048], flag;
};

void* key_listener(void *in) {
	struct INFO *info = (struct INFO*)in;
	while(1) {
		memset(info->key, 0, 2048);
		fgets(info->key, 2048, stdin);
		if(*info->key == 0xa)continue;
		info->flag = 2;
		if(*info->key == 'q') break;
		while(!USED_FLAG);
		info->flag ^= 1;
	}
	return NULL;
}

int main(void) {
	printf("Welcome to the C Shell!\n");
	int done = 0;
	struct INFO info = {0};

	// Starting a key listener //
	pthread_t thread;
	pthread_create(&thread, NULL, key_listener, &info);
	// Key Listener //
	

	while(!done) {
		printf("> ");
		while(!GOT_FLAG);
		info.flag ^= 2;
		switch(*info.key) {
			case 'h':
				printf("Ok");
				break;
			case 'q':
				done = 1;
			default:
				break;
		}
		if(!memcmp(info.key, "ascii_val(", 10)) {
			printf("%c: %d(0x%x)",info.key[11], info.key[11], info.key[11]);
		}
		printf("\n");
		info.flag ^= 1;
	}

	pthread_join(thread, NULL);
	return 0;
}
