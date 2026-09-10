/* Freestanding research bridge; accepts only the fingerprinted valid file
 * and normalized ASCII queries supplied by the replay harness. */
#include "dictionary_tables.h"
#include "word_enumerator.h"
#include "query_prepare.h"
#include <stddef.h>
static uint8_t data[1070789],fields[4][32],required[128],output[32000];
static MavenDictionaryTables tables;
static MavenDictionarySection sections[3];
static MavenWordEnumeration state;
static unsigned used;
void *memset(void *p,int c,size_t n) {uint8_t *b=p;while(n--)*b++=(uint8_t)c;return p;}
size_t strlen(const char *p) {const char *s=p;while(*p)++p;return (size_t)(p-s);}
static void diagnostic(void *u) {(void)u;__builtin_trap();}
static void emit(void *u,const uint8_t *word) {
 (void)u;while(*word){if(used>=sizeof output)__builtin_trap();output[used++]=*word++;}
 if(used>=sizeof output)__builtin_trap();output[used++]='\n';
}
uint8_t *maven_wasm_data(void){return data;}
uint8_t *maven_wasm_fields(void){return fields[0];}
uint8_t *maven_wasm_output(void){return output;}
unsigned maven_wasm_query(void) {
 int i;used=0;memset(&state,0,sizeof state);
 maven_install_dictionary(data,&tables,diagnostic,0);
 for(i=0;i<2;++i){sections[i].records=tables.tables[i];sections[i].root_index=tables.roots[i];}
 state.sections=sections;state.minimum_length=2;state.maximum_length=15;state.append_word=emit;
 maven_prepare_word_query(&state,fields[0],fields[3],fields[1],fields[2],0,required);
 for(i=0;i<2;++i){state.current_section=(int16_t)i;maven_enumerate_section(&state);}
 return used;
}
