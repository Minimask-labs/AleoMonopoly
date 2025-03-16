import credits.aleo;
import staking_v1.aleo;
program aleo_monopoly_test03.aleo;

struct Settings:
    unstake_wait as u32;
    stake_paused as boolean;
    global_paused as boolean;
    max_reward_per_notify as u64;
    protocol_fee as u16;
    fee_account as address;

record Buildings:
    owner as address.private;
    amount as u64.private;
    buildings as u64.private;

struct TokenInfo:
    name as field;
    symbol as field;
    decimals as u8;
    circulating_supply as u64;
    total_supply as u64;
    testers as u64;
    admin as address;

struct TestToken:
    name as field;
    symbol as field;
    decimals as u8;
    circulating_supply as u64;
    total_supply as u64;
    admin as address;

struct BuildingInfo:
    building_id as field;
    receiver as address;
    building_price as u64;
    total_building as u64;

struct GlobalState:
    next_token_id as field;
    admin as address;

struct Versus:
    game_id as field;
    player as address;
    game_begins as boolean;
    player_goal as u64;
    max_game as u8;

struct Track:
    roll_count as u64;
    versus_count as u64;

struct MonoNFT:
    player as address;
    id as field;
    name as u64;
    owned as boolean;
    date as u128;

mapping account:
    key as address.public;
    value as u64.public;

mapping tokens:
    key as u64.public;
    value as TokenInfo.public;

mapping test_token:
    key as u64.public;
    value as TestToken.public;

mapping unique_building:
    key as address.public;
    value as BuildingInfo.public;

mapping global_state:
    key as boolean.public;
    value as GlobalState.public;

mapping versus_player:
    key as address.public;
    value as Versus.public;

mapping track_player:
    key as address.public;
    value as Track.public;

mapping nft_holder:
    key as field.public;
    value as MonoNFT.public;

function init:
    input r0 as boolean.private;
    async init aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m into r1;
    output self.caller as address.private;
    output r1 as aleo_monopoly_test03.aleo/init.future;

finalize init:
    input r0 as address.public;
    cast 0field aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m into r1 as GlobalState;
    get.or_use global_state[true] r1 into r2;
    assert.eq r2.next_token_id 0field;
    assert.eq r0 r2.admin;
    cast 1field r2.admin into r3 as GlobalState;
    set r3 into global_state[true];
    get.or_use account[r0] 0u64 into r4;
    is.eq r4 0u64 into r5;
    assert.eq r5 true;
    add r4 60000000u64 into r6;
    set r6 into account[r0];
    add 0u64 60000000u64 into r7;
    cast 4577111110111112111108121field 4577111110111112111108121field 6u8 r7 15000000000000u64 r2.admin into r8 as TestToken;
    set r8 into test_token[15000000000000u64];

function change_admin:
    input r0 as address.private;
    async change_admin r0 into r1;
    output self.caller as address.private;
    output r1 as aleo_monopoly_test03.aleo/change_admin.future;

finalize change_admin:
    input r0 as address.public;
    get global_state[true] into r1;
    assert.eq r0 r1.admin;
    cast r1.next_token_id r0 into r2 as GlobalState;
    set r2 into global_state[true];

function issue:
    input r0 as address.private;
    input r1 as u64.private;
    async issue r0 r1 into r2;
    output r0 as address.private;
    output r1 as u64.private;
    output r2 as aleo_monopoly_test03.aleo/issue.future;

finalize issue:
    input r0 as address.public;
    input r1 as u64.public;
    cast 0field aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m into r2 as GlobalState;
    get.or_use global_state[true] r2 into r3;
    is.eq r3.next_token_id 1field into r4;
    assert.eq r4 true;
    cast 4577111110111112111108121field 4577111110111112111108121field 6u8 0u64 15000000000000u64 r3.admin into r5 as TestToken;
    get.or_use test_token[15000000000000u64] r5 into r6;
    get.or_use account[r0] 0u64 into r7;
    add r6.circulating_supply r1 into r8;
    lte r8 r6.total_supply into r9;
    assert.eq r9 true;
    is.eq r1 10000u64 into r10;
    assert.eq r10 true;
    cast r6.name r6.symbol r6.decimals r8 r6.total_supply r3.admin into r11 as TestToken;
    set r11 into test_token[15000000000000u64];
    is.eq r7 0u64 into r12;
    assert.eq r12 true;
    add r7 r1 into r13;
    set r13 into account[r0];

function monopoly_buy:
    input r0 as address.private;
    input r1 as u64.private;
    sub r1 5000u64 into r2;
    cast r0 r2 1u64 into r3 as Buildings.record;
    async monopoly_buy r0 5000u64 1u64 into r4;
    output r3 as Buildings.record;
    output 5000u64 as u64.private;
    output r4 as aleo_monopoly_test03.aleo/monopoly_buy.future;

finalize monopoly_buy:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u64.public;
    get.or_use account[r0] 0u64 into r3;
    gt r3 0u64 into r4;
    assert.eq r4 true;
    rand.chacha into r5 as field;
    cast r5 r0 r1 0u64 into r6 as BuildingInfo;
    get.or_use unique_building[r0] r6 into r7;
    get.or_use account[r0] 0u64 into r8;
    sub r8 r7.building_price into r9;
    set r9 into account[r0];
    gt r8 r7.building_price into r10;
    assert.eq r10 true;
    is.eq r7.receiver r0 into r11;
    assert.eq r11 true;
    gte r7.total_building 0u64 into r12;
    assert.eq r12 true;
    add r7.building_price 500u64 into r13;
    add r7.total_building r2 into r14;
    cast r7.building_id r7.receiver r13 r14 into r15 as BuildingInfo;
    set r15 into unique_building[r0];

function monopoly_rent:
    input r0 as address.private;
    input r1 as u64.private;
    input r2 as u64.private;
    cast r0 r1 r2 into r3 as Buildings.record;
    async monopoly_rent r0 150u64 into r4;
    output r3 as Buildings.record;
    output 150u64 as u64.private;
    output r4 as aleo_monopoly_test03.aleo/monopoly_rent.future;

finalize monopoly_rent:
    input r0 as address.public;
    input r1 as u64.public;
    cast 123field r0 0u64 0u64 into r2 as BuildingInfo;
    get.or_use unique_building[r0] r2 into r3;
    is.eq r3.receiver r0 into r4;
    assert.eq r4 true;
    gte r3.total_building 1u64 into r5;
    assert.eq r5 true;
    get.or_use account[r0] 0u64 into r6;
    gt r6 0u64 into r7;
    assert.eq r7 true;
    get.or_use account[r0] 0u64 into r8;
    rand.chacha into r9 as u64;
    gt 9223372036854775808u64 r9 into r10;
    mul r3.total_building 150u64 into r11;
    add r8 r11 into r12;
    mul r3.total_building 150u64 into r13;
    sub r8 r13 into r14;
    ternary r10 r12 r14 into r15;
    set r15 into account[r0];
    get.or_use staking_v1.aleo/account[r0] 0u64 into r16;
    gte r16 5000000u64 into r17;
    add r8 100u64 into r18;
    add r8 0u64 into r19;
    ternary r17 r18 r19 into r20;
    set r20 into account[r0];
    cast 0u64 0u64 into r21 as Track;
    get.or_use track_player[r0] r21 into r22;
    add r22.roll_count 1u64 into r23;
    cast r23 0u64 into r24 as Track;
    set r24 into track_player[r0];

function monopoly_sale:
    input r0 as address.private;
    input r1 as address.private;
    async monopoly_sale r0 r1 into r2;
    output r0 as address.private;
    output r1 as address.private;
    output r2 as aleo_monopoly_test03.aleo/monopoly_sale.future;

finalize monopoly_sale:
    input r0 as address.public;
    input r1 as address.public;
    cast 123field r0 0u64 0u64 into r2 as BuildingInfo;
    get.or_use unique_building[r0] r2 into r3;
    is.eq r3.receiver r0 into r4;
    assert.eq r4 true;
    gte r3.total_building 1u64 into r5;
    assert.eq r5 true;
    get.or_use account[r0] 0u64 into r6;
    gt r6 0u64 into r7;
    assert.eq r7 true;
    get.or_use account[r1] 0u64 into r8;
    gte r8 5000u64 into r9;
    assert.eq r9 true;
    assert.eq r1 aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m;
    get.or_use account[r1] 0u64 into r10;
    mul r3.total_building r3.building_price into r11;
    mul r3.total_building 1000u64 into r12;
    sub r11 r12 into r13;
    sub r10 r13 into r14;
    set r14 into account[r1];
    get.or_use account[r0] 0u64 into r15;
    mul r3.total_building r3.building_price into r16;
    sub r16 1000u64 into r17;
    add r15 r17 into r18;
    set r18 into account[r0];
    lte r3.total_building r3.total_building into r19;
    assert.eq r19 true;
    mul r3.total_building 600u64 into r20;
    sub r3.building_price r20 into r21;
    sub r3.total_building r3.total_building into r22;
    cast r3.building_id r0 r21 r22 into r23 as BuildingInfo;
    set r23 into unique_building[r0];
    add r3.total_building r3.total_building into r24;
    gte r24 r3.total_building into r25;
    assert.eq r25 true;
    cast r3.building_id r1 r3.building_price r24 into r26 as BuildingInfo;
    set r26 into unique_building[r1];
    remove unique_building[r0];

function mint_nft:
    input r0 as address.private;
    input r1 as u64.private;
    input r2 as field.private;
    input r3 as u128.private;
    is.eq r0 self.caller into r4;
    assert.eq r4 true;
    async mint_nft r0 r1 r2 r3 into r5;
    output r5 as aleo_monopoly_test03.aleo/mint_nft.future;

finalize mint_nft:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as field.public;
    input r3 as u128.public;
    cast r0 r2 r1 false r3 into r4 as MonoNFT;
    get.or_use nft_holder[r2] r4 into r5;
    is.eq r5.owned false into r6;
    is.eq r5.id r2 into r7;
    and r6 r7 into r8;
    assert.eq r8 true;
    is.neq r5.player r0 into r9;
    assert.eq r9 true;
    cast r0 r2 r1 true r3 into r10 as MonoNFT;
    set r10 into nft_holder[r2];

function play_request:
    input r0 as address.private;
    input r1 as address.private;
    async play_request r0 r1 into r2;
    output r2 as aleo_monopoly_test03.aleo/play_request.future;

finalize play_request:
    input r0 as address.public;
    input r1 as address.public;
    cast 123field r0 false 0u64 0u8 into r2 as Versus;
    get.or_use versus_player[r0] r2 into r3;
    assert.neq r0 r1;
    assert.eq r3.max_game 0u8;
    get.or_use account[r0] 0u64 into r4;
    get.or_use account[r1] 0u64 into r5;
    gte r4 1000u64 into r6;
    assert.eq r6 true;
    gte r5 1000u64 into r7;
    assert.eq r7 true;
    hash.keccak512 r0 into r8 as field;
    hash.keccak512 r1 into r9 as field;
    add r8 r9 into r10;
    cast r10 r0 false 0u64 0u8 into r11 as Versus;
    set r11 into versus_player[r0];
    cast r10 r1 false 0u64 0u8 into r12 as Versus;
    set r12 into versus_player[r1];

function accept_request:
    input r0 as address.private;
    input r1 as address.private;
    async accept_request self.caller r1 into r2;
    output r2 as aleo_monopoly_test03.aleo/accept_request.future;

finalize accept_request:
    input r0 as address.public;
    input r1 as address.public;
    hash.keccak512 r0 into r2 as field;
    hash.keccak512 r1 into r3 as field;
    add r2 r3 into r4;
    cast r4 r0 false 0u64 0u8 into r5 as Versus;
    get.or_use versus_player[r0] r5 into r6;
    cast r4 r1 false 0u64 0u8 into r7 as Versus;
    get.or_use versus_player[r1] r7 into r8;
    assert.neq r0 r1;
    is.eq r6.max_game 0u8 into r9;
    is.eq r8.max_game 0u8 into r10;
    and r9 r10 into r11;
    assert.eq r11 true;
    get.or_use account[r0] 0u64 into r12;
    get.or_use account[r1] 0u64 into r13;
    gte r12 1000u64 into r14;
    assert.eq r14 true;
    gte r13 1000u64 into r15;
    assert.eq r15 true;
    add r12 400u64 into r16;
    add r13 400u64 into r17;
    is.eq r4 r6.game_id into r18;
    is.eq r4 r8.game_id into r19;
    and r18 r19 into r20;
    assert.eq r20 true;
    assert.eq r6.game_begins false;
    cast r4 r0 true r16 1u8 into r21 as Versus;
    set r21 into versus_player[r0];
    cast r4 r1 true r17 1u8 into r22 as Versus;
    set r22 into versus_player[r1];
    cast 0u64 0u64 into r23 as Track;
    get.or_use track_player[r0] r23 into r24;
    add r24.versus_count 1u64 into r25;
    cast r24.roll_count r25 into r26 as Track;
    set r26 into track_player[r0];

function check_request:
    input r0 as address.private;
    input r1 as address.private;
    async check_request self.caller r1 into r2;
    output r2 as aleo_monopoly_test03.aleo/check_request.future;

finalize check_request:
    input r0 as address.public;
    input r1 as address.public;
    hash.keccak512 r0 into r2 as field;
    hash.keccak512 r1 into r3 as field;
    add r2 r3 into r4;
    cast r4 r0 false 0u64 0u8 into r5 as Versus;
    get.or_use versus_player[r0] r5 into r6;
    cast r4 r0 false 0u64 0u8 into r7 as Versus;
    get.or_use versus_player[r1] r7 into r8;
    get.or_use account[r0] 0u64 into r9;
    gte r9 1000u64 into r10;
    assert.eq r10 true;
    assert.eq r6.max_game 1u8;
    is.eq r4 r6.game_id into r11;
    is.eq r4 r8.game_id into r12;
    and r11 r12 into r13;
    assert.eq r13 true;
    is.eq r6.game_begins true into r14;
    is.eq r8.game_begins true into r15;
    and r14 r15 into r16;
    assert.eq r16 true;
    is.eq r0 r6.player into r17;
    is.eq r0 r6.player into r18;
    or r17 r18 into r19;
    assert.eq r19 true;
    gte r9 r6.player_goal into r20;
    assert.eq r20 true;
    gte r9 r6.player_goal into r21;
    add r9 1000u64 into r22;
    add r9 0u64 into r23;
    ternary r21 r22 r23 into r24;
    set r24 into account[r0];
    remove versus_player[r6.player];
    remove versus_player[r8.player];

function send_token:
    input r0 as address.private;
    input r1 as address.private;
    input r2 as u64.private;
    async send_token r0 r1 r2 into r3;
    output r2 as u64.private;
    output r3 as aleo_monopoly_test03.aleo/send_token.future;

finalize send_token:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    assert.eq r0 aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m;
    get.or_use account[r0] 0u64 into r3;
    get.or_use account[r1] 0u64 into r4;
    gte r3 r2 into r5;
    assert.eq r5 true;
    cast 123field r1 0u64 0u64 into r6 as BuildingInfo;
    get.or_use unique_building[r1] r6 into r7;
    gte r7.total_building 1u64 into r8;
    assert.eq r8 true;
    sub r3 r2 into r9;
    set r9 into account[r0];
    add r4 r2 into r10;
    set r10 into account[r1];
