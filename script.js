let accountBalance = 1000; // Initial account balance
let ownedCryptos = {}; // Track owned cryptos and quantities

// Update the dashboard
function updateDashboard() {
    document.getElementById("account-balance").innerText = accountBalance.toFixed(2);
    document.getElementById("owned-cryptos").innerText = Object.keys(ownedCryptos).length
        ? Object.entries(ownedCryptos)
              .map(([crypto, quantity]) => `${crypto} (x${quantity})`)
              .join(", ")
        : "None";
}

// Increment function
function increment(element) {
    const amountElem = element.parentElement.querySelector(".amount");
    let amount = parseInt(amountElem.innerText);
    amount += 1;
    amountElem.innerText = amount;
    updateCostDisplay(element, amount);
}

// Decrement function
function decrement(element) {
    const amountElem = element.parentElement.querySelector(".amount");
    let amount = parseInt(amountElem.innerText);
    if (amount > 1) { // Ensure amount does not go below 1
        amount -= 1;
        amountElem.innerText = amount;
        updateCostDisplay(element, amount);
    }
}

// Update cost display
function updateCostDisplay(element, amount) {
    const costElem = element.closest(".card-content").querySelector(".cost");
    const unitCost = parseFloat(element.closest(".card").dataset.price);
    costElem.innerText = `Cost per Unit: $${(amount * unitCost).toFixed(2)}`;
}

// Buy item function
function buyItem(element, cryptoName, unitCost) {
    const amount = parseInt(element.parentElement.querySelector(".amount").innerText);
    const totalCost = unitCost * amount;
    
    if (accountBalance >= totalCost) {
        accountBalance -= totalCost;
        
        // Update owned cryptos
        if (ownedCryptos[cryptoName]) {
            ownedCryptos[cryptoName] += amount;
        } else {
            ownedCryptos[cryptoName] = amount;
        }

        updateDashboard();
        alert(`Purchased ${amount} unit(s) of ${cryptoName} for $${totalCost.toFixed(2)}!`);
    } else {
        alert("Insufficient balance!");
    }
}

// Initialize dashboard on load
document.addEventListener("DOMContentLoaded", updateDashboard);