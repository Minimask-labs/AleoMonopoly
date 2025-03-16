# AleoMonopoly
The Aleo Monopoly Game is a blockchain-based game where players can buy buildings, roll dice, compete against opponents, and earn rewards. The game is designed to be fun, competitive, and rewarding, with a focus on privacy and decentralization

# Getting Started
### Step 1: Connect Wallet

- Players must connect their Aleo wallet to the game interface.

- They need to sign a transaction to authenticate their wallet.

### Step 2: Mint Test Tokens

- Players start by minting 10,000 test tokens using the issue transition.

- These tokens are used to buy buildings and participate in the game.

# Buying Buildings
### Step 3: Purchase a Building

- Players use the monopoly_buy transition to buy a building for 5,000 tokens.

- Each building increases the player's chances of earning rewards when rolling the dice.

- The price of buildings increases by 500 tokens for each subsequent purchase.

# Rolling the Dice
### Step 4: Pay Rent (Roll Dice)

- Players use the monopoly_rent transition to simulate rolling the dice.

- A random number is generated using the ChaCha random mechanism.

- If the player wins, they earn 150 tokens per building they own.

- If they lose, they lose 150 tokens per building.

# Stake-to-Earn Bonus:

- Players who stake at least 5,000,000 tokens in the staking contract earn an additional 100 tokens per roll, regardless of the outcome.

# Competing Against Opponents
### Step 5: Request a Game

- Players can challenge another player using the play_request transition.

- A unique game ID is generated using the hash of both players' addresses.

### Step 6: Accept the Game

- The opponent accepts the game using the accept_request transition.

- Both players set a goal (e.g., 400 tokens above their current balance).

### Step 7: Check the Result

- After playing, players use the check_request transition to determine the winner.

- The first player to reach their goal wins 1,000 tokens.

# Minting NFTs
### Step 8: Mint an NFT

- Players who accumulate at least 12,000 tokens can mint an NFT using the mint_nft transition.

- The NFT represents ownership of a specific country in the game.

- NFTs can be used to play mini-games in the future.

# Selling Buildings
### Step 9: Sell a Building

- Players can sell their buildings back to the admin using the monopoly_sale transition.

- The admin pays the player the building price minus a 1,000 token fee.

# Admin Functions
### Step 10: Send Tokens

- The admin can send tokens to players using the send_token transition.

- This is useful for rewarding players or distributing tokens for special events.

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

# Why This Game is Fun and Engaging
**Competitive:** Players can challenge friends and compete for rewards.

**Rewarding:** Earn tokens and NFTs through gameplay.

**Strategic:** Players must decide when to buy buildings, roll dice, or sell assets.

**Future-Proof:** NFTs and mini-games add long-term value and engagement.
