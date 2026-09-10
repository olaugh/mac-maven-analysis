#include "word_enumerator.h"
#include "query_prepare.h"
#include "dictionary_setup.h"
#include "native_file_ops.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static MavenWordEnumeration state;
static MavenDictionaryTables tables;
static MavenErrorContext errors;
static NativeFile source;
static void diagnostic(void *user) { (void)user; fputs("Invalid dictionary root\n",stderr);exit(5); }
static void emit(void *user,const uint8_t *word) { (void)user; puts((const char *)word); }
int main(int argc,char **argv) {
    MavenDictionarySection sections[3]; uint8_t required[128]; int i;
    MavenWholeFileOps ops;
    const uint8_t logical_name[]={0};
    if (argc != 7) return 2;
    source.path=argv[1];ops=native_ops(&source);
    if(MAVEN_SAVE_ERROR_CONTEXT(&errors)) {
        if(source.file)fclose(source.file);
        fputs("Dictionary load failed\n",stderr);return 4;
    }
    maven_load_dictionary(logical_name,&tables,&ops,&errors,"dictionary load",diagnostic,NULL);
    errors.depth=0;
    for(i=0;i<2;++i){sections[i].records=tables.tables[i];sections[i].root_index=tables.roots[i];}
    sections[2].records=0;sections[2].root_index=0;
    state.sections=sections;state.minimum_length=2;state.maximum_length=15;
    state.append_word=emit;
    maven_prepare_word_query(&state,(const uint8_t *)argv[2],(const uint8_t *)argv[5],
                            (const uint8_t *)argv[3],(const uint8_t *)argv[4],atoi(argv[6]),required);
    for(i=0;i<2;++i){state.current_section=(int16_t)i;maven_enumerate_section(&state);}
    fprintf(stderr,"count=%d length=%lu blanks_used=%d\n",state.result_count,(unsigned long)state.length,state.blanks_used);
    free(tables.tables[0]-12);return 0;
}
