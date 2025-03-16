import credits.aleo;

program staking_v1.aleo;

record PrivateToken:
    owner as address.private;
    amount as u64.private;

struct Metadata:
    name as u128;
    symbol as u128;
    decimals as u8;

struct State:
    total_supply as u64;
    total_reserve as u64;
    total_unstaking as u64;
    total_reward as u64;

struct Settings:
    unstake_wait as u32;
    stake_paused as boolean;
    global_paused as boolean;
    max_reward_per_notify as u64;
    protocol_fee as u16;
    fee_account as address;

struct Unstaking:
    microcredits as u64;
    height as u32;

struct ApprovalKey:
    approver as address;
    spender as address;

mapping account:
    key as address.public;
    value as u64.public;

mapping approvals:
    key as field.public;
    value as u64.public;

mapping metadata:
    key as boolean.public;
    value as Metadata.public;

mapping state:
    key as boolean.public;
    value as State.public;

mapping settings:
    key as boolean.public;
    value as Settings.public;

mapping unstakings:
    key as address.public;
    value as Unstaking.public;

mapping admins:
    key as address.public;
    value as boolean.public;

mapping stakers:
    key as address.public;
    value as boolean.public;

function transfer_public:
    input r0 as address.public;
    input r1 as u64.public;
    async transfer_public self.caller r0 r1 into r2;
    output r2 as staking_v1.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get account[r0] into r3;
    sub r3 r2 into r4;
    set r4 into account[r0];
    get.or_use account[r1] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into account[r1];

function transfer_private:
    input r0 as PrivateToken.record;
    input r1 as address.private;
    input r2 as u64.private;
    cast r1 r2 into r3 as PrivateToken.record;
    sub r0.amount r2 into r4;
    cast r0.owner r4 into r5 as PrivateToken.record;
    output r3 as PrivateToken.record;
    output r5 as PrivateToken.record;

function transfer_private_to_public:
    input r0 as PrivateToken.record;
    input r1 as address.public;
    input r2 as u64.public;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as PrivateToken.record;
    async transfer_private_to_public r1 r2 into r5;
    output r4 as PrivateToken.record;
    output r5 as staking_v1.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];

function transfer_public_to_private:
    input r0 as address.private;
    input r1 as u64.public;
    cast r0 r1 into r2 as PrivateToken.record;
    async transfer_public_to_private self.caller r1 into r3;
    output r2 as PrivateToken.record;
    output r3 as staking_v1.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as address.public;
    input r1 as u64.public;
    get account[r0] into r2;
    sub r2 r1 into r3;
    set r3 into account[r0];

function join:
    input r0 as PrivateToken.record;
    input r1 as PrivateToken.record;
    add r0.amount r1.amount into r2;
    cast r0.owner r2 into r3 as PrivateToken.record;
    output r3 as PrivateToken.record;

function stake_public:
    input r0 as u64.public;
    input r1 as address.public;
    assert.neq r0 0u64 ;
    call credits.aleo/transfer_public_as_signer staking_v1.aleo r0 into r2;
    async stake_public r0 r1 r2 into r3;
    output r3 as staking_v1.aleo/stake_public.future;

finalize stake_public:
    input r0 as u64.public;
    input r1 as address.public;
    input r2 as credits.aleo/transfer_public_as_signer.future;
    await r2;
    get settings[true] into r3;
    assert.eq r3.stake_paused false ;
    assert.eq r3.global_paused false ;
    get state[true] into r4;
    is.eq r4.total_reserve 0u64 into r5;
    cast r4.total_reserve into r6 as u128;
    ternary r5 1u128 r6 into r7;
    is.eq r4.total_reserve 0u64 into r8;
    cast r0 into r9 as u128;
    cast r4.total_supply into r10 as u128;
    mul r9 r10 into r11;
    div r11 r7 into r12;
    cast r12 into r13 as u64;
    ternary r8 r0 r13 into r14;
    assert.neq r14 0u64 ;
    add r4.total_supply r14 into r15;
    add r4.total_reserve r0 into r16;
    cast r15 r16 r4.total_unstaking r4.total_reward into r17 as State;
    set r17 into state[true];
    get.or_use account[r1] 0u64 into r18;
    add r18 r14 into r19;
    set r19 into account[r1];

function stake_private:
    input r0 as credits.aleo/credits.record;
    input r1 as u64.public;
    input r2 as address.public;
    assert.neq r1 0u64 ;
    call credits.aleo/transfer_private_to_public r0 staking_v1.aleo r1 into r3 r4;
    async stake_private r1 r2 r4 into r5;
    output r3 as credits.aleo/credits.record;
    output r5 as staking_v1.aleo/stake_private.future;

finalize stake_private:
    input r0 as u64.public;
    input r1 as address.public;
    input r2 as credits.aleo/transfer_private_to_public.future;
    await r2;
    get settings[true] into r3;
    assert.eq r3.stake_paused false ;
    assert.eq r3.global_paused false ;
    get state[true] into r4;
    is.eq r4.total_reserve 0u64 into r5;
    cast r4.total_reserve into r6 as u128;
    ternary r5 1u128 r6 into r7;
    is.eq r4.total_reserve 0u64 into r8;
    cast r0 into r9 as u128;
    cast r4.total_supply into r10 as u128;
    mul r9 r10 into r11;
    div r11 r7 into r12;
    cast r12 into r13 as u64;
    ternary r8 r0 r13 into r14;
    assert.neq r14 0u64 ;
    add r4.total_supply r14 into r15;
    add r4.total_reserve r0 into r16;
    cast r15 r16 r4.total_unstaking r4.total_reward into r17 as State;
    set r17 into state[true];
    get.or_use account[r1] 0u64 into r18;
    add r18 r14 into r19;
    set r19 into account[r1];

function unstake_token:
    input r0 as u64.public;
    assert.neq r0 0u64 ;
    async unstake_token self.caller r0 into r1;
    output r1 as staking_v1.aleo/unstake_token.future;

finalize unstake_token:
    input r0 as address.public;
    input r1 as u64.public;
    get settings[true] into r2;
    assert.eq r2.global_paused false ;
    get.or_use account[r0] 0u64 into r3;
    sub r3 r1 into r4;
    set r4 into account[r0];
    get state[true] into r5;
    cast r1 into r6 as u128;
    cast r5.total_reserve into r7 as u128;
    mul r6 r7 into r8;
    cast r5.total_supply into r9 as u128;
    div r8 r9 into r10;
    cast r10 into r11 as u64;
    assert.neq r11 0u64 ;
    sub r5.total_supply r1 into r12;
    sub r5.total_reserve r11 into r13;
    add r5.total_unstaking r11 into r14;
    cast r12 r13 r14 r5.total_reward into r15 as State;
    set r15 into state[true];
    cast 0u64 0u32 into r16 as Unstaking;
    get.or_use unstakings[r0] r16 into r17;
    add r17.microcredits r11 into r18;
    add block.height r2.unstake_wait into r19;
    cast r18 r19 into r20 as Unstaking;
    set r20 into unstakings[r0];

function unstake_aleo:
    input r0 as u64.public;
    assert.neq r0 0u64 ;
    async unstake_aleo self.caller r0 into r1;
    output r1 as staking_v1.aleo/unstake_aleo.future;

finalize unstake_aleo:
    input r0 as address.public;
    input r1 as u64.public;
    get settings[true] into r2;
    assert.eq r2.global_paused false ;
    get state[true] into r3;
    cast r1 into r4 as u128;
    cast r3.total_supply into r5 as u128;
    mul r4 r5 into r6;
    cast r3.total_reserve into r7 as u128;
    add r6 r7 into r8;
    sub r8 1u128 into r9;
    cast r3.total_reserve into r10 as u128;
    div r9 r10 into r11;
    cast r11 into r12 as u64;
    assert.neq r12 0u64 ;
    get.or_use account[r0] 0u64 into r13;
    sub r13 r12 into r14;
    set r14 into account[r0];
    sub r3.total_supply r12 into r15;
    sub r3.total_reserve r1 into r16;
    add r3.total_unstaking r1 into r17;
    cast r15 r16 r17 r3.total_reward into r18 as State;
    set r18 into state[true];
    cast 0u64 0u32 into r19 as Unstaking;
    get.or_use unstakings[r0] r19 into r20;
    add r20.microcredits r1 into r21;
    add block.height r2.unstake_wait into r22;
    cast r21 r22 into r23 as Unstaking;
    set r23 into unstakings[r0];

function withdraw:
    input r0 as u64.public;
    input r1 as address.public;
    assert.neq r0 0u64 ;
    call credits.aleo/transfer_public r1 r0 into r2;
    async withdraw self.caller r0 r2 into r3;
    output r3 as staking_v1.aleo/withdraw.future;

finalize withdraw:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as credits.aleo/transfer_public.future;
    await r2;
    get settings[true] into r3;
    assert.eq r3.global_paused false ;
    get unstakings[r0] into r4;
    gte block.height r4.height into r5;
    assert.eq r5 true ;
    sub r4.microcredits r1 into r6;
    cast r6 r4.height into r7 as Unstaking;
    set r7 into unstakings[r0];
    get state[true] into r8;
    sub r8.total_unstaking r1 into r9;
    cast r8.total_supply r8.total_reserve r9 r8.total_reward into r10 as State;
    set r10 into state[true];

function withdraw_private:
    input r0 as u64.public;
    input r1 as address.private;
    assert.neq r0 0u64 ;
    call credits.aleo/transfer_public_to_private r1 r0 into r2 r3;
    async withdraw_private self.caller r0 r3 into r4;
    output r2 as credits.aleo/credits.record;
    output r4 as staking_v1.aleo/withdraw_private.future;

finalize withdraw_private:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as credits.aleo/transfer_public_to_private.future;
    await r2;
    get settings[true] into r3;
    assert.eq r3.global_paused false ;
    get unstakings[r0] into r4;
    gte block.height r4.height into r5;
    assert.eq r5 true ;
    sub r4.microcredits r1 into r6;
    cast r6 r4.height into r7 as Unstaking;
    set r7 into unstakings[r0];
    get state[true] into r8;
    sub r8.total_unstaking r1 into r9;
    cast r8.total_supply r8.total_reserve r9 r8.total_reward into r10 as State;
    set r10 into state[true];

function approve_public:
    input r0 as address.public;
    input r1 as u64.public;
    cast self.caller r0 into r2 as ApprovalKey;
    hash.bhp256 r2 into r3 as field;
    async approve_public r3 r1 into r4;
    output r4 as staking_v1.aleo/approve_public.future;

finalize approve_public:
    input r0 as field.public;
    input r1 as u64.public;
    get.or_use approvals[r0] 0u64 into r2;
    sub 18446744073709551615u64 r2 into r3;
    lt r1 r3 into r4;
    add.w r2 r1 into r5;
    ternary r4 r5 18446744073709551615u64 into r6;
    set r6 into approvals[r0];

function unapprove_public:
    input r0 as address.public;
    input r1 as u64.public;
    cast self.caller r0 into r2 as ApprovalKey;
    hash.bhp256 r2 into r3 as field;
    async unapprove_public r3 r1 into r4;
    output r4 as staking_v1.aleo/unapprove_public.future;

finalize unapprove_public:
    input r0 as field.public;
    input r1 as u64.public;
    get approvals[r0] into r2;
    gt r2 r1 into r3;
    sub.w r2 r1 into r4;
    ternary r3 r4 0u64 into r5;
    set r5 into approvals[r0];

function transfer_from_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    cast r0 self.caller into r3 as ApprovalKey;
    hash.bhp256 r3 into r4 as field;
    async transfer_from_public r4 r0 r1 r2 into r5;
    output r5 as staking_v1.aleo/transfer_from_public.future;

finalize transfer_from_public:
    input r0 as field.public;
    input r1 as address.public;
    input r2 as address.public;
    input r3 as u64.public;
    get approvals[r0] into r4;
    sub r4 r3 into r5;
    set r5 into approvals[r0];
    get account[r1] into r6;
    sub r6 r3 into r7;
    set r7 into account[r1];
    get.or_use account[r2] 0u64 into r8;
    add r8 r3 into r9;
    set r9 into account[r2];

function notify_reward:
    input r0 as u64.public;
    assert.neq r0 0u64 ;
    async notify_reward self.caller r0 into r1;
    output r1 as staking_v1.aleo/notify_reward.future;

finalize notify_reward:
    input r0 as address.public;
    input r1 as u64.public;
    get settings[true] into r2;
    assert.eq r2.global_paused false ;
    get stakers[r0] into r3;
    assert.eq r3 true ;
    lte r1 r2.max_reward_per_notify into r4;
    assert.eq r4 true ;
    get state[true] into r5;
    cast r5.total_reserve into r6 as u128;
    mul r6 10000u128 into r7;
    cast r1 into r8 as u128;
    cast r2.protocol_fee into r9 as u128;
    sub 10000u128 r9 into r10;
    mul r8 r10 into r11;
    add r7 r11 into r12;
    cast r2.protocol_fee into r13 as u128;
    cast r1 into r14 as u128;
    mul r13 r14 into r15;
    cast r5.total_supply into r16 as u128;
    mul r15 r16 into r17;
    div r17 r12 into r18;
    cast r18 into r19 as u64;
    add r5.total_supply r19 into r20;
    add r5.total_reserve r1 into r21;
    add r5.total_reward r1 into r22;
    cast r20 r21 r5.total_unstaking r22 into r23 as State;
    set r23 into state[true];
    get.or_use account[r2.fee_account] 0u64 into r24;
    add r24 r19 into r25;
    set r25 into account[r2.fee_account];

function pull_aleo:
    input r0 as u64.public;
    call credits.aleo/transfer_public self.caller r0 into r1;
    async pull_aleo self.caller r1 into r2;
    output r2 as staking_v1.aleo/pull_aleo.future;

finalize pull_aleo:
    input r0 as address.public;
    input r1 as credits.aleo/transfer_public.future;
    await r1;
    get settings[true] into r2;
    assert.eq r2.global_paused false ;
    get stakers[r0] into r3;
    assert.eq r3 true ;

function update_settings:
    input r0 as Settings.public;
    lte r0.protocol_fee 5000u16 into r1;
    assert.eq r1 true ;
    async update_settings self.caller r0 into r2;
    output r2 as staking_v1.aleo/update_settings.future;

finalize update_settings:
    input r0 as address.public;
    input r1 as Settings.public;
    get admins[r0] into r2;
    assert.eq r2 true ;
    set r1 into settings[true];

function set_staker:
    input r0 as address.public;
    input r1 as boolean.public;
    async set_staker self.caller r0 r1 into r2;
    output r2 as staking_v1.aleo/set_staker.future;

finalize set_staker:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as boolean.public;
    get admins[r0] into r3;
    assert.eq r3 true ;
    set r2 into stakers[r1];

function set_admin:
    input r0 as address.public;
    input r1 as boolean.public;
    assert.neq self.caller r0 ;
    async set_admin self.caller r0 r1 into r2;
    output r2 as staking_v1.aleo/set_admin.future;

finalize set_admin:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as boolean.public;
    get admins[r0] into r3;
    assert.eq r3 true ;
    set r2 into admins[r1];

function init:
    input r0 as address.public;
    assert.eq self.caller aleo18jfrqsz4m853grpgzflrlzdkcm9art926668g80vd9ruyzv8rsqqlchzyj ;
    async init r0 into r1;
    output r1 as staking_v1.aleo/init.future;

finalize init:
    input r0 as address.public;
    contains metadata[true] into r1;
    assert.eq r1 false ;
    cast 394103260206656316532079u128 126943148918095u128 6u8 into r2 as Metadata;
    set r2 into metadata[true];
    set true into admins[aleo18jfrqsz4m853grpgzflrlzdkcm9art926668g80vd9ruyzv8rsqqlchzyj];
    cast 0u64 0u64 0u64 0u64 into r3 as State;
    set r3 into state[true];
    cast 360u32 false false 1000000000u64 1000u16 r0 into r4 as Settings;
    set r4 into settings[true];
