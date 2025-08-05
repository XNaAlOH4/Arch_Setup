#ifndef CAMD_H
#define CAMD_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>

#include <sys/mman.h>
#include <sys/ioctl.h>

#include <xf86drm.h>
#include <xf86drmMode.h>

#include <gbm.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>

struct drm_device {
	int fd, dGPU;
	int width, height;
	struct gbm_device* gbm_dev;
	drmModeModeInfo *res;
	drmModeRes *resources;
	drmModeConnector *connector;
	drmModeEncoder *encoder;
	drmModeCrtc *crtc;
};

typedef struct DRM_MASTER_STRUCT {
	struct drm_device dev;
	uint32_t *fbs;
	uint32_t **bo;
} drmMaster;

enum drm_init_err {
	DRM_OPEN, DRM_RESO, DRM_CONN, DRM_ENCO, DRM_CRTC,
};

int drm_exit(struct drm_device *dev, int err) {
	switch(err) {
		case DRM_CRTC:
			drmModeFreeEncoder(dev->encoder);
		case DRM_ENCO:
			drmModeFreeConnector(dev->connector);
		case DRM_CONN:
			drmModeFreeResources(dev->resources);
		case DRM_RESO: 
			close(dev->fd);
		case DRM_OPEN:
			return err;
	}
	return 0;
}

int drm_init(struct drm_device *dev, char offload) {

	dev->fd = open("/dev/dri/card2", O_RDWR);
	if(dev->fd < 0) {
		perror("Failed to open the DRM device");
		return drm_exit(dev, DRM_OPEN);
	}

	dev->resources = drmModeGetResources(dev->fd);
	if(!dev->resources) {
		perror("Failed to get DRM resources");
		return drm_exit(dev, DRM_RESO);
	}

	for(int i = 0; i < dev->resources->count_connectors; i++) {
		dev->connector = drmModeGetConnector(dev->fd, dev->resources->connectors[i]);
		if(dev->connector && dev->connector->connection == DRM_MODE_CONNECTED) {
			break;
		}
		drmModeFreeConnector(dev->connector);
		dev->connector = NULL;
	}

	if(!dev->connector) {
		fprintf(stderr, "No connected connectors found\n");
		return drm_exit(dev, DRM_CONN);
	}

	dev->encoder = drmModeGetEncoder(dev->fd, dev->connector->encoder_id);
	if(!dev->encoder) {
		fprintf(stderr, "Failed to get encoder for connector\n");
		return drm_exit(dev, DRM_ENCO);
	}

	dev->crtc = drmModeGetCrtc(dev->fd, dev->encoder->crtc_id);
	if(!dev->crtc) {
		fprintf(stderr, "Failed to get CRTC\n");
		return drm_exit(dev, DRM_CRTC);
	}

	// Get a resolution
	for(int m = 0; m < dev->connector->count_modes; m++) {
		drmModeModeInfo *tested_res = &dev->connector->modes[m];
		//printf("w:%d, h:%d\n", tested_res->hdisplay, tested_res->vdisplay);
		if(tested_res->type & DRM_MODE_TYPE_PREFERRED) {
			dev->res = tested_res;
			break;
		}
	}
	dev->width = dev->res->hdisplay;
	dev->height = dev->res->vdisplay;

	return 0;
}

static inline void drm_cleanup(struct drm_device *dev) {
	drm_exit(dev, DRM_CRTC);
}

int drm_create_framebuffer(struct drm_device *dev, uint32_t *fb_id, uint32_t **bo) {
	int ret;

	struct drm_mode_create_dumb create_request = {
		.height = (unsigned)dev->height,
		.width = (unsigned)dev->width,
		.bpp = 32,
	};

	//char* prime = getenv("DRI_PRIME");

	//if(!prime) {
		ret = drmIoctl(dev->fd, DRM_IOCTL_MODE_CREATE_DUMB, &create_request);
		if(ret) {
			perror("Failed to create framebuffer buffer object");
			return -1;
		}

		ret = drmModeAddFB(dev->fd, create_request.width, create_request.height, 24, 32, create_request.pitch, create_request.handle, fb_id);
		if(ret) {
			perror("Failed to create framebuffer");
			return -1;
		}

		struct drm_mode_map_dumb mreq = {.handle = create_request.handle};

		ret = drmIoctl(dev->fd, DRM_IOCTL_MODE_MAP_DUMB, &mreq);
		if(ret) {
			perror("Mode map dumb framebuffer failed");
			return -1;
		}

		printf("Size: %d, %d, %d\n", create_request.size, create_request.width, create_request.height);
		*bo = (uint32_t*)mmap(NULL, create_request.size, PROT_READ | PROT_WRITE, MAP_SHARED, dev->fd, mreq.offset);
		if(*bo == MAP_FAILED) {
			perror("Failed to map framebuffer");
			return -1;
		}
	//}else if(prime[0] == '1') {
	//	dev->dGPU = open("/dev/dri/renderD128", O_RDWR);
	//	//Create a GBM to allow opengl to render;
	//	gbm_dev = gbm_create_device(dev->dPGU);
	//	struct gbm_surface *surface = gbm_surface_create(
	//		gbm_dev, width, height,
	//		GBM_FORMAT_XRGB8888,
	//		GBM_BO_USE_RENDERING | GBM_BO_USE_LINEAR | GBM_BO_USE_SCANOUT
	//	);
	//
	//	EGLDisplay egl_dpy = eglGetDisplay((EGLNativeDisplayType)gbm_dev);
	//	eglInitialize(egl_dpy, NULL, NULL);
	//
	//
	//
	//	// render using opengl;
	//	// or maybe try vulkan
	//}

	return 0;
}

void dblfill(uint32_t* m, uint32_t size, uint32_t val) {
	uint32_t filled = 1, fill = 1;
	size--;
	m[0] = val;
	while(size) {
		size -= fill;
		memmove(m+filled, m, fill*4);
		filled *= 2;
		fill = (filled > size)? size : filled;
	}
}

static inline void drm_draw_framebuffer(struct drm_device *dev, uint32_t *bo, uint32_t color) {
	dblfill(bo, (dev->width+10)*dev->height, color);
}

#endif//CAMD_H
