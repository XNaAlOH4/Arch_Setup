#ifndef READHEIF_H
#define READHEIF_H

#include <libheif/heif.h>

typedef struct {
	struct heif_context* ctx;
	struct heif_image_handle* handle;
	struct heif_image* img;
	int Totalwidth;
	int Totalheight;
	size_t stride;
	const uint8_t* data;
}heif_t;

heif_t readHeif(const char* filename, int scl) {
	heif_t heif = {0};
	heif.ctx = heif_context_alloc();
	{
		FILE* test;
		if(!(test = fopen(filename, "r"))) {
			printf("Please give a valid file\n");
			return heif;
		}
		fclose(test);
	}

	heif_context_read_from_file(heif.ctx, filename, NULL);
	heif_context_get_primary_image_handle(heif.ctx, &heif.handle);
	heif_decode_image(heif.handle, &heif.img, heif_colorspace_RGB, heif_chroma_interleaved_RGB, NULL);

	heif.Totalwidth = heif_image_get_width(heif.img, heif_channel_interleaved);
	heif.Totalheight = heif_image_get_height(heif.img, heif_channel_interleaved);

	heif_image* tmp_img = heif.img;
	heif_error err = heif_image_scale_image(tmp_img, &heif.img, heif.Totalwidth/scl, heif.Totalheight/scl, NULL);
	heif.Totalwidth /= scl;
	heif.Totalheight /= scl;

	heif.data = heif_image_get_plane_readonly2(heif.img, heif_channel_interleaved, &heif.stride);
	return heif;
}

void heif_cleanup(heif_t heif) {
	heif_image_release(heif.img);
	heif_image_handle_release(heif.handle);
	heif_context_free(heif.ctx);
}

#endif//READHEIF_H
