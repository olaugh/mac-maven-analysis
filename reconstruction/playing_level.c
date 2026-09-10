#include "playing_level.h"
/* Rating cap per menu item, strongest first (A5-0x5e74). Item 0 == 2100. */
const int16_t maven_level_ratings[MAVEN_LEVEL_COUNT] = {
    2100, 2060, 2020, 1980, 1940, 1900, 1860, 1820, 1780,
    1740, 1700, 1660, 1620, 1580, 1540, 1500, 1460, 1420};
/* Accepted candidates out of 256 per level (A5-0x1d44). Items 0 and 1 accept
 * all 256; the search still runs heuristic-only from item 1 down. */
const uint16_t maven_level_accept[MAVEN_LEVEL_COUNT] = {
    256, 256, 216, 182, 153, 128, 108, 90, 76,
    64,  54,  45,  38,  32,  27,  23, 19, 16};

void maven_level_filter_init(MavenLevelFilter *f, int level_index, uint16_t counter) {
  if (level_index < 0 || level_index >= MAVEN_LEVEL_COUNT)
    level_index = 0;
  f->active = level_index >= 1;
  f->accept = maven_level_accept[level_index];
  f->counter = (uint16_t)(counter & 0xff);
}

int maven_level_admit(MavenLevelFilter *f) {
  unsigned position = f->counter;
  f->counter = (uint16_t)((f->counter + 1u) & 0xff);
  if (!f->active)
    return 1;
  return (int)(((241u * position) & 0xffu) < f->accept);
}

int maven_level_accepts(unsigned index, uint16_t accept) {
  return (int)(((241u * (index & 0xffu)) & 0xffu) < accept);
}

int16_t maven_level_leave_offset(int level_index, int16_t player_rating) {
  int32_t d;
  if (level_index < 0 || level_index >= MAVEN_LEVEL_COUNT)
    return 0;
  d = (int32_t)maven_level_ratings[level_index] - (int32_t)player_rating;
  if (d < -32768)
    d = -32768;
  else if (d > 32767)
    d = 32767;
  return (int16_t)d;
}
