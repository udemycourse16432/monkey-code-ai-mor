async function initPayPal() {
    try {
        const paypalButtons = window.paypal.Buttons({
            style: {
                shape: "rect",
                layout: "vertical",
                color: "gold",
                label: "paypal",
            },
            fundingSource: undefined,
            message: {
                amount: 100,
            },
            onClick: function (data, actions) {
                // Freeze the shipping UI immediately
                toggleShippingFreeze(true);

                // You can also perform a final validation here
                const selectedShipping = document.querySelector('input[name="SelectedShippingCode"]:checked');
                if (!selectedShipping) {
                    alert("Please select a shipping method first.");
                    return actions.reject();
                }
                return actions.resolve();
            },
            onCancel(data) {
                // IMPORTANT: If they close the card form/popup, unfreeze so they can fix mistakes
                toggleShippingFreeze(false);
            },

            onError(err) {
                // Unfreeze on error so the user can try a different method or shipping
                toggleShippingFreeze(false);
                console.error("PayPal Error:", err);
            },
            async createOrder() {
                try {
                    const selectedShippingInput = document.querySelector('input[name="SelectedShippingCode"]:checked');
                    const selectedShipping = selectedShippingInput ? selectedShippingInput.value : "MM";
                    const response = await fetch("/api/checkout/create-order", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify({ shippingCode: selectedShipping }),
                    });

                    const orderData = await response.json();

                    if (orderData.id) {
                        return orderData.id;
                    }
                    const errorDetail = orderData?.details?.[0];
                    const errorMessage = errorDetail
                        ? `${errorDetail.issue} ${errorDetail.description} (${orderData.debug_id})`
                        : JSON.stringify(orderData);

                    throw new Error(errorMessage);
                } catch (error) {
                    console.error(error);
                    // resultMessage(`Could not initiate PayPal Checkout...<br><br>${error}`);
                }
            },
            async onApprove(data, actions) {
                try {
                    const response = await fetch(
                        `/api/checkout/capture-order/${data.orderID}`,
                        {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                            },
                        }
                    );

                    const orderData = await response.json();
                    console.log('OnApprove:response:', orderData);

                    // Three cases to handle:
                    //   (1) Recoverable INSTRUMENT_DECLINED -> call actions.restart()
                    //   (2) Other non-recoverable errors -> Show a failure message
                    //   (3) Successful transaction -> Show confirmation or thank you message
                    const errorDetail = orderData?.details?.[0];

                    if (errorDetail?.issue === "INSTRUMENT_DECLINED") {
                        // (1) Recoverable INSTRUMENT_DECLINED -> call actions.restart()
                        // recoverable state, per
                        // https://developer.paypal.com/docs/checkout/standard/customize/handle-funding-failures/
                        return actions.restart();
                    } else if (errorDetail) {
                        // (2) Other non-recoverable errors -> Show a failure message
                        throw new Error(
                            `${errorDetail.description} (${orderData.debug_id})`
                        );
                    } else if (!orderData.purchaseUnits) {
                        throw new Error(JSON.stringify(orderData));
                    } else {
                        // (3) Successful transaction -> Show confirmation or thank you message
                        // Or go to another URL:  actions.redirect('thank_you.html');
                        const transaction =
                            orderData?.purchaseUnits?.[0]?.payments?.captures?.[0] ||
                            orderData?.purchaseUnits?.[0]?.payments
                                ?.authorizations?.[0];
                        resultMessage(
                            `Transaction ${transaction.status}: ${transaction.id}<br>
          <br>See console for all available details`
                        );
                        console.log(
                            "Capture result",
                            orderData,
                            JSON.stringify(orderData, null, 2)
                        );
                        alert(`Transaction ${transaction.status}: ${transaction.id}`);

                        window.location.href = `/checkout/success?orderNumber=${transaction.customId}`;
                    }
                } catch (error) {
                    console.error(error);
                    resultMessage(
                        `Sorry, your transaction could not be processed...<br><br>${error}`
                    );
                }
            },


        });
        paypalButtons.render("#paypal-button-container");


        // Example function to show a result to the user. Your site's UI library can be used instead.
        function resultMessage(message) {
            const container = document.querySelector("#result-message");
            container.innerHTML = message;
        }
    } catch (error) {
        console.error("SDK Init Failed", error);
    }
}
function toggleShippingFreeze(isFrozen) {
    const shippingContainer = document.querySelector(".shipping-methods");
    const inputs = shippingContainer.querySelectorAll('input[name="SelectedShippingCode"]');

    if (isFrozen) {
        // Disable all radio buttons
        inputs.forEach(input => input.disabled = true);
        // Add a visual cue (grey out)
        shippingContainer.style.opacity = "0.5";
        shippingContainer.style.pointerEvents = "none";
        // Optional: Add a small message
        const lockMsg = document.querySelector("#shipping-lock-message") || document.createElement("small");
        lockMsg.id = "shipping-lock-message";
        lockMsg.innerText = " (Locked for payment)";
        shippingContainer.previousElementSibling.appendChild(lockMsg);
    } else {
        inputs.forEach(input => input.disabled = false);
        shippingContainer.style.opacity = "1";
        shippingContainer.style.pointerEvents = "auto";
        document.querySelector("#shipping-lock-message")?.remove();
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const shippingRadios = document.querySelectorAll('input[name="SelectedShippingCode"]');

    shippingRadios.forEach(radio => {
        radio.addEventListener('change', (e) => {
            // 1. Manually ensure the checked attribute is updated (for some legacy CSS)
            shippingRadios.forEach(r => r.removeAttribute('checked'));
            e.target.setAttribute('checked', 'checked');

            // 2. Update the Cart Summary Display
            updateSummaryDisplay(e.target.dataset.price);
        });
    });
});

function updateSummaryDisplay(newShippingPrice) {
    const shippingDisplay = document.querySelector('#shipping-cost-display'); // Add this ID to your HTML
    const totalDisplay = document.querySelector('#total-amount-display'); // Add this ID to your HTML
    const productsPriceDisplay = document.querySelector('#products-price-display');
    const taxDisplay = document.querySelector('#tax-amount-display');
    const productPrice = parseFloat(productsPriceDisplay.dataset.value);

    const shipping = parseFloat(newShippingPrice);
    const tax = taxDisplay ? parseFloat(taxDisplay.dataset.value) : 0;
    const total = productPrice + shipping + tax;

    if (shippingDisplay) shippingDisplay.innerText = `$${shipping.toFixed(2)}`;
    if (totalDisplay) totalDisplay.innerText = `$${total.toFixed(2)}`;
}

//async function initPayPal2() {
//    try {
//        const sdkInstance = await window.paypal.createInstance({
//            clientId: window.AppConfig.PAYPAL_CLIENT_ID,
//            components: [
//                "paypal-payments",       // Handles PayPal & Pay Later
//                "venmo-payments",        // Handles Venmo (US Only)
//                "paypal-guest-payments"  // Handles Standalone Card Buttons
//            ],
//            pageType: "checkout",
//            currency: "USD" // High priority: Helps determine eligibility
//        });

//        const paymentMethods = await sdkInstance.findEligibleMethods({
//            currencyCode: "USD",
//        });

//        console.log("Eligible Methods:", paymentMethods);

//        if (paymentMethods.isEligible("paypal")) {
//            setUpPayPalButton(sdkInstance);
//        }
//        if (paymentMethods.isEligible("credit")) {
//            setUpCardButton(sdkInstance);
//        }

//        const loader = document.getElementById("paypal-loading");
//        if (loader) loader.style.display = "none";

//    } catch (error) {
//        console.error("SDK Init Failed", error);
//    }
//}


//const paymentSessionOptions = {
//    async onApprove(data) {
//        try {
//            await captureOrder({ orderId: data.orderId });
//        } catch (error) {
//            console.error("Capture failed:", error);
//            alert("Payment failed to finalize.");
//        }
//    },
//    onCancel(data) { console.log("Cancelled:", data); },
//    onError(error) { console.error("Error:", error); },
//    async onShippingAddressChange(data) {
//        console.log("User changed address in PayPal:", data.shippingAddress);

//        // 1. Send the new city/state/zip to your C# ShippingService
//        const response = await fetch("/api/checkout/update-shipping", {
//            method: "POST",
//            headers: { "Content-Type": "application/json" },
//            body: JSON.stringify({
//                city: data.shippingAddress.city,
//                state: data.shippingAddress.state,
//                postalCode: data.shippingAddress.postalCode,
//                countryCode: data.shippingAddress.countryCode
//            })
//        });

//        const updatedTotals = await response.json();

//        // 2. Return the new "Truth" to PayPal so the popup reflects the new price
//        return {
//            amount: {
//                currency_code: "USD",
//                value: updatedTotals.finalTotal,
//                breakdown: {
//                    item_total: { currency_code: "USD", value: updatedTotals.productPrice },
//                    shipping: { currency_code: "USD", value: updatedTotals.newShippingCost }
//                }
//            }
//        };
//    }
//};
//async function setUpCardButton(sdkInstance) {
//    try {
//        // Double check the method name: createPayPalGuestPaymentSession
//        const cardSession = sdkInstance.createPayPalGuestPaymentSession(paymentSessionOptions);

//        const cardButton = document.querySelector("paypal-card-button");
//        if (cardButton) {
//            cardButton.removeAttribute("hidden");
//            cardButton.addEventListener("click", async () => {
//                await cardSession.start({ presentationMode: "auto" }, createOrder());
//            });
//        }
//    } catch (e) {
//        console.warn("Card session creation failed. Check if component 'paypal-guest-payments' is loaded.");
//    }
//}
//async function setUpPayPalButton(sdkInstance) {
//    // FIX 1: Define the session variable clearly
//    const paypalSession = sdkInstance.createPayPalOneTimePaymentSession(paymentSessionOptions);
    
//    const paypalButton = document.querySelector("paypal-button");

//    if (paypalButton) {
//        paypalButton.removeAttribute("hidden");

//        paypalButton.addEventListener("click", async () => {
//            try {
//                // FIX 2: Use the CORRECT variable name here (paypalSession)
//                // FIX 3: createOrder() must be passed as a promise resolving to { orderId }
//                await paypalSession.start(
//                    { presentationMode: "auto" },
//                    createOrder()
//                );
//            } catch (error) {
//                console.error("PayPal payment start error:", error);
//            }
//        });
//    }
//}

// --- Backend API Wrappers ---

//async function createOrder() {
//    const selectedShippingInput = document.querySelector('input[name="SelectedShippingCode"]:checked');
//    const selectedShipping = selectedShippingInput ? selectedShippingInput.value : "MM";

//    const response = await fetch("/api/checkout/create-order", {
//        method: "POST",
//        headers: { "Content-Type": "application/json" },
//        body: JSON.stringify({ shippingCode: selectedShipping })
//    });

//    if (!response.ok) throw new Error("Failed to create order");
//    const data = await response.json();

//    // V6 Requirement: Resolve to an object with orderId
//    return { orderId: data.id };
//}

//async function captureOrder({ orderId }) {
//    const response = await fetch(`/api/checkout/capture-order/${orderId}`, {
//        method: "POST"
//    });

//    if (!response.ok) throw new Error("Capture failed");
//    const data = await response.json();

//    window.location.href = `/checkout/success?orderNumber=${data.orderNumber}`;
//}

