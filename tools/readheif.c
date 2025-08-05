#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "heif.h"
#include "camd.h"

void copyBuffer(heif_t heif, unsigned *screen, int width, int height, int off) {

	int vw = (width < heif.Totalwidth)? width:heif.Totalwidth;
	int vh = (height < heif.Totalheight)? height:heif.Totalheight;

	for(int y = 0; y < vh; y++) {
		int k = y*heif.stride+off;
		for(int x = 0; x < vw; x++, k+=3) {
			uint8_t R = heif.data[k], G = heif.data[k+1], B = heif.data[k+2];
			screen[x+y*(width+10)] = (R<<16)|(G<<8)|B;
		}
	}
}

struct timespec rqtp = {.tv_sec = 0, .tv_nsec = 100000};

int main(int argc, char** argv) {
	if(argc < 2) {
		printf("usage: %s <filename>\n",argv[0]);
		return 1;
	}

	int scl = 1;

	if(argc > 2) {
		scl = atoi(argv[2]);
	}

	struct drm_device dev;
	uint32_t fb_id, fb2_id;
	uint32_t *bo, *bo2;
	int ret;

	heif_t heif = readHeif(argv[1], scl);

	if(!heif.data) return 1;

	ret = drm_init(&dev, ret);
	if(ret) {
		return ret;
	}

	ret = drm_create_framebuffer(&dev, &fb_id, &bo);
	if(ret != 0) {
		drm_cleanup(&dev);
		return ret;
	}

	ret = drm_create_framebuffer(&dev, &fb2_id, &bo2);
	if(ret != 0) {
		drm_cleanup(&dev);
		return ret;
	}

	drm_draw_framebuffer(&dev, bo, 0x000000);
	drm_draw_framebuffer(&dev, bo2, 0x000000);

	ret = drmModeSetCrtc(dev.fd, dev.crtc->crtc_id, 0, 0, 0, NULL, 0, NULL);
	if(ret) {
		perror("Failed to clear fb");
		drm_cleanup(&dev);
		return -1;
	}

	// Draw to the display
	ret = drmModeSetCrtc(dev.fd, dev.crtc->crtc_id, fb_id, 0, 0, &dev.connector->connector_id, 1, dev.res);
	if(ret) {
		perror("Failed to set CRTC");
		drm_cleanup(&dev);
		return -1;
	}

//	printf("W, H: %d, %d\n", heif.Totalwidth, heif.Totalheight);
//	printf("Stride: %d\n", heif.stride);
	for(int i = 0; i < 500; i++) {
		uint32_t *mem = (i&1)? bo:bo2;
		//step(dev, mem);

		copyBuffer(heif, mem, dev.width, dev.height, 0/*i*3+i*2*heif.stride*/);
		ret = drmModeSetCrtc(dev.fd, dev.crtc->crtc_id, ((i&1)?fb_id:fb2_id), 0, 0, &dev.connector->connector_id, 1, dev.res);
		nanosleep(&rqtp, NULL);
	}

	/*int width = 1366;
	int height = 780;
	unsigned *screen = calloc(sizeof(unsigned), height*(width+10));

	FILE* fp = fopen("/dev/fb0", "w");

	fwrite(screen, 4, height*(width+10), fp);

	fclose(fp);
	free(screen);*/
	munmap(bo, dev.width*dev.height*4);
	munmap(bo2, dev.width*dev.height*4);
	drm_cleanup(&dev);
	heif_cleanup(heif);
	return 0;
}
