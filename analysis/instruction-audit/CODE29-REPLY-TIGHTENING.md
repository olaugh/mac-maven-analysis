# CODE29+0054–00d2 → `tighten_replies`

Every decoded instruction in this routine has an effect mapping below. Called helpers require their own audits. ABI mechanics map to C function lifetime; observable writes remain explicit.

| Offset | Original instruction | C effect |
|---|---|---|
| 0x0054 | `link.w     a6, #$0` | C activation record; saved A4 is represented by the node local. |
| 0x0058 | `move.l     a4, -(a7)` | C activation record; saved A4 is represented by the node local. |
| 0x005a | `movea.l    $8(a6), a4` | tighten_replies: node and the emptied-rack / child / pass guards. |
| 0x005e | `tst.b      $1c(a4)` | tighten_replies: node and the emptied-rack / child / pass guards. |
| 0x0062 | `bne.b      $cc` | tighten_replies: node and the emptied-rack / child / pass guards. |
| 0x0064 | `tst.w      $4(a4)` | tighten_replies: node and the emptied-rack / child / pass guards. |
| 0x0068 | `bne.b      $cc` | tighten_replies: node and the emptied-rack / child / pass guards. |
| 0x006a | `tst.b      $1a(a4)` | tighten_replies: node and the emptied-rack / child / pass guards. |
| 0x006e | `beq.b      $cc` | tighten_replies: node and the emptied-rack / child / pass guards. |
| 0x0070 | `pea.l      $22.w` | tighten_replies: memset(s->best_empty_move, 0, sizeof s->best_empty_move). This write was missing before the VID fix. |
| 0x0074 | `pea.l      -$5a32(a5)` | tighten_replies: memset(s->best_empty_move, 0, sizeof s->best_empty_move). This write was missing before the VID fix. |
| 0x0078 | `jsr        $1aa(a5) ; CODE11+0c5c` | tighten_replies: memset(s->best_empty_move, 0, sizeof s->best_empty_move). This write was missing before the VID fix. |
| 0x007c | `movea.w    $2(a4), a0` | TightenContext.upper/lower initialized from node bounds. Original uses ranking scratch longs; C uses explicit context fields. |
| 0x0080 | `move.l     a0, -$5a00(a5)` | TightenContext.upper/lower initialized from node bounds. Original uses ranking scratch longs; C uses explicit context fields. |
| 0x0084 | `movea.w    (a4), a0` | TightenContext.upper/lower initialized from node bounds. Original uses ranking scratch longs; C uses explicit context fields. |
| 0x0086 | `move.l     a0, -$59de(a5)` | TightenContext.upper/lower initialized from node bounds. Original uses ranking scratch longs; C uses explicit context fields. |
| 0x008a | `move.b     $19(a4), d0` | node->kept_mask is the input to bound_local_reply via c.node. |
| 0x008e | `ext.w      d0` | node->kept_mask is the input to bound_local_reply via c.node. |
| 0x0090 | `move.w     d0, -$ada(a5)` | node->kept_mask is the input to bound_local_reply via c.node. |
| 0x0094 | `move.l     -$30d4(a5), (a7)` | local_replies(..., bound_local_reply, &c, workspace), including original node expansion and apply/generate/undo helper. |
| 0x0098 | `pea.l      $87a(a5)` | local_replies(..., bound_local_reply, &c, workspace), including original node expansion and apply/generate/undo helper. |
| 0x009c | `move.l     -$30d8(a5), -(a7)` | local_replies(..., bound_local_reply, &c, workspace), including original node expansion and apply/generate/undo helper. |
| 0x00a0 | `move.l     a4, -(a7)` | local_replies(..., bound_local_reply, &c, workspace), including original node expansion and apply/generate/undo helper. |
| 0x00a2 | `jsr        $4(pc)` | local_replies(..., bound_local_reply, &c, workspace), including original node expansion and apply/generate/undo helper. |
| 0x00a6 | `move.w     -$59fe(a5), $2(a4)` | node->upper/lower receive signed 16-bit narrowed c.upper/c.lower. |
| 0x00ac | `move.w     -$59dc(a5), (a4)` | node->upper/lower receive signed 16-bit narrowed c.upper/c.lower. |
| 0x00b0 | `tst.w      -$5a16(a5)` | c.best_empty sets node->leave_tag. Shared record bytes 28-29 mirror the flag. |
| 0x00b4 | `lea.l      $14(a7), a7` | c.best_empty sets node->leave_tag. Shared record bytes 28-29 mirror the flag. |
| 0x00b8 | `beq.b      $c0` | c.best_empty sets node->leave_tag. Shared record bytes 28-29 mirror the flag. |
| 0x00ba | `move.b     #$1, $1d(a4)` | c.best_empty sets node->leave_tag. Shared record bytes 28-29 mirror the flag. |
| 0x00c0 | `tst.l      -$5a1a(a5)` | c.any sets node->adjustment_tag. Shared record long at byte 24 mirrors it. |
| 0x00c4 | `beq.b      $cc` | c.any sets node->adjustment_tag. Shared record long at byte 24 mirrors it. |
| 0x00c6 | `move.b     #$1, $18(a4)` | c.any sets node->adjustment_tag. Shared record long at byte 24 mirrors it. |
| 0x00cc | `movea.l    (a7)+, a4` | Restore saved A4, frame and return: C function/loop lifetime; no reconstructed persistent state. |
| 0x00ce | `unlk       a6` | Restore saved A4, frame and return: C function/loop lifetime; no reconstructed persistent state. |
| 0x00d0 | `rts        ` | Restore saved A4, frame and return: C function/loop lifetime; no reconstructed persistent state. |
