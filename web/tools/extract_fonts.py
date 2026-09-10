#!/usr/bin/env python
"""Extract classic Mac OS bitmap fonts (FONT/NFNT strikes) from an HFS disk
image into compact JSON atlases for the browser port of Maven.

Usage:
    extract_fonts.py [--image PATH] [--out DIR] [--all] [--verbose]

By default it extracts the fonts Maven's UI needs (Chicago 12, every Geneva
and Helvetica bitmap size, Monaco 9).  --all extracts every bitmap strike in
the System file and the Fonts folder.

Fonts that exist only as TrueType outlines (Charcoal, the Mac OS 8 system
font used for menus and window titles) are rasterized from the suitcase's
'sfnt' resource with FreeType (monochrome, hinted) into the same format;
advances come from the outline's own hmtx table so line layout matches the
classic Font Manager.  Pixel shapes may differ slightly from Apple's scaler.
Use --tt Family:size to add more (default: Charcoal:12).

Output format (web/fonts/<family>-<size>[-<style>].json):
    {"family","size","style","ascent","descent","leading","widMax","height",
     "kernMax","firstChar","lastChar",
     "glyphs":{"65":{"w":advance,"o":offset,"cols":[...]}},
     "missing":{"w":..,"o":..,"cols":[...]}}
`cols` is one integer per pixel column of the glyph image, bit 0 = top row,
so a glyph is drawn left to right.  Glyph image height is `height`.

The disk image is only ever opened read-only.
"""
import argparse
import json
import os
import struct
import sys

DEFAULT_IMAGE = '/Users/john/sources/jan14-aviary/media/maven/hds/macos8.img'
HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_OUT = os.path.normpath(os.path.join(HERE, '..', 'fonts'))

# Families we want by default: family name -> set of sizes (None = all sizes)
WANTED = {
    'Chicago': {12},
    'Geneva': None,
    'Helvetica': None,
    'Monaco': {9},
}

# Classic FONT-resource family ids (FONT id = family*128 + size)
FONT_FAMILY_IDS = {0: 'Chicago', 1: 'Chicago', 2: 'New York', 3: 'Geneva', 4: 'Monaco',
                   5: 'Venice', 6: 'London', 7: 'Athens', 8: 'San Francisco',
                   9: 'Toronto', 11: 'Cairo', 12: 'Los Angeles', 20: 'Times',
                   21: 'Helvetica', 22: 'Courier', 23: 'Symbol', 24: 'Mobile'}

STYLE_BITS = [(1, 'bold'), (2, 'italic'), (4, 'underline'), (8, 'outline'),
              (16, 'shadow'), (32, 'condensed'), (64, 'extended')]


def style_name(style):
    if style == 0:
        return ''
    return '-'.join(n for bit, n in STYLE_BITS if style & bit) or 'style%d' % style


# ---------------------------------------------------------------- resources

def rsrc_map(r):
    """Parse a resource fork into {type: [(id, name, data), ...]}."""
    if len(r) < 16:
        return {}
    doff, moff, dlen, mlen = struct.unpack('>IIII', r[:16])
    m = r[moff:moff + mlen]
    tl, nl = struct.unpack('>HH', m[24:28])
    n = struct.unpack('>H', m[tl:tl + 2])[0] + 1
    out = {}
    for i in range(n):
        t, cnt, ro = struct.unpack('>4sHH', m[tl + 2 + 8 * i:tl + 10 + 8 * i])
        cnt += 1
        lst = []
        for j in range(cnt):
            rid, nameoff, attr_off = struct.unpack('>hhI', m[tl + ro + 12 * j:tl + ro + 8 + 12 * j])
            off = attr_off & 0xffffff
            ln = struct.unpack('>I', r[doff + off:doff + off + 4])[0]
            name = None
            if nameoff != -1:
                k = m[nl + nameoff]
                name = m[nl + nameoff + 1:nl + nameoff + 1 + k].decode('mac_roman')
            lst.append((rid, name, r[doff + off + 4:doff + off + 4 + ln]))
        out[t.decode('mac_roman')] = lst
    return out


# --------------------------------------------------------------------- FOND

def parse_fond(data):
    """Return (family_id, [(size, style, rsrc_id), ...]) from a FOND resource."""
    (flags, fam_id, first, last, ascent, descent, leading, widmax,
     wtab_off, ktab_off, stab_off) = struct.unpack('>HhhhhhhhIII', data[:28])
    # 26 + property list (9 words) + intl (2 words) + version (1 word) = 52
    pos = 52
    count = struct.unpack('>h', data[pos:pos + 2])[0] + 1
    pos += 2
    assoc = []
    for _ in range(count):
        size, style, rid = struct.unpack('>hhh', data[pos:pos + 6])
        pos += 6
        assoc.append((size, style, rid))
    return fam_id, assoc


# ---------------------------------------------------------------- FONT/NFNT

class DecodeError(Exception):
    pass


def decode_strike(data):
    """Decode a FONT or NFNT resource into a dict of metrics and glyphs."""
    if len(data) < 26:
        raise DecodeError('resource too short (%d bytes)' % len(data))
    (font_type, first_char, last_char, wid_max, kern_max, n_descent,
     rect_w, rect_h, ow_tloc, ascent, descent, leading,
     row_words) = struct.unpack('>HHHHhhHHHHHHH', data[:26])
    if last_char < first_char or last_char > 255:
        raise DecodeError('bad char range %d..%d' % (first_char, last_char))
    n_glyphs = last_char - first_char + 2          # includes missing-glyph entry
    row_bytes = row_words * 2
    strike_off = 26
    strike_len = row_bytes * rect_h
    loc_off = strike_off + strike_len
    # owTLoc is a word offset from itself (byte 16) to the offset/width table
    ow_off = 16 + ow_tloc * 2
    n_entries = n_glyphs + 1                        # lastChar-firstChar+3
    if ow_off < loc_off + 2 * n_entries:
        # Some FONT resources have owTLoc computed with the high word of a
        # 32-bit offset elsewhere; fall back to the table following locTable.
        ow_off = loc_off + 2 * n_entries
    # The final (pad) word of the offset/width table is absent in some FONTs.
    if ow_off + 2 * n_glyphs > len(data):
        raise DecodeError('offset/width table past end (%d > %d)'
                          % (ow_off + 2 * n_glyphs, len(data)))
    strike = data[strike_off:loc_off]
    loc = struct.unpack('>%dH' % n_entries, data[loc_off:loc_off + 2 * n_entries])
    ow = struct.unpack('>%dH' % n_glyphs, data[ow_off:ow_off + 2 * n_glyphs])
    strike_bits = row_bytes * 8

    def column(x):
        """Return the bitmask (bit 0 = top row) of strike column x."""
        v = 0
        byte_i = x >> 3
        mask = 0x80 >> (x & 7)
        for y in range(rect_h):
            if strike[y * row_bytes + byte_i] & mask:
                v |= 1 << y
        return v

    glyphs = {}
    missing = None
    for i in range(n_glyphs):
        if ow[i] == 0xFFFF:
            continue
        x0, x1 = loc[i], loc[i + 1]
        if x1 < x0 or x1 > strike_bits:
            raise DecodeError('glyph %d location %d..%d outside strike width %d'
                              % (first_char + i, x0, x1, strike_bits))
        g = {'w': ow[i] & 0xFF,
             'o': kern_max + (ow[i] >> 8),
             'cols': [column(x) for x in range(x0, x1)]}
        if i == n_glyphs - 1:
            missing = g
        else:
            glyphs[str(first_char + i)] = g
    return {
        'fontType': font_type,
        'ascent': ascent, 'descent': descent, 'leading': leading,
        'widMax': wid_max, 'height': rect_h, 'kernMax': kern_max,
        'nDescent': n_descent, 'fRectWidth': rect_w,
        'firstChar': first_char, 'lastChar': last_char,
        'glyphs': glyphs, 'missing': missing,
    }


# ---------------------------------------------------------------- TrueType

def sfnt_tables(data):
    n = struct.unpack('>H', data[4:6])[0]
    tabs = {}
    for i in range(n):
        tag, _, off, ln = struct.unpack('>4sIII', data[12 + 16 * i:28 + 16 * i])
        tabs[tag.decode('latin1')] = data[off:off + ln]
    return tabs


def sfnt_macroman_advances(data, ppem=None):
    """Return (unitsPerEm, {mac_roman_byte: advance}) from an sfnt.

    If `ppem` is given and the font has an 'hdmx' record for that pixel size,
    the advances returned are integer device widths (what the classic Font
    Manager uses) and unitsPerEm is returned as 0 to signal that."""
    t = sfnt_tables(data)
    upem = struct.unpack('>H', t['head'][18:20])[0]
    n_hm = struct.unpack('>H', t['hhea'][34:36])[0]
    hmtx = t['hmtx']
    adv = [struct.unpack('>H', hmtx[4 * i:4 * i + 2])[0] for i in range(n_hm)]
    cmap = t['cmap']
    nsub = struct.unpack('>H', cmap[2:4])[0]
    subs = []
    for i in range(nsub):
        plat, enc, off = struct.unpack('>HHI', cmap[4 + 8 * i:12 + 8 * i])
        subs.append((plat, enc, struct.unpack('>H', cmap[off:off + 2])[0], off))
    gid = {}                                   # mac roman byte -> glyph id
    mac = [(o, f) for p, e, f, o in subs if p == 1 and e == 0 and f in (0, 6)]
    if mac:
        off, fmt = mac[0]
        if fmt == 0:
            for c in range(256):
                gid[c] = cmap[off + 6 + c]
        else:
            first, count = struct.unpack('>HH', cmap[off + 6:off + 10])
            for i in range(count):
                gid[first + i] = struct.unpack('>H', cmap[off + 10 + 2 * i:off + 12 + 2 * i])[0]
    else:
        uni = [o for p, e, f, o in subs if f == 4 and (p == 0 or (p == 3 and e == 1))]
        if not uni:
            raise DecodeError('no usable cmap subtable (formats %s)' % [f for _, _, f, _ in subs])
        off = uni[0]
        segx2 = struct.unpack('>H', cmap[off + 6:off + 8])[0]
        segs = segx2 // 2
        ends = struct.unpack('>%dH' % segs, cmap[off + 14:off + 14 + segx2])
        starts = struct.unpack('>%dH' % segs, cmap[off + 16 + segx2:off + 16 + 2 * segx2])
        deltas = struct.unpack('>%dh' % segs, cmap[off + 16 + 2 * segx2:off + 16 + 3 * segx2])
        ro_base = off + 16 + 3 * segx2
        ranges = struct.unpack('>%dH' % segs, cmap[ro_base:ro_base + segx2])
        for c in range(256):
            u = ord(bytes([c]).decode('mac_roman', 'replace'))
            for k in range(segs):
                if starts[k] <= u <= ends[k]:
                    if ranges[k] == 0:
                        g = (u + deltas[k]) & 0xFFFF
                    else:
                        a = ro_base + 2 * k + ranges[k] + 2 * (u - starts[k])
                        g = struct.unpack('>H', cmap[a:a + 2])[0]
                        if g:
                            g = (g + deltas[k]) & 0xFFFF
                    if g:
                        gid[c] = g
                    break
    device = None
    if ppem and 'hdmx' in t:
        h = t['hdmx']
        version, num, rec_size = struct.unpack('>HhI', h[:8])
        for r in range(num):
            rec = h[8 + r * rec_size:8 + (r + 1) * rec_size]
            if rec and rec[0] == ppem:
                device = rec[2:]
                break
    out = {}
    for c, g in gid.items():
        if g:
            if device is not None and g < len(device):
                out[c] = device[g]
            else:
                out[c] = adv[min(g, n_hm - 1)]
    return (0 if device is not None else upem), out


def rasterize_sfnt(data, size):
    """Rasterize a TrueType 'sfnt' resource at `size` px into the strike dict format."""
    import io
    from PIL import Image, ImageDraw, ImageFont
    font = ImageFont.truetype(io.BytesIO(data), size)
    asc, desc = font.getmetrics()
    height = asc + desc
    upem, advances = sfnt_macroman_advances(data, ppem=size)
    W, H = 4 * size + 32, 4 * size + 32
    ox, oy = size + 16, 2 * size + 16          # pen origin, baseline
    glyphs = {}
    wid_max = 0
    for c, adv_units in sorted(advances.items()):
        if c < 32:
            continue
        ch = bytes([c]).decode('mac_roman')
        im = Image.new('1', (W, H), 1)
        ImageDraw.Draw(im).text((ox, oy), ch, font=font, fill=0, anchor='ls')
        px = im.load()
        cols = []
        for x in range(W):
            v = 0
            for y in range(height):
                yy = oy - asc + y
                if 0 <= yy < H and not px[x, yy]:
                    v |= 1 << y
            cols.append(v)
        xs = [x for x, v in enumerate(cols) if v]
        adv = adv_units if upem == 0 else int(round(adv_units * size / upem))
        if xs:
            g = {'w': adv, 'o': xs[0] - ox, 'cols': cols[xs[0]:xs[-1] + 1]}
        else:
            g = {'w': adv, 'o': 0, 'cols': []}
        glyphs[str(c)] = g
        wid_max = max(wid_max, adv)
    return {'ascent': asc, 'descent': desc, 'leading': 0, 'widMax': wid_max,
            'height': height, 'kernMax': 0, 'firstChar': 32, 'lastChar': 255,
            'glyphs': glyphs, 'missing': {'w': wid_max // 2, 'o': 0, 'cols': []}}


def collect_sfnt(volume, family):
    """Return (rsrc_id, data) of the regular-style sfnt for a family in the Fonts folder."""
    sf = volume['System Folder']
    if 'Fonts' not in sf or family not in sf['Fonts']:
        return None
    rm = rsrc_map(sf['Fonts'][family].rsrc)
    fond_sfnts = set()
    for rid, name, data in rm.get('FOND', []):
        fam_id, assoc = parse_fond(data)
        fond_sfnts.update(srid for size, style, srid in assoc if size == 0 and style == 0)
    for rid, name, data in rm.get('sfnt', []):
        if rid in fond_sfnts:
            return rid, data
    return None


# --------------------------------------------------------------------- main

def collect(volume, verbose=False):
    """Walk the System file and Fonts folder; yield strike descriptors.

    Yields dicts: {family, size, style, source, rsrc_type, rsrc_id, data}.
    """
    sf = volume['System Folder']
    files = [('System', sf['System'])]
    if 'Fonts' in sf:
        for name in sorted(sf['Fonts'].keys()):
            files.append(('Fonts/' + name, sf['Fonts'][name]))
    seen = set()
    for label, f in files:
        rm = rsrc_map(f.rsrc)
        fond_by_id = {}       # (type, id) -> (family, size, style)
        family_name_by_id = {}
        for rid, name, data in rm.get('FOND', []):
            try:
                fam_id, assoc = parse_fond(data)
            except struct.error:
                print('  ! bad FOND %d in %s' % (rid, label), file=sys.stderr)
                continue
            fam = name or FONT_FAMILY_IDS.get(fam_id, 'Family%d' % fam_id)
            family_name_by_id[fam_id] = fam
            for size, style, srid in assoc:
                if size == 0:
                    continue          # sfnt (TrueType) association
                fond_by_id[srid] = (fam, size, style)
            if verbose:
                print('  FOND %d %r (family id %d): %s' % (rid, fam, fam_id, assoc))
        for rtype in ('NFNT', 'FONT'):
            for rid, name, data in rm.get(rtype, []):
                if rid in fond_by_id:
                    fam, size, style = fond_by_id[rid]
                elif rtype == 'FONT':
                    fam_id, size = divmod(rid, 128)
                    if size == 0:
                        continue      # FONT id family*128 is the name-only record
                    fam = family_name_by_id.get(fam_id) or FONT_FAMILY_IDS.get(fam_id, 'Family%d' % fam_id)
                    style = 0
                else:
                    print('  ! %s %d in %s not referenced by any FOND; skipped'
                          % (rtype, rid, label), file=sys.stderr)
                    continue
                key = (fam, size, style)
                if key in seen:
                    if verbose:
                        print('  duplicate %s %d pt style %d (%s %d in %s); skipped'
                              % (fam, size, style, rtype, rid, label))
                    continue
                seen.add(key)
                yield {'family': fam, 'size': size, 'style': style,
                       'source': label, 'rsrc_type': rtype, 'rsrc_id': rid,
                       'data': data}


def wanted(desc, all_fonts):
    if all_fonts:
        return True
    sizes = WANTED.get(desc['family'], False)
    if sizes is False:
        return False
    return sizes is None or desc['size'] in sizes


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--image', default=DEFAULT_IMAGE)
    ap.add_argument('--out', default=DEFAULT_OUT)
    ap.add_argument('--all', action='store_true', help='extract every bitmap font')
    ap.add_argument('--tt', action='append', default=None, metavar='FAMILY:SIZE',
                    help='rasterize a TrueType-only family at SIZE px (default Charcoal:12)')
    ap.add_argument('--verbose', '-v', action='store_true')
    args = ap.parse_args()

    import machfs
    vol = machfs.Volume()
    with open(args.image, 'rb') as fh:
        vol.read(fh.read())

    os.makedirs(args.out, exist_ok=True)
    index = []
    problems = []
    for desc in collect(vol, args.verbose):
        if not wanted(desc, args.all):
            continue
        tag = '%s %d pt%s' % (desc['family'], desc['size'],
                              (' ' + style_name(desc['style'])) if desc['style'] else '')
        try:
            strike = decode_strike(desc['data'])
        except DecodeError as e:
            problems.append('%s (%s %d in %s): %s' % (tag, desc['rsrc_type'], desc['rsrc_id'], desc['source'], e))
            continue
        fname = '%s-%d' % (desc['family'].replace(' ', ''), desc['size'])
        if desc['style']:
            fname += '-' + style_name(desc['style'])
        fname += '.json'
        out = {
            'family': desc['family'], 'size': desc['size'], 'style': desc['style'],
            'ascent': strike['ascent'], 'descent': strike['descent'],
            'leading': strike['leading'], 'widMax': strike['widMax'],
            'height': strike['height'], 'kernMax': strike['kernMax'],
            'firstChar': strike['firstChar'], 'lastChar': strike['lastChar'],
            'glyphs': strike['glyphs'], 'missing': strike['missing'],
        }
        path = os.path.join(args.out, fname)
        with open(path, 'w') as fh:
            json.dump(out, fh, separators=(',', ':'))
        entry = {'file': fname, 'family': desc['family'], 'size': desc['size'],
                 'style': desc['style'], 'ascent': strike['ascent'],
                 'descent': strike['descent'], 'height': strike['height'],
                 'glyphs': len(strike['glyphs']),
                 'source': '%s %s %d' % (desc['source'], desc['rsrc_type'], desc['rsrc_id'])}
        index.append(entry)
        print('%-28s %-24s asc %2d desc %2d height %2d widMax %2d glyphs %3d  <- %s'
              % (fname, tag, strike['ascent'], strike['descent'], strike['height'],
                 strike['widMax'], len(strike['glyphs']), entry['source']))
    for spec in (args.tt if args.tt is not None else ['Charcoal:12']):
        fam, size = spec.rsplit(':', 1)
        size = int(size)
        found = collect_sfnt(vol, fam)
        if not found:
            problems.append('%s: no sfnt found in Fonts folder' % fam)
            continue
        rid, data = found
        try:
            strike = rasterize_sfnt(data, size)
        except Exception as e:      # FreeType / table problems
            problems.append('%s %d pt (sfnt %d): %s' % (fam, size, rid, e))
            continue
        fname = '%s-%d.json' % (fam.replace(' ', ''), size)
        out = dict(family=fam, size=size, style=0, **strike)
        with open(os.path.join(args.out, fname), 'w') as fh:
            json.dump(out, fh, separators=(',', ':'))
        entry = {'file': fname, 'family': fam, 'size': size, 'style': 0,
                 'ascent': strike['ascent'], 'descent': strike['descent'],
                 'height': strike['height'], 'glyphs': len(strike['glyphs']),
                 'source': 'Fonts/%s sfnt %d (FreeType raster)' % (fam, rid)}
        index.append(entry)
        print('%-28s %-24s asc %2d desc %2d height %2d widMax %2d glyphs %3d  <- %s'
              % (fname, '%s %d px (TrueType)' % (fam, size), strike['ascent'], strike['descent'],
                 strike['height'], strike['widMax'], len(strike['glyphs']), entry['source']))
    index.sort(key=lambda e: (e['family'], e['size'], e['style']))
    with open(os.path.join(args.out, 'index.json'), 'w') as fh:
        json.dump({'fonts': index}, fh, separators=(',', ':'))
    print('wrote %d fonts + index.json to %s' % (len(index), args.out))
    if problems:
        print('decoding problems:')
        for p in problems:
            print('  ' + p)
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
