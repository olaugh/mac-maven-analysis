/* Native filesystem adapter for replaying the captured success path.
 * This is a test driver, not the original Toolbox implementation. */
#include "whole_file.h"
#include "index_file.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static FILE *input;
static uint32_t allocation;
static unsigned count;
static char calls[16];
static const char *expected_name;
static int16_t expected_volume;
static MavenWholeFileOps *active_ops;
static uint32_t loaded_length;
static const uint8_t *load_index_file(const void *name,short volume,uint32_t *length) {
    uint8_t *result=maven_read_whole_file(name,volume,length,active_ops);
    loaded_length=*length;return result;
}
static void event(char c) { assert(count<15);calls[count++]=c; }
static int16_t open_file(void *u,const uint8_t *name,int16_t volume,int16_t *ref) {
    (void)u;event('o');assert(volume==expected_volume);
    assert(name[0]==strlen(expected_name));assert(!memcmp(name+1,expected_name,name[0]));
    *ref=7;return 0;
}
static int16_t eof(void *u,int16_t ref,uint32_t *length) {
    long end;(void)u;event('e');assert(ref==7);
    assert(!fseek(input,0,SEEK_END));end=ftell(input);assert(end>=0 && (unsigned long)end<=UINT32_MAX);
    *length=(uint32_t)end;rewind(input);return 0;
}
static uint8_t *allocate(void *u,uint32_t length) {
    (void)u;event('a');allocation=length;return calloc(length,1);
}
static int16_t read_file(void *u,int16_t ref,uint32_t *length,uint8_t *buffer) {
    size_t actual;(void)u;event('r');assert(ref==7);
    actual=fread(buffer,1,*length,input);*length=(uint32_t)actual;
    return ferror(input)?-36:0;
}
static uint32_t size(void *u,uint8_t *buffer) { (void)u;(void)buffer;event('s');return allocation; }
static int16_t close_file(void *u,int16_t ref) { (void)u;event('c');assert(ref==7);return fclose(input)?-36:0; }
static void dispose(void *u,uint8_t *buffer) { (void)u;event('d');free(buffer); }
int main(int argc,char **argv) {
    uint8_t name[256],*result;uint32_t length,index=0;FILE *out;
    static MavenErrorContext errors;
    MavenWholeFileOps ops={0,open_file,eof,allocate,read_file,size,close_file,dispose};
    assert(argc==6 || (argc==7 && !strcmp(argv[6],"index")));input=fopen(argv[1],"rb");assert(input);
    expected_name=argv[2];assert(strlen(expected_name)<=255);
    expected_volume=(int16_t)strtol(argv[3],0,10);length=(uint32_t)strtoul(argv[4],0,10);
    name[0]=(uint8_t)strlen(expected_name);memcpy(name+1,expected_name,name[0]);
    if(argc==7) {
        active_ops=&ops;
        if(MAVEN_SAVE_ERROR_CONTEXT(&errors)) { fprintf(stderr,"index load failed\n");return 1; }
        result=(uint8_t *)maven_load_index_and_find_a(name,&index,load_index_file,&errors,"index load");
        length=loaded_length;errors.depth=0;
    } else result=maven_read_whole_file(name,expected_volume,&length,&ops);
    assert(result);
    out=fopen(argv[5],"wb");assert(out);assert(fwrite(result,1,(size_t)length+1,out)==(size_t)length+1);assert(!fclose(out));
    printf("{\"length\":%u,\"allocation\":%u,\"calls\":\"%s\",\"trailing_byte\":%u,\"index\":%u}\n",length,allocation,calls,result[length],index);
    free(result);return 0;
}
