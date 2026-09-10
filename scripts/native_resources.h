#ifndef MAVEN_NATIVE_RESOURCES_H
#define MAVEN_NATIVE_RESOURCES_H
#include "engine_tables.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static int resource_read(MavenBlob *blob,const char *root,const char *type,const char *name){
 char path[4096];FILE *f;long n;uint8_t *data;
 if(snprintf(path,sizeof path,"%s/%s/%s",root,type,name)>=(int)sizeof path)return 0;
 f=fopen(path,"rb");if(!f)return 0;
 if(fseek(f,0,SEEK_END)||(n=ftell(f))<0||n>1048576||fseek(f,0,SEEK_SET)){fclose(f);return 0;}
 data=malloc((size_t)n);if(!data){fclose(f);return 0;}
 if(fread(data,1,(size_t)n,f)!=(size_t)n){free(data);fclose(f);return 0;}
 fclose(f);blob->data=data;blob->size=(size_t)n;return 1;
}
static void free_resources(MavenTableResources *r){
 unsigned i;free((void *)r->data.data);free((void *)r->zero.data);free((void *)r->relocations.data);free((void *)r->preferences.data);
 free((void *)r->patterns.data);free((void *)r->strings.data);free((void *)r->scores.data);free((void *)r->opening.data);
 for(i=0;i<27;i++)free((void *)r->letters[i].data);for(i=0;i<8;i++)free((void *)r->composition[i].data);
 memset(r,0,sizeof *r);
}
static int load_resources(MavenTableResources *r,const char *root){
 unsigned i;char type[5];memset(r,0,sizeof *r);
 if(!resource_read(&r->data,root,"DATA","0_0.bin")||!resource_read(&r->zero,root,"ZERO","0_0.bin")||
 !resource_read(&r->relocations,root,"DREL","0_0.bin")||!resource_read(&r->preferences,root,"prfs","0_0.bin")||
 !resource_read(&r->patterns,root,"PATB","0_entries.bin")||!resource_read(&r->strings,root,"ESTR","0_pattern_strings.bin")||
 !resource_read(&r->scores,root,"EXPR","0_full.bin")||!resource_read(&r->opening,root,"FRST","0_0.bin"))goto failed;
 for(i=0;i<27;i++){memcpy(type,"MUL?",5);type[3]="?abcdefghijklmnopqrstuvwxyz"[i];if(!resource_read(&r->letters[i],root,type,"0_0.bin"))goto failed;}
 for(i=0;i<8;i++){memcpy(type,"VCBa",5);type[3]=(char)('a'+i);if(!resource_read(&r->composition[i],root,type,"0_0.bin"))goto failed;}
 return 1;
failed:free_resources(r);return 0;
}
#endif
