#include "score_statistics.h"
static uint32_t read32(const uint8_t *p) {
  return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 | (uint32_t)p[2] << 8 |
         p[3];
}
static int decode80(const uint8_t *p, double *out) {
  unsigned se = (unsigned)p[0] * 256 + p[1], i;
  uint64_t mantissa = 0;
  int exponent;
  for (i = 2; i < 10; i++)
    mantissa = (mantissa << 8) | p[i];
  if (!(se & 32767) && !mantissa) {
    *out = 0;
    return 1;
  }
  exponent = (int)(se & 32767) - 16383;
  if (!(mantissa & UINT64_C(0x8000000000000000)) || exponent < -1022 ||
      exponent > 1022)
    return 0;
  *out = (double)mantissa / 9223372036854775808.0;
  while (exponent > 0) {
    *out *= 2;
    --exponent;
  }
  while (exponent < 0) {
    *out *= 0.5;
    ++exponent;
  }
  if (se & 32768)
    *out = -*out;
  return 1;
}
int maven_initialize_score_record(uint8_t r[28]) {
  uint32_t count, bits, result = 0;
  unsigned bit_count = 0, i;
  double mean, sum, squares, variance, guess;
  if (!r)
    return 0;
  count = read32(r + 20);
  if (count >= 20 && count < UINT32_C(0x80000000)) {
    if (!decode80(r, &squares) || !decode80(r + 10, &sum))
      return 0;
    mean = sum / count;
    variance = (squares / count - mean * mean) / count;
    if (!(variance >= 0 && variance < 9223372036854775808.0))
      return 0;
    bits = (uint32_t)(uint64_t)variance;
    for (result = bits; result; result >>= 1)
      ++bit_count;
    bits >>= bit_count / 2;
    guess = bits ? (double)bits : 1.0;
    for (i = 0; i < 5 && guess > 0; i++)
      guess = (variance / guess + guess) / 2;
    if (guess > 80) {
      if (mean > guess)
        mean -= guess;
      else if (mean < -guess)
        mean += guess;
      else
        mean = 0;
    }
    if (!(mean >= -2147483648.0 && mean < 2147483648.0))
      return 0;
    result = (uint32_t)(int32_t)mean;
  }
  r[24] = (uint8_t)(result >> 24);
  r[25] = (uint8_t)(result >> 16);
  r[26] = (uint8_t)(result >> 8);
  r[27] = (uint8_t)result;
  return 1;
}
int maven_initialize_score_table(uint8_t *records, size_t length) {
  size_t i;
  if (!records || length % 28)
    return 0;
  for (i = 0; i < length; i += 28)
    if (!maven_initialize_score_record(records + i))
      return 0;
  return 1;
}
