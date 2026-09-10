#include "history_records.h"
MavenHistoryResult maven_decode_history_records(const uint8_t *data,size_t length,
    MavenHistoryRecord *records,size_t capacity,size_t *count) {
    size_t offset=0,n=0,i;
    if(!data||!count||!length)return MAVEN_HISTORY_INVALID;
    while(offset<length){
        size_t size;
        if(length-offset<4 || data[offset+2]>=128)return MAVEN_HISTORY_INVALID;
        size=(size_t)data[offset+2]*256+data[offset+3];
        if(size>length-offset-4 || n==32767)return MAVEN_HISTORY_INVALID;
        offset+=4+size;++n;
    }
    *count=n;
    if(n>capacity||!records)return MAVEN_HISTORY_CAPACITY;
    offset=0;
    for(i=0;i<n;i++){
        uint8_t tag=data[offset+1];
        records[i].tag=tag<128?(int8_t)tag:(int8_t)((int)tag-256);
        records[i].length=(uint16_t)((unsigned)data[offset+2]*256+data[offset+3]);
        records[i].payload=data+offset+4;offset+=4+records[i].length;
    }
    return MAVEN_HISTORY_OK;
}

MavenHistoryResult maven_encode_history_records(const MavenHistoryRecord *records,
    size_t count,uint8_t *output,size_t capacity,size_t *length){
    size_t i,n=0,offset=0;
    if(!records||!length||!count||count>32767)return MAVEN_HISTORY_INVALID;
    for(i=0;i<count;i++){
        size_t size=records[i].length;
        if(size>32767||(size&&!records[i].payload)||(records[i].tag==1&&size<6))return MAVEN_HISTORY_INVALID;
        if(n>SIZE_MAX-size-4)return MAVEN_HISTORY_INVALID;
        n+=size+4;
    }
    *length=n;
    if(!output||capacity<n)return MAVEN_HISTORY_CAPACITY;
    for(i=0;i<count;i++){
        size_t k,size=records[i].length;uint16_t tag=(uint16_t)(int16_t)records[i].tag;
        output[offset++]=(uint8_t)(tag>>8);output[offset++]=(uint8_t)tag;
        output[offset++]=(uint8_t)(size>>8);output[offset++]=(uint8_t)size;
        for(k=0;k<size;k++)output[offset++]=records[i].tag==1&&(k==4||k==5)?0:records[i].payload[k];
    }
    return MAVEN_HISTORY_OK;
}
