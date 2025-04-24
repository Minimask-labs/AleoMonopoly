// Global variables
let publicKey = '';
let finalValue = '';
let refreshIntervals = [];

// Wallet connection function
function aleo_connect1() {
    window.leoWallet.connect("ON_CHAIN_HISTORY", "testnetbeta", ["credits.aleo","aleo_monopoly_minimask1.aleo"])
        .then(() => {
            window.leoWallet.requestRecordPlaintexts("aleo_monopoly_minimask1.aleo")
                .then(res => console.log(res));

            // Sign welcome message
            const utf8Encode = new TextEncoder();
            const bytes = utf8Encode.encode("Welcome to Aleo-Monopoly, roll dice by getting rent, mystery cards...");
            window.leoWallet.signMessage(bytes);

            publicKey = window.leoWallet.publicKey;
            if (!publicKey) return;

            // Display shortened wallet address
            const sub_str_wallet = publicKey.substr(0,5) + "..." + publicKey.substr(-3);
            document.getElementById('aleo_wallet').textContent = sub_str_wallet;
            document.getElementById('aleo_wallet2').textContent = sub_str_wallet;

            // Initialize all data fetchers
            initDataFetching();
        })
        .catch(error => {
            console.error('Wallet connection error:', error);
        });
}

// Initialize all data fetching
function initDataFetching() {
    // Clear any existing intervals
    clearAllIntervals();

    // Initial fetches
    fetchAccountData();
    fetchOpponentAndBuildingData();

    // Set up periodic refreshes (5 seconds)
    refreshIntervals.push(setInterval(fetchAccountData, 5000));
    refreshIntervals.push(setInterval(fetchOpponentAndBuildingData, 5000));
}

// Clear all refresh intervals
function clearAllIntervals() {
    refreshIntervals.forEach(interval => clearInterval(interval));
    refreshIntervals = [];
}

// Fetch account balance data
async function fetchAccountData() {
    try {
        const apiUrl = `https://testnet.aleoscan.io/testnet/program/aleo_monopoly_minimask1.aleo/mapping/account/${publicKey}`;
        const response = await fetch(apiUrl);
        
        if (!response.ok) throw new Error('Network response not ok');

        const responseText = await response.text();
        finalValue = responseText.replace(/"/g, '').replace('u64', '');

        document.getElementById("result").textContent = finalValue;
        document.getElementById("result2").textContent = finalValue;
        updateMintButtonState();
    } catch (error) {
        console.error('Error fetching account data:', error);
        document.getElementById("result").textContent = "0";
        document.getElementById("result2").textContent = "0";
    }
}

// Fetch opponent and building data
async function fetchOpponentAndBuildingData() {
    const trophyIcon = document.querySelector('.header-bottom-actions-btn ion-icon[name="trophy-outline"]');
    
    try {
        const [opponentResponse, buildingResponse] = await Promise.all([
            fetch(`https://testnet.aleoscan.io/testnet/program/aleo_monopoly_minimask1.aleo/mapping/versus_player/${publicKey}`),
            fetch(`https://testnet.aleoscan.io/testnet/program/aleo_monopoly_minimask1.aleo/mapping/unique_building/${publicKey}`)
        ]);

        if (!opponentResponse.ok || !buildingResponse.ok) {
            throw new Error('Network error');
        }

        const [opponentText, buildingText] = await Promise.all([
            opponentResponse.text(),
            buildingResponse.text()
        ]);

        // Process opponent data
        const opponentMatch = opponentText.match(/opponent:\s*([^\s,]+)/);
        if (opponentMatch) {
            const opponentAddress = opponentMatch[1].replace(/["',]/g, '');
            document.getElementById("opponent-address").value = opponentAddress;
            if (trophyIcon) trophyIcon.style.color = "green";
        }

        // Process building data
        const buildingMatch = buildingText.match(/total_building:\s*([0-9]+)u64/);
        if (buildingMatch) {
            document.getElementById("game_building").textContent = buildingMatch[1];
        } else {
            document.getElementById("game_building").textContent = "0";
        }

    } catch (error) {
        console.error('Error fetching opponent/building data:', error);
        if (trophyIcon) trophyIcon.style.color = "red";
        document.getElementById("opponent-address").value = "";
        document.getElementById("game_building").textContent = "0";
    }
}

// Update mint button state
function updateMintButtonState() {
    const mintButton = document.getElementById('mint_token');
    if (!mintButton) return;

    const mint_amount = document.getElementById('result').textContent;
    
    if (!publicKey) {
        mintButton.disabled = true;
    } else if (mint_amount > 0) {
        mintButton.textContent = "Minted!";
        mintButton.disabled = true;
    } else {
        mintButton.disabled = false;
        mintButton.textContent = "Mint!";
    }
}

//===============================================================================
//========================== minting MONO token =================================
//===============================================================================

//check if token has been minted once already, and avoid minting twice
//if(token_minted()) {
  //  revoke();
// }else{ mint_token() }
// you need to fetch out the latest transaction from the `issue` function for a checkup to know if user minted already
// if minted, cannot be trigger again... -> (if(count(issue)) > 1){ mint }else{ do not mint again }


function mint_token() {
    //test check

  var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
        console.log(publicKey);
        
            if (!publicKey) {
                throw new WalletNotConnectedError();
            }

            var inputs = [publicKey, `10000u64`];
            
            var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'issue', inputs, 100_000,);
            
            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }      
}




//=========================================================================================================
//================================= function to purchase a building... ====================================
//=========================================================================================================
function purchase() {
    //setting amt
    var amount = document.getElementById('result').textContent; //we could fetch the balance from the past record and get the u64 amount

  var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
        console.log(publicKey);
        
            if (!publicKey) {
                throw new WalletNotConnectedError();
            }

            //main input
            var inputs = [publicKey, `${amount}u64`];

            var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'monopoly_buy', inputs, 100_000,);
            
            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }
}




//=========================================================================================================
//================================= function to sale a building... ====================================
//=========================================================================================================
// Function to be executed with the value from prompt
async function sale_mono() {
    //setting amt
    var amount = document.getElementById('result').textContent; //we could fetch the balance from the past record and get the u64 amount
    var building = 1; //call from the past record to get the u64 building

    let smart_contract = 'aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m';
    let test_value = 10000;

    var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
          console.log(publicKey);
          
              if (!publicKey) {
                  throw new WalletNotConnectedError();
              }

//============================ FETCHING BUILDING ID OF A PLAYER  =====================================
const apiUrl = 'https://testnet.aleoscan.io/testnet/program/aleo_monopoly_minimask1.aleo/mapping/unique_building/'+publicKey;
console.log(apiUrl);

try {
    // Make a fetch request to the API endpoint
    const response = await fetch(apiUrl);

    // Check if the request was successful (status code 200)
    if (!response.ok) {
        throw new Error('Network response was not ok');
    }

    const inputString = await response.text();

    // Find the index of "building id" in the input string
    var BuildingIndex = inputString.indexOf("building_id:"); //fetch building_id
    // Find the index of the "building price"
    var BuildingIndexPrice = inputString.indexOf("building_price:"); //fetch building_price

    // If "opponent:" is found, extract the building id
    if (BuildingIndex !== -1 && BuildingIndexPrice !== -1) {
        // Define the start and end indices for the building id
        var startIndex = BuildingIndex + "building_id: ".length;
        var endIndex = inputString.indexOf(",", startIndex);

        // Define the start and end indices for the building price
        var price_startIndex = BuildingIndexPrice + "building_price: ".length;
        var price_endIndex = inputString.indexOf("u64", price_startIndex);

        // Extract the building id address using substring
        var BuildingId_Player = inputString.substring(startIndex, endIndex);

        // Extract the building price address using substring
        var BuildingPrice_Player = inputString.substring(price_startIndex, price_endIndex);

        console.log("Building Id:", BuildingId_Player);
        console.log("Building Price:", BuildingPrice_Player);
    } else {
        console.log("Substring 'building id:' or 'building_price:' not found in the input string");
    }
       
  
              //main input
              var contract_address = `aleo1az8p9vlllyqwtj0c2g9svkd0e5v0p3zzdflwwrpa7kpe8xrfxgfqqpru7m`;
              var inputs = [publicKey, `${contract_address}`]; //selling to smart contract owner
  
              var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'monopoly_sale', inputs, 200_000,);
              
              if (aleoTransaction) {
                  window.leoWallet.requestTransaction(aleoTransaction);
                  console.log('Transaction requested successfully.');
              } else {
                  console.error('request Transaction function not available.');
          }

        } catch (error) {
            console.error('Error fetching data:', error.message);
          }
}






//========================================================================================================
//=================== CHECKING A USER PERMISSION TO PLAY THE REQUEST GAME ================================
//========================================================================================================
async function play_opponent() {
    var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
    /*
    //get game hash
    var my_hash = document.getElementById('my_hash').value;
    //============================ NOTIFY OPPONENT PLAYER FOR VERSUS GAME =====================================
    const apiUrl = 'https://testnet.aleoscan.io/testnet/program/aleo_monopoly_minimask1.aleo/mapping/versus_player/'+my_hash;
    console.log(apiUrl);
    try {
        // Make a fetch request to the API endpoint
        const response = await fetch(apiUrl);
    
        // Check if the request was successful (status code 200)
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }

        const inputString = await response.text();
    
// Find the index of "opponent:" in the input string
var opponentIndex = inputString.indexOf("player:"); //fetch owner address
// If "opponent:" is found, extract the opponent's address
if (opponentIndex !== -1) {
  // Define the start and end indices for the opponent's address
  var startIndex = opponentIndex + "player: ".length;
  var endIndex = inputString.indexOf(",", startIndex);
*/

  // Extract the opponent's address using substring
  var opponentAddress = document.getElementById('opponent-address').value;

  console.log("Opponent's address:", opponentAddress);

 // Check if a match is found and the captured groups are not null
if (opponentAddress !== null) {
    //main input
    var inputs = [publicKey, opponentAddress];
    var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'accept_request', inputs, 200_000);

            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }     
        } else {
            console.log("Failed to fetch owner and opponent address from network request...");
        }
    }








//========================================================================================================
//================================= CHECK/CLAIM VERSUS CHALLENGE GAME ====================================
//========================================================================================================
async function claim_check() {
    var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
    //get game hash
    var my_hash = document.getElementById('my_hash').value;
    //============================ NOTIFY OPPONENT PLAYER FOR VERSUS GAME =====================================
    const apiUrl = 'https://testnet.aleoscan.io/testnet/program/aleo_monopoly_minimask1.aleo/mapping/versus_player/'+my_hash;
    console.log(apiUrl);
    try {
        // Make a fetch request to the API endpoint
        const response = await fetch(apiUrl);
    
        // Check if the request was successful (status code 200)
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }

        const inputString = await response.text();
    
// Find the index of "opponent:" in the input string
var opponentIndex = inputString.indexOf("player:"); //fetch owner address

// If "opponent:" is found, extract the opponent's address
if (opponentIndex !== -1) {
  // Define the start and end indices for the opponent's address
  var startIndex = opponentIndex + "player: ".length;
  var endIndex = inputString.indexOf(",", startIndex);

  // Extract the opponent's address using substring
  var opponentAddress = inputString.substring(startIndex, endIndex);

  console.log("Opponent's address:", opponentAddress);
} else {
  console.log("Substring 'opponent:' not found in the input string");
}


 // Check if a match is found and the captured groups are not null
if (opponentAddress !== null) {
    //main input
    var inputs = [publicKey, opponentAddress];
    var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'check_request', inputs, 100_000);

            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }     
        } else {
            console.log("Failed to fetch owner and opponent address from network request...");
        }
    
      } catch (error) {
        console.error('Error fetching data:', error.message);
      }
}







//=========================================================================================================
//======================== function to play/register tournament to check if win. ==========================
//=========================================================================================================
function tournament_play() {
  var test_play = document.getElementById('test_play').value;
  var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
        console.log(publicKey);
            if (!publicKey) {
                throw new WalletNotConnectedError();
            }
            //main input
            var inputs = [publicKey];
            var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'tournament_game', inputs, 100_000,);

            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }
}






//=========================================================================================================
//===================== function to play/register versus opponent to check if win. ========================
//=========================================================================================================
function versus_game_start() {
    var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
    var aleo_opponent = document.getElementById('aleo_opponent_start').value;
    console.log(aleo_opponent);
          console.log(publicKey);
              if (!publicKey) {
                  throw new WalletNotConnectedError();
              }
              //main input
              var inputs = [publicKey, aleo_opponent];
              var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'play_request', inputs, 200_000,);
  
              if (aleoTransaction) {
                  window.leoWallet.requestTransaction(aleoTransaction);
                  console.log('Transaction requested successfully.');
              } else {
                  console.error('request Transaction function not available.');
          }
  }







//=========================================================================================================
//====================== function to reveal hashed address from the owner to matched. =====================
//=========================================================================================================
function reveal_me() {
    var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
          console.log(publicKey);
              if (!publicKey) {
                  throw new WalletNotConnectedError();
              }
              //main input
              var inputs = [publicKey];
              var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'hashed_address', inputs, 100_000,);
  
              if (aleoTransaction) {
                  window.leoWallet.requestTransaction(aleoTransaction);
                  console.log('Transaction requested successfully.');
              } else {
                  console.error('request Transaction function not available.');
          }
  }






//=========================================================================================================
//================================= function to claim monopoly reward. ====================================
//=========================================================================================================
function claim_reward() {
    //setting amt
    var amount = document.getElementById('result').textContent; //we could fetch the balance from the past record and get the u64 amount
    var claim_token = 150000; //call from the past record to get the u64 building

    if(amount < 11000){
        alert("sorry, you are ineligible to claim reward! accumulate 11000 token!");
    }else{

      var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
        console.log(publicKey);
        
            if (!publicKey) {
                throw new WalletNotConnectedError();
            }

            //main input
            var inputs = [publicKey, `${claim_token}u64`];

            var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'mint_reward', inputs, 100_000,);
            
            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }
}
}




//================================================================================================
//============================= ROLL DICE SIMULATION FUNCTIONS ===================================
//================================================================================================
// Function to generate a random number between 1 and 6 using dice rolls
function rollDice() {
    return Math.floor(Math.random() * 6) + 1;
}

// Function to create a sophisticated encrypted integer using dice rolls
function createEncryptedInteger() {
    let encryptedInt = '';
    for (let i = 0; i < 6; i++) {
        encryptedInt += rollDice().toString();
    }
    return encryptedInt;
}

// Function to split the encrypted integer into an array
function splitEncryptedInteger(encryptedInt) {
    return encryptedInt.split('').map(Number);
}



  
//=================================================================================================
//======================= function to mystery card out of 3 choices... ============================
//=================================================================================================
  // Function to enable the mystery card link
  function enableMysteryCardLink() {
    const mysteryCardLink = document.getElementById('mysteryCardLink');

    // Enable the link
    mysteryCardLink.removeAttribute('disabled');
  }

// Function to add or deduct rent based on the specified conditions
function mysteryOperation(array) {
    //setting amt
    var amount = document.getElementById('result').textContent; //we could fetch the balance from the past record and get the u64 amount
    var building = 1; //call from the past record to get the u64 building

    const firstInt = array[0];
    const lastInt = array[array.length - 1];
    const result = Math.floor((firstInt + lastInt) / 2);

        // Deduct rent ~ aleo deduct rent function
        var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
        console.log(publicKey);
            if (!publicKey) {
                throw new WalletNotConnectedError();
            }
            var inputs = [publicKey, `${amount}u64`, `${building}u64`];
            
            var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'mystery_card', inputs, 100_000,);
            
            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }
        return 'Mytery card... processing...';  
}

const mysteryCardLink = document.getElementById("mysteryCardLink");
// Re-disable the link after it's clicked
mysteryCardLink.setAttribute('disabled', true);

mysteryCardLink.addEventListener("click", () => {
    const originalInt = Math.floor(Math.random() * 1000000); // Generate a random integer (for demonstration)
    const encryptedInt = createEncryptedInteger();
    const encryptedArray = splitEncryptedInteger(encryptedInt);
    const mysteryAction = mysteryOperation(encryptedArray);

    console.log(`Encrypted Integer: ${encryptedInt}`);
    console.log(`Encrypted Array: ${encryptedArray.join(', ')}`);
    console.log(`Mystery Action: ${mysteryAction}`);
});
// Enable the link initially after 2 minutes
setTimeout(enableMysteryCardLink, 2 * 60 * 1000);






//==========================================================================================================
//==================== Function to add or deduct rent based on the specified conditions ====================
//==========================================================================================================

function rentOperation() {
    //setting amt
    var amount = document.getElementById('result').textContent; //we could fetch the balance from the past record and get the u64 amount
    var building = 1; //call from the past record to get the u64 building

        // Deduct rent ~ aleo deduct rent function
        var publicKey = window.leoWallet.publicKey; // Replace with the actual public key
        console.log(publicKey);
            if (!publicKey) {
                throw new WalletNotConnectedError();
            }
            var inputs = [publicKey, `${amount}u64`, `${building}u64`];
            
            var aleoTransaction = Transaction.createTransaction(publicKey, 'testnetbeta', 'aleo_monopoly_minimask1.aleo', 'monopoly_rent', inputs, 200_000,);
            
            if (aleoTransaction) {
                window.leoWallet.requestTransaction(aleoTransaction);
                console.log('Transaction requested successfully.');
            } else {
                console.error('request Transaction function not available.');
        }
        return 'Checking Rent...';
    }

const encryptButton = document.getElementById("encryptButton");
encryptButton.addEventListener("click", () => {
    const originalInt = Math.floor(Math.random() * 1000000); // Generate a random integer (for demonstration)
    const encryptedInt = createEncryptedInteger();
    const encryptedArray = splitEncryptedInteger(encryptedInt);
    const rentAction = rentOperation(encryptedArray);

    console.log(`Encrypted Integer: ${encryptedInt}`);
    console.log(`Encrypted Array: ${encryptedArray.join(', ')}`);
    console.log(`Rent Action: ${rentAction}`);
});

