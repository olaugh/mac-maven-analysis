/* Research-driver adapter. One open file/allocation, not a general Toolbox
 * replacement. The Python entry point verifies the original data hash. */
#include "whole_file.h"
#include <stdio.h>
#include <stdlib.h>
typedef struct {
    const char *path;
    FILE *file;
    uint32_t allocation_size;
} NativeFile;
static int16_t native_open(void *u,const uint8_t *name,int16_t volume,int16_t *ref) {
    NativeFile *f=u;(void)name;(void)volume;
    f->file=fopen(f->path,"rb");if(!f->file)return -43;*ref=1;return 0;
}
static int16_t native_eof(void *u,int16_t ref,uint32_t *length) {
    NativeFile *f=u;long size;(void)ref;
    if(fseek(f->file,0,SEEK_END))return -36;
    size=ftell(f->file);if(size<0 || (unsigned long)size>UINT32_MAX)return -36;
    rewind(f->file);*length=(uint32_t)size;return 0;
}
static uint8_t *native_allocate(void *u,uint32_t length) {
    NativeFile *f=u;f->allocation_size=length;return calloc(length,1);
}
static int16_t native_read(void *u,int16_t ref,uint32_t *length,uint8_t *data) {
    NativeFile *f=u;size_t count;(void)ref;
    count=fread(data,1,*length,f->file);*length=(uint32_t)count;
    return ferror(f->file)?-36:0;
}
static uint32_t native_size(void *u,uint8_t *data) { (void)data;return ((NativeFile *)u)->allocation_size; }
static int16_t native_close(void *u,int16_t ref) {
    NativeFile *f=u;int result;(void)ref;result=fclose(f->file);f->file=NULL;return result?-36:0;
}
static void native_dispose(void *u,uint8_t *data) { (void)u;free(data); }
static MavenWholeFileOps native_ops(NativeFile *f) {
    MavenWholeFileOps ops={f,native_open,native_eof,native_allocate,native_read,native_size,native_close,native_dispose};
    return ops;
}
