#!/usr/bin/env python3
"""Inventory source-associated ranges without treating them as completion proof."""
import hashlib
import json
from pathlib import Path


UNITS=[
    (1,0x48,0xaa,'global_initializer.c','startup-repeat-live.json','Pure global operation; Toolbox resource acquisition external'),
    (1,0xee,0x124,'runtime_arithmetic.c','multiply-live-calls.json','Natural inputs only; guest ABI external'),
    (2,0xf4,0x138,'dictionary_setup.c','whole-file-caller-live.json','Natural dictionary load success with full CODE 2 identity; load-error transfer host-tested only'),
    (2,0x138,0x18a,'dictionary_tables.c','whole-file-caller-live.json','Natural roots/tables match C replay; staged data also exercised in wasm; diagnostic paths host-tested only'),
    (4,0x4,0x30,'rack_refill.c','rack-refill-live.json','All private-random returns and final seed match C in one natural refill; full loaded CODE4 identity checked'),
    (7,0x70,0xca,'history_initial.c',None,'Static tag-1 history restore branch; captured save payload host-tested; original restore globals not yet traced'),
    (7,0x278,0x2e6,'history_move.c',None,'Static tag-2 restore orchestration; recursive previous state, score/racks and helper order tested; move application external and natural restore pending'),
    (9,0xca2,0xd14,'text_filter.c','word-list-allowed-characters.json','ASCII-only static filter; saved allow-list strings; direct live filter trace pending'),
    (9,0xc5e,0xca2,'clipboard_sync.c',None,'Static scrap synchronization; import/export Toolbox wrappers external; natural trace pending'),
    (9,0x46c,0x4f0,'text_key.c',None,'Static insertion dispatch; navigation, quote memory access and Toolbox effects external'),
    (9,0x4f0,0x742,'arrow_navigation.c',None,'Static modifier and selection dispatch; callbacks retain dynamic selection; natural trace pending'),
    (9,0x3fe,0x46c,'word_navigation.c',None,'Static word-edge loop; lock and predicate memory access external; natural traces pending'),
    (11,0xd4c,0xda8,'segment_management.c','segment-unloads-live.json','Arguments/order verified; Toolbox effects external'),
    (12,0x38e,0x668,'word_enumerator.c','word-enumerator-live-summary.json','Four natural enumerations: 149 emissions and final workspaces match; setup/UI storage/error paths external'),
    (12,0x686,0x6f6,'dialog_text_filter.c','word-list-allowed-characters.json','Static event-then-six-fields orchestration; dispatch and Toolbox adapters external'),
    (12,0x82e,0x894,'word_length_controls.c','length-controls-live-summary.json','Three natural caller outcomes and six decimal calls match; field extraction external; additional parser paths pending'),
    (15,4,0xd2,'index_file.c',None,'Static only; no direct caller identified'),
    (15,0x198,0x1c8,'dictionary_lookup.c',None,'Counted wrapper; original call trace pending'),
    (15,0x1c8,0x23e,'dictionary_lookup.c','dictionary-live-calls.json','Ten natural section-0 calls match; section 1/exhaustive validation pending; unreachable +0x232 not assigned behavior'),
    (15,0x23e,0x276,'dictionary_lookup.c',None,'Terminated wrapper; original call trace pending'),
    (15,0xd4c,0xdf4,'file_access_check.c','file-check-live.json','Success path verified; error paths pending'),
    (23,0x1be,0x1fe,'character_normalization.c','character-table-fingerprint.json','Static wrapper with saved runtime table; natural calls pending'),
    (23,0x17a,0x1be,'pascal_string.c',None,'Static historical Pascal mismatch; final character skipped and signed length retained; live confirmation pending'),
    (20,0x7ee,0x82e,'drawing_text_size.c','inline-switch-candidates.json','Static TextSize selection; source structure and natural calls pending; table excluded'),
    (22,0x200,0x28e,'save_record.c','save-new-game-live.json','Natural three-record save inputs/results and tag-1 restoration; C replay matches all writes; error/large-size paths host-tested only'),
    (16,0x4,0x14c,'move_statistics.c',None,'Static22-long accumulation and selective signed normalization; host rounding/field/alias tests; not move ranking'),
    (35,0x3d8,0x6a6,'premium_exposure.c','premium-exposure-live.json','Two original pre-application penalties0 and-20 match C with actual20-record table'),
    (35,0xa48,0xcd0,'pattern_match.c','pattern-match-traced-live.json','Original total, contributing rack record and all128 restored counts match; board/blank/Q branches host-tested only'),
    (35,0x4,0x34,'evaluation_features.c',None,'Static record flag-set predicate excludes ID0; not complement of flag-clear; host tests'),
    (31,0x4,0x78,'board_state.c',None,'Static count-new-tiles and left-neighbor word-start scan; valid-sentinel host tests; natural calls pending'),
    (31,0x78,0x128,'board_state.c',None,'Static cross-orientation coordinates, occupied-byte scan and end predicates; boundary tests, natural game-end trace pending'),
    (31,0x1b4,0x266,'evaluation_features.c','evaluation-features-live.json','All22 features match C for a natural evaluated candidate using post-collector counts; record collection external'),
    (31,0x534,0x63a,'evaluation_features.c','evaluation-features-live.json','Natural candidate feature-vector replay matches all22 longs with seven collected records; unexercised rare/bingo/stage cases host-only'),
    (35,0x34,0x64,'evaluation_features.c','evaluation-features-live.json','Predicate range verified despite FP rewrites elsewhere in CODE35; natural seven-record feature sum matches C'),
    (31,0x184,0x1a6,'apply_move.c','apply-move-replay.json','Non-evaluation orchestration only; split natural score and restored-state captures, not direct call-boundary trace'),
    (31,0x266,0x2f0,'apply_move.c','apply-move-replay.json','Non-evaluation row-zero/score prelude; normal move combined replay matches, row-zero/callback host-tested'),
    (31,0x2f0,0x456,'place_letters.c','game-restore-live.json','Placement-only C replay matches full board/value arrays and undo prefix for naturally reopened AORTAE game; premium special score and surrounding score/refill/cleanup remain unvalidated'),
    (31,0x456,0x4f6,'move_finalize.c',None,'Static paired recorded-value clearing; host sentinel tests in both orientations; natural recorded coordinates pending'),
    (31,0x4f6,0x52a,'move_finalize.c','game-restore-live.json','C replay matches complete natural undo workspace for AORTAE; residual rack i precedes still-unreconstructed refill'),
    (31,0x642,0x71e,'undo_move.c','move-undo-live.json','Natural engine undo full board/value/rack/workspace/counter match C; count table unchanged; row-zero path host-tested only'),
    (31,0x71e,0x75c,'rack_counts.c',None,'Static rack materialization in alphabet order with signed-byte count behavior; natural call trace pending'),
    (31,0x75c,0x7e0,'remaining_tiles.c',None,'Static one-rack unseen counts, linear primary scan and negative-byte clamp; host tests only'),
    (31,0x7f4,0x8b4,'rack_refill.c','rack-refill-live.json','Natural refill C replay matches 16 events, rack, board and bag workspace using observed clock/Toolbox inputs; small-bag stack-ticks branch not runtime verified'),
    (31,0x8be,0x992,'remaining_tiles.c','rack-refill-live.json','All 86 emitted bag bytes match natural capture using original distribution/board/values/racks/alphabet; blank and wrap branches host-tested only'),
    (31,0x992,0x9d2,'rack_counts.c','rack-alphabet-snapshot.json','Static alphabet-scoped byte counts; alphabet verified in old snapshot, not live call capture'),
    (32,0x4,0x32,'score_move.c','move-score-live.json','Natural nonzero-row scoring capture; row-zero early-return host-tested only'),
    (32,0x32,0x352,'score_accumulate.c','move-score-live.json','Natural AORTAE score1400, six new tiles and remaining rack i match complete scorer replay; blank branches also verified through constructed saves; cross/bingo branches host-tested only'),
    (32,0x352,0x650,'score_move.c','move-score-live.json','Natural no-new-blank path score/rack/coordinates match C; one/two blank selection also verified through three constructed saved-game fixtures; cross-word and other contexts pending'),
    (32,0x650,0x6a2,'rack_masks.c',None,'Static mask-to-rack conversion; host tests preserve signed32 intersection and diagnostic continuation'),
    (32,0x6a2,0x7c0,'cross_word_possible.c',None,'Static crossing-word search; host tests verify query order, early return, temporary paired-cell writes and cleanup'),
    (32,0x7c0,0x824,'rack_masks.c',None,'Static diagnostic wrapper and descending signed-word binary search; host tests only'),
    (32,0xc00,0xdb0,'rack_balance.c',None,'Static cached baseline difference and one/two blank composition policies; CODE32+0xdb0 computation external; host tests only'),
    (32,0xdb0,0xefa,'rack_composition.c','rack-composition-baseline-live.json','Two natural calls match C: terminal case -713 and full baseline recurrence -49; exact executed range verified; original table initialization external'),
    (32,0x140a,0x164c,'letter_expectation.c','letter-expectation-live.json','Exact-integer mathematical port matches24 original SANE results in native and wasm; executed range matches prior FP-rewrite fingerprint; valid precision/domain limitations documented'),
    (32,0x164c,0x16c0,'adjusted_pattern_lookup.c',None,'Static single-letter current-pool minus96-tile baseline wrapper; underlying lookup and expectation separately runtime-verified; composite host tests preserve word wrap and pointer semantics'),
    (32,0x16c0,0x1872,'pattern_cache.c','pattern-cache-live.json','Original construction from2263 records matches all125 entries; host tests cover diagnostics and reuse'),
    (32,0x1872,0x18e4,'pattern_lookup.c','pattern-lookup-live.json','64 original lookups match scores and mutable-entry identity;28 hits and36 misses'),
    (32,0x18e4,0x1944,'mask_supersets.c',None,'Static recursive OR-mask updates with generation deduplication; host membership/wrap/duplicate-mask tests'),
    (34,0x20,0x3a,'pascal_string.c',None,'Static in-place Pascal-to-C conversion; all byte lengths tested; natural calls pending'),
    (34,0x4ce,0x54a,'scrap_transfer.c',None,'Static TEXT import/export wrappers; Memory/Scrap Manager effects external; natural calls pending'),
    (47,0x5a,0xd0,'file_metadata.c',None,'Static timestamp and physical fork-size helpers; original big-endian parameter block preserved; Toolbox adapter and natural captures pending'),
    (47,0xd0,0x12c,'volume_lookup.c',None,'Static synchronous volume enumeration using original mismatch helper; live parameter blocks pending'),
    (47,0x12c,0x1da,'file_open.c',None,'Static open/truncate/create/retry; original error precedence and explicit scratch Finder bytes; natural save capture pending'),
    (47,0x25c,0x2ee,'whole_file.c','whole-file-live.json','Natural startup success: loaded CODE 47 identity, all six operation results, full data hash and trailing NUL; error paths host-tested only'),
    (48,0x138,0x182,'dialog_text_filter.c',None,'Static filter wrapper; real reconstructed filter, Toolbox read/beep/rewrite adapters; natural trace pending'),
    (48,0x376,0x446,'dialog_key_event.c',None,'Static Return/Enter/Tab dispatch; external Toolbox actions and text-key helper; natural trace pending'),
    (52,0x15e,0x186,'character_normalization.c','character-table-fingerprint.json','Static 16-bit conversion; complete saved table matches THINK 5/6 sources; natural calls pending'),
]

# Search recovery added during the September9 move-generation run. These
# boundaries associate source with instructions, not blanket path coverage.
UNITS += [
 (3,0x4,0x154,'candidate_ranking.c','candidate-sampled-live.json','Sampled average/sort only; display omitted; original eligibility supplied'),
 (3,0x1a2,0x1de,'candidate_ranking.c',None,'Strict best-move replacement; exercised as search composition'),
 (3,0x1de,0x1fa,'search_dispatch.c','rollout-exhaustive-live-01.json','Selected-rack count setup; all three modes accepted in full captured simulation batches'),
 (3,0x1fa,0x242,'search_policy.c','rollout-exhaustive-live-01.json','Mixed byte/word selection policy; all three paths accepted in simulation; host boundary tests'),
 (3,0x242,0x268,'search_dispatch.c','rollout-exhaustive-live-01.json','Engine invocation and first-record selection; native/wasm heuristic,late and endgame simulation accepted'),
 (3,0xc8e,0xccc,'simulation_restore.c','simulation-cancel-live.json','Position snapshot saved in original session frame; subsequent restoration accepted; native snapshot constructed from captured saved state'),
 (3,0xd86,0xdc4,'simulation_restore.c','simulation-cancel-live.json','Original Escape restores altered board,values,rack strings and selection; cache rebuild captured separately'),
 (3,0x66a,0x672,'simulation_restore.c',None,'Signed first-entry weight limit comparison; static boundary checks, normal original limit exit not yet captured'),
 (3,0x1072,0x108c,'simulation_search.c','rollout-batch-live.json','Raw candidate copy and static-rank accumulator seed matches two original first-batch configurations'),
 (3,0xd04,0xd44,'simulation_search.c','opponent-samples-live.json','Finite exhaustive scheduling and final publication only; infinite sampling, longjmp and post-session cache rebuild excluded'),
 (3,0x2c6,0x66a,'rollout_search.c','rollout-batch-refills-live.json','Two standalone batches and five continuous exhaustive batches;450 state checkpoints and150 computed refills; external random/clock events supplied'),
 (27,0x26,0x14c,'reply_bounds.c','reply-bounds-live.json','Three original candidate bounds calls and full endgame integration'),
 (27,0x1d4,0x29a,'endgame_move_cache.c','endgame-generation-live.json','Original reply summaries and linked traversal'),
 (28,0x4,0xea,'candidate_ranking.c','candidate-top10-filter-live.json','Top-ten insertion/eligibility and natural complete searches'),
 (28,0x11a,0x29c,'heuristic_search.c','heuristic-search-live.json','Three complete original searches; native and wasm'),
 (29,0x2c,0x2b2,'endgame_leaf.c','endgame-leaf-live.json.gz','Reply/continuation tightening and full endgame fixture'),
 (30,0x14e,0x34c,'endgame_search.c','endgame-search-live.json.gz','Normal main solver setup/iteration; one six-iteration complete native/wasm fixture'),
 (30,0x34c,0x40e,'endgame_tree.c','endgame-search-live.json.gz','All six original frontier choices'),
 (30,0x45a,0x4c4,'endgame_tree.c','endgame-search-live.json.gz','Normal continuation checks; broader budget/reserve paths pending'),
 (30,0x72e,0x7a4,'endgame_tree.c','endgame-tree-live.json.gz','Hash lookup primitives and full solver'),
 (30,0x7a4,0x7f2,'endgame_tree.c','endgame-tree-live.json.gz','Pass insertion primitive; original broader pass coverage pending'),
 (30,0x7fc,0x8be,'endgame_tree.c','endgame-search-live.json.gz','Position reuse computational path; hash words supplied'),
 (30,0xc22,0xd66,'endgame_tree.c','endgame-search-live.json.gz','Compact node creation and move expansion'),
 (32,0x824,0x8bc,'rack_masks.c','late-search-q16-live.json.gz','Original full-pool and own-rack occurrences integrated'),
 (32,0x8bc,0xc00,'leave_table.c','late-leave-table-live.json','Preparation plus alternate late leave table; all words/stamps/cache match'),
 (32,0xefa,0x115c,'leave_table.c','leave-table-live.json','Complete heuristic leaves; final all128 entries and cache state'),
 (32,0x115c,0x1304,'rack_masks.c','endgame-generation-live.json','Canonical masks/points and search residual-mask conversion'),
 (32,0x1304,0x140a,'exchange_candidates.c','exchange-generator-live.json','96 original exchange records; complete late search also computes lookups'),
 (35,0x36c,0x3d8,'move_evaluation.c','move-evaluation-live.json','Collector orchestration prelude;16 complete natural calls'),
 (35,0x6a6,0xa48,'move_evaluation.c','move-evaluation-live.json','Collector post-premium body;16 complete natural calls'),
 (36,0x4,0x91e,'late_pool_select.c','late-pool-live.json.gz','Initial/merge/local reply collection; complete16-tile search integration'),
 (36,0x91e,0x113a,'late_reply_value.c','late-search-q16-live.json.gz','Full valuation including small/large unseen-Q paths; blank coverage still extending'),
 (36,0x113a,0x133a,'late_ranking.c','late-ranking-live.json.gz','16 original calls plus complete late searches'),
 (36,0x133a,0x14d0,'late_pool_select.c','late-pool-live.json.gz','Remaining leave and reply matching/promotion'),
 (36,0x14d0,0x1642,'late_preparation.c','late-preparation-live.json.gz','90 original board-pattern application checkpoints plus complete search'),
 (36,0x1642,0x1810,'late_setup.c','late-search-q16-live.json.gz','Used tiles, constraint masks/weights/lists; full search'),
 (36,0x1810,0x1842,'late_search.c','late-search-q16-live.json.gz','Entry rack/unseen preparation; force0 CPU calibration external'),
 (36,0x1842,0x189a,'late_search_budget.c',None,'Static CPU-calibrated workload gate; not a memory fallback; original decision and integration pending'),
 (36,0x189a,0x2392,'late_search.c','late-search-q16-live.json.gz','Computational normal search including exchanges/Q, 30 checkpoints'),
 (37,0x24e,0x36c,'opening_placements.c','opening-scored-generator-live.json','Opening dictionary placements with blank'),
 (37,0x36c,0x4da,'cross_check_letters.c','board-generator-live.json','Prefix and cross checks integrated with original generator streams'),
 (37,0x4da,0x764,'local_replies.c','late-local-live.json.gz','Original local influence masks and apply/enumerate/undo'),
 (37,0x7b6,0xe46,'board_placements.c','board-generator-live.json','Occupied-board traversal; source algorithm omits prefix-score optimization'),
 (37,0xe46,0x1356,'board_moves.c','late-search-q16-live.json.gz','Computational evaluator replaced with shared equivalent scorer; transient optimized scratch not represented'),
 (37,0x1356,0x14e4,'board_placements.c','board-generator-live.json','Recursive left/right dictionary traversal'),
 (38,0x12,0x22,'random_opponent.c','opponent-random-draw-02-live.json','Natural rack clears/bag/refill matches native; connected draw to complete batch and ranking matches native/wasm with continuous private RNG'),
 (38,0x46,0x17a,'opponent_samples.c','opponent-samples-live.json','One full original eight-unseen enumeration: five ordered racks and multiplicities; also composed in native/wasm full finite simulation'),
 (39,0x4,0x190,'endgame_rack_bounds.c','local-score-corrections-live.json','Original local score corrections'),
 (39,0x1cc,0x512,'endgame_rack_bounds.c','endgame-table-full-preparation-live.json','Full original depth tables'),
 (39,0x51a,0x6fc,'endgame_rack_bounds.c','endgame-rack-bounds-live.json','Original one/two-rack bounds lookups'),
 (40,0x4,0x9c,'endgame_move_cache.c','endgame-generation-live.json','Original generated move cache updates'),
 (40,0x9c,0x114,'endgame_generation.c','endgame-generation-live.json','Two-rack preparation orchestration'),
 (42,0x4,0x2e2,'pool_weights.c','late-pool-live.json.gz','61 natural weight calls and independent physical-subset oracle'),
 (43,0xba,0x314,'endgame_rack_bounds.c','endgame-table-full-preparation-live.json','Original missing-letter/blank score propagation'),
 (43,0x314,0x5d2,'reply_bounds.c','endgame-generation-live.json','Original conflict matrix; complete endgame and late searches'),
 (44,0x84,0x1ac,'candidate_ranking.c','candidate-top10-eligibility-live.json','Word deduplication, removal and orientation eligibility'),
 (45,0x4,0x42a,'endgame_leaf.c','endgame-leaf-live.json.gz','Original leaf generation, bound tags and tightening; complete solver'),
 (45,0x42a,0x466,'endgame_generation.c','endgame-generation-live.json','Shared generator preparation'),
 (53,0x36,0x6e,'endgame_tree.c','endgame-search-live.json.gz','Hash arithmetic with original initialized random table'),
]


def main():
    records=[]
    for p in sorted(Path('resources/CODE').glob('*.bin'),key=lambda p:int(p.stem.split('_')[0])):
        rid=int(p.stem.split('_')[0]);data=p.read_bytes();ranges=[];occupied=set()
        for segment,start,end,source,evidence,scope in UNITS:
            if segment!=rid:continue
            assert 4<=start<end<=len(data)
            assert not occupied.intersection(range(start,end))
            occupied.update(range(start,end))
            assert (Path('reconstruction')/source).is_file()
            if evidence:assert (Path('analysis/toolchain')/evidence).is_file()
            ranges.append(dict(start=start,end_exclusive=end,source=source,
                               original_runtime_evidence=evidence,scope=scope))
        records.append(dict(code_resource=rid,resource_bytes=len(data),
                            sha256=hashlib.sha256(data).hexdigest(),source_associated_ranges=ranges))
    print(json.dumps(dict(scope='Ranges identify work, not verified or complete byte coverage. Resources include data and metadata.',
                         resource_count=len(records),resource_bytes=sum(r['resource_bytes'] for r in records),
                         source_associated_range_bytes=sum(end-start for _,start,end,_,_,_ in UNITS),
                         full_application_rebuild=False,full_game_validation=False,
                         inline_error_context='Separate shared reconstruction; site-by-site runtime validation pending',
                         resources=records),indent=2))


if __name__=='__main__':
    main()
