#include "letter_expectation.h"
#include "rack_composition.h"
static uint32_t scores[8];
uint32_t *maven_rack_math_scores(void){return scores;}
uint32_t maven_rack_math_expectation(int total,int count)
{return maven_letter_expectation((int16_t)total,(int16_t)count,scores);}
uint32_t maven_rack_math_composition(int v,int c,int pv,int pc,int total)
{return maven_rack_composition((int16_t)v,(int16_t)c,(int16_t)pv,(int16_t)pc,(int16_t)total,scores);}
