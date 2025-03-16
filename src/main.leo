// Aleo Monopoly Game Smart Contract
// Version: 0.2.0
// Author: MiniMask Lab
// Email: emmanuellinus013@gmail.com

import credits.aleo;
import staking_v1.aleo;

program aleo_monopoly_test03.aleo {

    // Game Record
    record Buildings {
        owner: address,
        amount: u64,
        buildings: u64,
    }

    // aMONO Token => Reward Token
    struct TokenInfo {
        name: field,
        symbol: field,
        decimals: u8,
        circulating_supply: u64,
        total_supply: u64,
        testers: u64, // Limited to 1,000 testers FCFS to claim reward
        admin: address,
    }

    // TestToken => Testing token (MAX PER USER -> 10,000 token)
    struct TestToken {
        name: field,
        symbol: field,
        decimals: u8,
        circulating_supply: u64,
        total_supply: u64,
        admin: address,
    }

    // Building Info
    struct BuildingInfo {
        building_id: field,
        receiver: address,
        building_price: u64,
        total_building: u64,
    }

    // Admin Control
    struct GlobalState {
        next_token_id: field,
        admin: address,
    }

    // Player vs Opponent
    struct Versus {
        game_id: field,
        player: address,
        game_begins: bool,
        player_goal: u64,
        max_game: u8, // Usually one player against opponent per time
    }

    // Track Game Count
    struct Track {
        roll_count: u64,
        versus_count: u64,
    }

    // Monopoly NFT
    struct MonoNFT {
        player: address,
        id: field,
        name: u64,
        owned: bool,
        date: u128,
    }

    // On-chain storage mappings
    mapping account: address => u64;
    mapping tokens: u64 => TokenInfo;
    mapping test_token: u64 => TestToken;
    mapping unique_building: address => BuildingInfo;
    mapping global_state: bool => GlobalState;
    mapping versus_player: address => Versus;
    mapping track_player: address => Track;
    mapping nft_holder: field => MonoNFT;

    // Initialize the program after deployment
    async transition init(b: bool) -> (address, Future) {
        let caller: address = aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m;
        return (self.caller, finalize_init(caller));
    }

    async function finalize_init(caller: address) {
        // Initialize global state
        let gs: GlobalState = Mapping::get_or_use(global_state, true, GlobalState {
            next_token_id: 0field,
            admin: aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m,
        });
        assert_eq(gs.next_token_id, 0field);
        assert_eq(caller, gs.admin);
        Mapping::set(global_state, true, GlobalState {
            next_token_id: 1field,
            admin: gs.admin,
        });

        // Initialize token
        let test_supply: u64 = 15000000000000u64; // 15 billion tokens
        let admin_token_amt: u64 = 60000000u64; // Admin token amount for testing

        let owner_amount: u64 = Mapping::get_or_use(account, caller, 0u64);
        assert(owner_amount == 0u64);
        Mapping::set(account, caller, owner_amount + admin_token_amt);

        Mapping::set(test_token, test_supply, TestToken {
            name: 4577111110111112111108121field,
            symbol: 4577111110111112111108121field,
            decimals: 6u8,
            circulating_supply: 0u64 + admin_token_amt,
            total_supply: test_supply,
            admin: gs.admin,
        });
    }

    // Change the main admin of the program
    async transition change_admin(admin: address) -> (address, Future) {
        return (self.caller, finalize_admin(admin));
    }

    async function finalize_admin(caller: address) {
        let gs: GlobalState = Mapping::get(global_state, true);
        assert_eq(caller, gs.admin);
        Mapping::set(global_state, true, GlobalState {
            next_token_id: gs.next_token_id,
            admin: caller,
        });
    }

    // Issue a monopoly token to a player
    async transition issue(owner: address, amount: u64) -> (address, u64, Future) {
        return (owner, amount, finalize_issue(owner, amount));
    }

    async function finalize_issue(owner: address, amount: u64) {
        let test_supply: u64 = 15000000000000u64;
        let gs: GlobalState = Mapping::get_or_use(global_state, true, GlobalState {
            next_token_id: 0field,
            admin: aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m,
        });
        assert(gs.next_token_id == 1field);

        let test_token_info: TestToken = Mapping::get_or_use(test_token, test_supply, TestToken {
            name: 4577111110111112111108121field,
            symbol: 4577111110111112111108121field,
            decimals: 6u8,
            circulating_supply: 0u64,
            total_supply: test_supply,
            admin: gs.admin,
        });

        let owner_amount: u64 = Mapping::get_or_use(account, owner, 0u64);
        let updated_circulating: u64 = test_token_info.circulating_supply + amount;
        assert(updated_circulating <= test_token_info.total_supply);
        assert(amount == 10000u64);

        Mapping::set(test_token, test_supply, TestToken {
            name: test_token_info.name,
            symbol: test_token_info.symbol,
            decimals: test_token_info.decimals,
            circulating_supply: updated_circulating,
            total_supply: test_token_info.total_supply,
            admin: gs.admin,
        });

        assert(owner_amount == 0u64);
        Mapping::set(account, owner, owner_amount + amount);
    }

    // Purchase (Buy) Building
    async transition monopoly_buy(owner: address, amount: u64) -> (Buildings, u64, Future) {
        let buildings: u64 = 1u64;
        let spend_amount: u64 = 5000u64;

        let buy_to: Buildings = Buildings {
            owner: owner,
            amount: amount - spend_amount,
            buildings: buildings,
        };
        return (buy_to, spend_amount, finalize_monopoly_buy(owner, spend_amount, buildings));
    }

    async function finalize_monopoly_buy(owner: address, spend_amount: u64, buildings: u64) {
        let issue_exists: u64 = Mapping::get_or_use(account, owner, 0u64);
        assert(issue_exists > 0u64);

        let B_ID: field = ChaCha::rand_field();
        let building_info: BuildingInfo = Mapping::get_or_use(unique_building, owner, BuildingInfo {
            building_id: B_ID,
            receiver: owner,
            building_price: spend_amount,
            total_building: 0u64,
        });

        let owner_amount: u64 = Mapping::get_or_use(account, owner, 0u64);
        Mapping::set(account, owner, owner_amount - building_info.building_price);

        assert(owner_amount > building_info.building_price);
        assert(building_info.receiver == owner);
        assert(building_info.total_building >= 0u64);

        Mapping::set(unique_building, owner, BuildingInfo {
            building_id: building_info.building_id,
            receiver: building_info.receiver,
            building_price: (building_info.building_price + 500u64),
            total_building: building_info.total_building + buildings,
        });
    }

    // Rent (Pay Rent) Building
    async transition monopoly_rent(owner: address, amount: u64, buildings: u64) -> (Buildings, u64, Future) {
        let rent_amount: u64 = 150u64;

        let rent_to: Buildings = Buildings {
            owner: owner,
            amount: amount,
            buildings: buildings,
        };
        return (rent_to, rent_amount, finalize_monopoly_rent(owner, rent_amount));
    }

    async function finalize_monopoly_rent(owner: address, rent_amount: u64) {
        let building_info: BuildingInfo = Mapping::get_or_use(unique_building, owner, BuildingInfo {
            building_id: 123field,
            receiver: owner,
            building_price: 0u64,
            total_building: 0u64,
        });
        assert(building_info.receiver == owner);
        assert(building_info.total_building >= 1u64);

        let issue_exists: u64 = Mapping::get_or_use(account, owner, 0u64);
        assert(issue_exists > 0u64);

        let owner_amount: u64 = Mapping::get_or_use(account, owner, 0u64);
        let randomness: u64 = ChaCha::rand_u64();
        Mapping::set(account, owner, 9223372036854775808u64 > randomness ? owner_amount + (building_info.total_building * 150u64) : owner_amount - (building_info.total_building * 150u64));

        let stake_criteria: u64 = Mapping::get_or_use(staking_v1.aleo/account, owner, 0u64);
        Mapping::set(account, owner, (stake_criteria >= 5000000u64) ? owner_amount + 100u64 : owner_amount + 0u64);

        let map_count: Track = Mapping::get_or_use(track_player, owner, Track {
            roll_count: 0u64,
            versus_count: 0u64,
        });

        Mapping::set(track_player, owner, Track {
            roll_count: map_count.roll_count + 1u64,
            versus_count: 0u64,
        });
    }

    // Monopoly Sale Token (Sale Building to Admin)
    async transition monopoly_sale(owner: address, to_address: address) -> (address, address, Future) {
        return (owner, to_address, finalize_monopoly_sale(owner, to_address));
    }

    async function finalize_monopoly_sale(owner: address, to_address: address) {
        let building_info: BuildingInfo = Mapping::get_or_use(unique_building, owner, BuildingInfo {
            building_id: 123field,
            receiver: owner,
            building_price: 0u64,
            total_building: 0u64,
        });
        assert(building_info.receiver == owner);
        assert(building_info.total_building >= 1u64);

        let issue_exists: u64 = Mapping::get_or_use(account, owner, 0u64);
        assert(issue_exists > 0u64);

        let issue_exists_to: u64 = Mapping::get_or_use(account, to_address, 0u64);
        assert(issue_exists_to >= 5000u64);

        assert_eq(to_address, aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m);

        let building_fee: u64 = 1000u64;
        let to_address_amount: u64 = Mapping::get_or_use(account, to_address, 0u64);
        Mapping::set(account, to_address, to_address_amount - ((building_info.total_building * building_info.building_price) - (building_info.total_building * building_fee)));

        let owner_amount: u64 = Mapping::get_or_use(account, owner, 0u64);
        Mapping::set(account, owner, owner_amount + ((building_info.total_building * building_info.building_price) - building_fee));

        let new_building_owner: u64 = building_info.total_building;
        assert(new_building_owner <= building_info.total_building);
        Mapping::set(unique_building, owner, BuildingInfo {
            building_id: building_info.building_id,
            receiver: owner,
            building_price: (building_info.building_price - (building_info.total_building * 600u64)),
            total_building: (building_info.total_building - building_info.total_building),
        });

        let new_building_to_address: u64 = building_info.total_building + new_building_owner;
        assert(new_building_to_address >= building_info.total_building);
        Mapping::set(unique_building, to_address, BuildingInfo {
            building_id: building_info.building_id,
            receiver: to_address,
            building_price: building_info.building_price,
            total_building: new_building_to_address,
        });

        Mapping::remove(unique_building, owner);
    }

    // Mint NFT
    async transition mint_nft(owner: address, name: u64, id: field, date: u128) -> (Future) {
        assert(owner == self.caller);
        return (finalize_mint_nft(owner, name, id, date));
    }

    async function finalize_mint_nft(owner: address, name: u64, id: field, date: u128) {
        let get_nft: MonoNFT = Mapping::get_or_use(nft_holder, id, MonoNFT {
            player: owner,
            id: id,
            name: name,
            owned: false,
            date: date,
        });

        //checks if nft is not owned
        assert((get_nft.owned == false) && (get_nft.id == id));

        //checks if owner is already an nft owner
        assert(get_nft.player != owner);

        //checks if amount to buy nft is ok
        let owner_amt: u64 = Mapping::get_or_use(account, owner, 0u64);
        assert(owner_amt >= 12000u64);

        Mapping::set(nft_holder, id, MonoNFT {
            player: owner,
            id: id,
            name: name,
            owned: true,
            date: date,
        });
    }

    // Play Request (Player vs Opponent)
    async transition play_request(owner: address, opponent: address) -> (Future) {
        return (finalize_play_request(owner, opponent));
    }

    async function finalize_play_request(owner: address, opponent: address) {
        let versus_request: Versus = Mapping::get_or_use(versus_player, owner, Versus {
            game_id: 123field,
            player: owner,
            game_begins: false,
            player_goal: 0u64,
            max_game: 0u8,
        });

        assert_neq(owner, opponent);
        assert_eq(versus_request.max_game, 0u8);

        let owner_balance: u64 = Mapping::get_or_use(account, owner, 0u64);
        let opponent_balance: u64 = Mapping::get_or_use(account, opponent, 0u64);

        assert(owner_balance >= 1000u64);
        assert(opponent_balance >= 1000u64);

        let hash_owner: field = Keccak512::hash_to_field(owner);
        let hash_opponent: field = Keccak512::hash_to_field(opponent);
        let add_hash: field = hash_owner + hash_opponent;

        Mapping::set(versus_player, owner, Versus {
            game_id: add_hash,
            player: owner,
            game_begins: false,
            player_goal: 0u64,
            max_game: 0u8,
        });

        Mapping::set(versus_player, opponent, Versus {
            game_id: add_hash,
            player: opponent,
            game_begins: false,
            player_goal: 0u64,
            max_game: 0u8,
        });
    }

    // Accept Request (Player vs Opponent)
    async transition accept_request(owner: address, opponent: address) -> (Future) {
        return (finalize_accept_request(self.caller, opponent));
    }

    async function finalize_accept_request(owner: address, opponent: address) {
        let hash_owner: field = Keccak512::hash_to_field(owner);
        let hash_opponent: field = Keccak512::hash_to_field(opponent);
        let add_hash: field = hash_owner + hash_opponent;

        let versus_request: Versus = Mapping::get_or_use(versus_player, owner, Versus {
            game_id: add_hash,
            player: owner,
            game_begins: false,
            player_goal: 0u64,
            max_game: 0u8,
        });

        let versus_request2: Versus = Mapping::get_or_use(versus_player, opponent, Versus {
            game_id: add_hash,
            player: opponent,
            game_begins: false,
            player_goal: 0u64,
            max_game: 0u8,
        });

        assert_neq(owner, opponent);
        assert((versus_request.max_game == 0u8) && (versus_request2.max_game == 0u8));

        let owner_balance: u64 = Mapping::get_or_use(account, owner, 0u64);
        let opponent_balance: u64 = Mapping::get_or_use(account, opponent, 0u64);

        assert(owner_balance >= 1000u64);
        assert(opponent_balance >= 1000u64);

        let owner_set_goal: u64 = (owner_balance + 400u64);
        let opponent_set_goal: u64 = (opponent_balance + 400u64);

        assert((add_hash == versus_request.game_id) && (add_hash == versus_request2.game_id));
        assert_eq(versus_request.game_begins, false);

        Mapping::set(versus_player, owner, Versus {
            game_id: add_hash,
            player: owner,
            game_begins: true,
            player_goal: owner_set_goal,
            max_game: 1u8,
        });

        Mapping::set(versus_player, opponent, Versus {
            game_id: add_hash,
            player: opponent,
            game_begins: true,
            player_goal: opponent_set_goal,
            max_game: 1u8,
        });

        let map_count: Track = Mapping::get_or_use(track_player, owner, Track {
            roll_count: 0u64,
            versus_count: 0u64,
        });

        Mapping::set(track_player, owner, Track {
            roll_count: map_count.roll_count,
            versus_count: map_count.versus_count + 1u64,
        });
    }

    // Check Request (Player vs Opponent)
    async transition check_request(owner: address, opponent: address) -> (Future) {
        return (finalize_check_request(self.caller, opponent));
    }

    async function finalize_check_request(owner: address, opponent: address) {
        let hash_owner: field = Keccak512::hash_to_field(owner);
        let hash_opponent: field = Keccak512::hash_to_field(opponent);
        let add_hash: field = hash_owner + hash_opponent;

        let versus_request: Versus = Mapping::get_or_use(versus_player, owner, Versus {
            game_id: add_hash,
            player: owner,
            game_begins: false,
            player_goal: 0u64,
            max_game: 0u8,
        });

        let versus_request2: Versus = Mapping::get_or_use(versus_player, opponent, Versus {
            game_id: add_hash,
            player: owner,
            game_begins: false,
            player_goal: 0u64,
            max_game: 0u8,
        });

        let owner_balance: u64 = Mapping::get_or_use(account, owner, 0u64);
        assert(owner_balance >= 1000u64);

        assert_eq(versus_request.max_game, 1u8);
        assert((add_hash == versus_request.game_id) && (add_hash == versus_request2.game_id));
        assert((versus_request.game_begins == true) && versus_request2.game_begins == true);

        assert((owner == versus_request.player) || (owner == versus_request.player));
        assert((owner_balance >= versus_request.player_goal));

        Mapping::set(account, owner, (owner_balance >= versus_request.player_goal) ? (owner_balance + 1000u64) : owner_balance + 0u64);
        Mapping::remove(versus_player, versus_request.player);
        Mapping::remove(versus_player, versus_request2.player);
    }

    // Send Token from Admin to Player
    async transition send_token(owner: address, to_address: address, amount: u64) -> (u64, Future) {
        return (amount, finalize_send_token(owner, to_address, amount));
    }

    async function finalize_send_token(owner: address, to_address: address, amount: u64) {
        assert_eq(owner, aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m);

        let issue_exists: u64 = Mapping::get_or_use(account, owner, 0u64);
        let issue_to_address: u64 = Mapping::get_or_use(account, to_address, 0u64);

        assert(issue_exists >= amount);

        let building_info: BuildingInfo = Mapping::get_or_use(unique_building, to_address, BuildingInfo {
            building_id: 123field,
            receiver: to_address,
            building_price: 0u64,
            total_building: 0u64,
        });
        assert(building_info.total_building >= 1u64);

        Mapping::set(account, owner, issue_exists - amount);
        Mapping::set(account, to_address, issue_to_address + amount);
    }
}