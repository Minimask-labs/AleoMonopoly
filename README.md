# AleoMonopoly
The Aleo Monopoly Game is a blockchain-based game where players can buy buildings, roll dice, compete against opponents, and earn rewards. The game is designed to be fun, competitive, and rewarding, with a focus on privacy and decentralization

# DEPLOYMENT LINK
**Deployment Url:** https://testnet.aleo.info/program/aleo_monopoly_test003.aleo

**Deployment ID:** at1qqjx9lwp6aylrrxkwke8rhh45egmjyyla0er368g5d0zl6ly95qs6e46an

# Getting Started
### Step 1: Connect Wallet

- Players must connect their Aleo wallet to the game interface.

- They need to sign a transaction to authenticate their wallet.

### Step 2: Mint Test Tokens

- Players start by minting 10,000 test tokens using the issue transition.

- These tokens are used to buy buildings and participate in the game.

**Leo Input Command** - `leo run issue aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h 10000u64`

Output
```
 •  'aleo_monopoly_test03.aleo/issue' - 0 constraints (called 1 time)
➡️  Outputs

 • aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h
 • 10000u64
 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: issue,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    10000u64
  ]
}
```
  

# Buying Buildings
### Step 3: Purchase a Building

- Players use the monopoly_buy transition to buy a building for 5,000 tokens.

- Each building increases the player's chances of earning rewards when rolling the dice.

- The price of buildings increases by 500 tokens for each subsequent purchase.

**Leo Input Command** - `leo run monopoly_buy aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h 5000u64`

Output
```
 •  'aleo_monopoly_test03.aleo/monopoly_buy' - 2,087 constraints (called 1 time)

➡️  Outputs

 • {
  owner: aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h.private,
  amount: 0u64.private,
  buildings: 1u64.private,
  _nonce: 2585017126032316317528177084561187600133551382803909557733036668531015355381group.public
}
 • 5000u64
 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: monopoly_buy,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    5000u64,
    1u64
  ]
}
```

# Rolling the Dice
### Step 4: Pay Rent (Roll Dice)

- Players use the monopoly_rent transition to simulate rolling the dice.

- A random number is generated using the ChaCha random mechanism.

- If the player wins, they earn 150 tokens per building they own.

- If they lose, they lose 150 tokens per building.

Leo Input Command - `leo run monopoly_rent aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h 5000u64 1u64`

Output 
```
 •  'aleo_monopoly_test03.aleo/monopoly_rent' - 2,020 constraints (called 1 time)

➡️  Outputs

 • {
  owner: aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h.private,
  amount: 5000u64.private,
  buildings: 1u64.private,
  _nonce: 4171132929524822510544142846068041976499748801483152603947543529708429829496group.public
}
 • 150u64
 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: monopoly_rent,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    150u64
  ]
}
```

# Stake-to-Earn Bonus:

- Players who stake at least 5,000,000 [5 aleo] tokens minimum in the Betastaking. [Visit Website](https://testnet.betastaking.com/) contract earn an additional 100 tokens per roll, regardless of the outcome.

# Competing Against Opponent
### Step 5: Request a Game

- Players can challenge another player using the play_request transition.

- A unique game ID is generated using the hash of both players' addresses.

**Leo Input Command** - `leo run play_request aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq`

Output 
```
 •  'aleo_monopoly_test03.aleo/play_request' - 0 constraints (called 1 time)

➡️  Output

 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: play_request,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq
  ]
}
```

### Step 6: Accept the Game

- The opponent accepts the game using the accept_request transition.

- Both players set a goal (e.g., 400 tokens above their current balance).

**Leo Input Command** - `leo run accept_request aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq`

Output
```
 •  'aleo_monopoly_test03.aleo/accept_request' - 0 constraints (called 1 time)

➡️  Output

 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: accept_request,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq
  ]
}
```

### Step 7: Check the Result

- After playing, players use the check_request transition to determine the winner.

- The first player to reach their goal wins 1,000 tokens.

Leo Input Command - `leo run check_request  aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq`

Output
```
 •  'aleo_monopoly_test03.aleo/check_request' - 0 constraints (called 1 time)

➡️  Output

 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: check_request,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq
  ]
}
```

# Minting NFTs
### Step 8: Mint an NFT

- Players who accumulate at least 12,000 tokens can mint an NFT using the mint_nft transition.

- The NFT represents ownership of a specific country in the game.

- NFTs can be used to play mini-games in the future.

**Leo Input Command** - `leo run mint_nft aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h 123456789u64 1928374738847388473field 1837738223u128`

Output 
```
 •  'aleo_monopoly_test03.aleo/mint_nft' - 6 constraints (called 1 time)

➡️  Output

 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: mint_nft,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    123456789u64,
    1928374738847388473field,
    1837738223u128
  ]
}
```

# Selling Buildings
### Step 9: Sell a Building

- Players can sell their buildings back to the admin using the monopoly_sale transition.

- The admin pays the player the building price minus a 1,000 token fee.

**Leo Input Command** - `leo run monopoly_sale aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq`

Output
```
 •  'aleo_monopoly_test03.aleo/monopoly_sale' - 0 constraints (called 1 time)

➡️  Outputs

 • aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h
 • aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq
 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: monopoly_sale,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq
  ]
}
```

# Admin Functions
### Step 10: Send Tokens

- The admin can send tokens to players using the send_token transition.

- This is useful for rewarding players or distributing tokens for special events.

**Leo Input Command** - `leo run send_token aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq 100u64`

Output 
```
 •  'aleo_monopoly_test03.aleo/send_token' - 0 constraints (called 1 time)

➡️  Outputs

 • 100u64
 • {
  program_id: aleo_monopoly_test03.aleo,
  function_name: send_token,
  arguments: [
    aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h,
    aleo1fhwz4w7jg0sq0pd0xk5h0t5jf2taueaf8zdcflpjszc0mjrrtqyqchmjpq,
    100u64
  ]
}
```

# How Users Would Understand the Game
### Objective:

- The main goal is to accumulate 12,000 tokens to mint an NFT.

- Players can also compete against others to earn additional rewards.

# Gameplay:

- Players buy buildings, roll dice, and compete in versus games.

- Each action (buying, rolling, competing) affects their token balance.

# Rewards:

- Players earn tokens by winning dice rolls and versus games.

- Staking tokens provides additional rewards.

# NFTs:

- NFTs are a status symbol and provide access to future mini-games.

- Players can showcase their NFTs in the upcoming Minimask Lab Marketplace.

# Future Plans: Mini-Games and Marketplace
**Mini-Games:**

- Players who own NFTs will gain access to exclusive mini-games.

- These games will offer additional rewards and challenges.

**Marketplace:**

- **Minimask Lab** will introduce a marketplace where players can buy and sell NFTs.

- NFTs will have unique attributes (e.g., country, rarity) that affect their value.

# Example Workflow for a Player
**Start:**

- Alex connect wallet and mint 10,000 tokens.

- Buy a building for 5,000 tokens.

**Play:**

- Roll the dice and earn/lose tokens.

- Challenge a friend to a versus game.

**Earn:**

- Accumulate 12,000 tokens and mint an NFT.

- Stake tokens to earn bonuses.

**Sell:**

- Sell buildings or NFTs in the marketplace for profit.

# HOW CAN ALEO MONOPOLY ENHANCE PRIVACY USING ALEO 
### Zero-Knowledge Proofs (ZKPs)
**What It Does:**

- Aleo uses zkSNARKs (Zero-Knowledge Succinct Non-Interactive Arguments of Knowledge) to enable private transactions and computations.

- Players can prove they have met certain conditions (e.g., owning enough tokens to mint an NFT) without revealing their actual token balance or other sensitive data.

**How It Enhances Privacy:**

- Players can mint NFTs, roll dice, and compete in games without exposing their wallet balances or transaction history.

- For example, when a player mints an NFT, they prove they have 12,000 tokens without revealing their exact balance.

### Private State Transitions
**What It Does:**

- Aleo allows state transitions (e.g., updating player balances, minting NFTs) to be executed privately.

- The game uses private records to store player data, such as token balances and building ownership.

**How It Enhances Privacy:**

- Player balances and ownership records are stored in encrypted form on the blockchain.

- Only the player (or authorized parties) can decrypt and access their data.

### Encrypted Transactions
**What It Does:**

- All transactions (e.g., buying buildings, paying rent, sending tokens) are encrypted using Aleo's privacy features.

- The details of the transaction (e.g., sender, receiver, amount) are hidden from public view.

**How It Enhances Privacy:**

- Players can buy buildings, pay rent, and send tokens without revealing their wallet addresses or transaction amounts.

- For example, when a player buys a building, the transaction is recorded on the blockchain, but the details are encrypted.

### Private Gameplay
**What It Does:**

- Gameplay actions (e.g., rolling dice, competing in versus games) are executed privately using zkSNARKs.

- Randomness for dice rolls is generated using the ChaCha random mechanism, which is verifiable but private.

**How It Enhances Privacy:**

- Players can roll dice and compete against opponents without revealing their strategies or outcomes.

- For example, when a player rolls the dice, the result is computed privately, and only the outcome (win/lose) is revealed.

### Private NFTs
**What It Does:**

- NFTs are minted and transferred privately using Aleo's privacy features.

- Ownership of NFTs is stored in encrypted records.

**How It Enhances Privacy:**

- Players can mint, trade, and use NFTs without revealing their identity or wallet address.

- For example, when a player mints an NFT, the transaction is recorded on the blockchain, but the details (e.g., player address, NFT metadata) are encrypted.

### Private Versus Games
**What It Does:**

- Versus games are executed privately using zkSNARKs.

- The game ID is generated using a hash of both players' addresses, ensuring privacy.

**How It Enhances Privacy:**

- Players can compete against each other without revealing their identities or strategies.

- For example, when a player challenges an opponent, the game ID is computed privately, and only the outcome is revealed.

### Private Marketplace (Future)
**What It Does:**

- The upcoming Minimask Lab Marketplace will use Aleo's privacy features to enable private buying and selling of NFTs.

- Transactions will be encrypted, and ownership will be stored in private records.

**How It Enhances Privacy:**

- Players can buy and sell NFTs without revealing their identity or transaction details.

- For example, when a player sells an NFT, the transaction is recorded on the blockchain, but the details (e.g., buyer, seller, price) are encrypted.

# Why This Game is Fun and Engaging
**Competitive:** Players can challenge friends and compete for rewards.

**Rewarding:** Earn tokens and NFTs through gameplay.

**Strategic:** Players must decide when to buy buildings, roll dice, or sell assets.

**Future-Proof:** NFTs and mini-games add long-term value and engagement.
