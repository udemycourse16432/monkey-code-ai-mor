$(function () {
    $(".album .content strong").matchHeight({ property: "height" });
});
async function callCartApi(payload, route) {
    try {
        const response = await fetch(`/api/cart/${route}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        if (!response.ok) throw new Error('Network response was not ok');
        return await response.json();
    } catch (error) {
        console.error("Cart API Error:", error);
        throw error; // Let the caller decide how to handle the UI alert
    }
}
async function addToCart(itemId, price, type, searchId, artistTitle) {

    try {
        const data = await callCartApi({ id: itemId, price, type, qty: 1, searchId }, 'add');

        if (data.message === "OK") {

            // 1. UPDATE THE HEADER COUNT (The magic part)
            updateHeaderCartCount(data.cartCount);

            // 2. Update the button to "IN YOUR CART"
            const btnContainer = document.getElementById("btn-container-" + itemId);
            if (btnContainer) {
                btnContainer.innerHTML = `
            <a href="/Cart" class="btn btn-in-cart">
                <span class="icon-wrap"><i class="fa fa-check"></i></span>
                <span class="text-wrap">IN YOUR CART</span>
            </a>`;
            }

            // Using your ArtistTitle logic
            toastr.success(`‘${artistTitle}’ has been successfully added to your cart.`, "Album Added to Cart");
        }
    } catch (error) {
        console.error("Cart Error:", error);
        alert("Could not update cart.");
    }
}

async function updateCartQuantity(button, itemId, price, type) {
    let newQty;
    let span;

    const container = button.closest('.quantity-input');
    if (type === 0) {
        // Special case: Delete button clicked
        newQty = 0;
    } else {
        // Increment/Decrement logic
        span = container.querySelector('span');
        const currentQty = parseInt(span.innerText);
        newQty = (type === 1) ? currentQty + 1 : currentQty - 1;
        if (newQty < 0) newQty = 0;
    }

    try {
        const data = await callCartApi({ id: itemId, price, type, qty: newQty, searchId: "-" }, 'adjust');

        if (data.message === "OK") {

            // Update Header Count
            updateHeaderCartCount(data.cartCount);

            if (data.cartCount === 0) {
                window.location.reload(); // Re-renders the page from the server
            } else {
                // Update UI
                if (newQty === 0) {
                    // Remove the entire row (assuming your row has an ID like 'row-item.Id')
                    document.getElementById(`row-${itemId}`)?.remove();
                } else {
                    // Update the span
                    span.innerText = newQty;

                    // Toggle between Trash icon and Minus icon for the decrease button
                    const decBtn = container.querySelector('.decrease-quantity');
                    if (newQty === 1) {
                        decBtn.classList.remove('fa-minus');
                        decBtn.classList.add('fa-trash');
                    } else {
                        decBtn.classList.remove('fa-trash');
                        decBtn.classList.add('fa-minus');
                    }
                }
                updateCartSummaryUI(data);
            }
        }
    } catch (error) {
        console.error("Cart Error:", error);
    }
}
function updateCartSummaryUI(data) {

    // 2. Update Summary Table (if we are on the Cart page)
    const productPriceEl = document.getElementById('summary-products-price');
    const shippingFeeEl = document.getElementById('summary-shipping-fee');
    const totalAmountEl = document.getElementById('summary-total-amount');

    if (productPriceEl) productPriceEl.innerText = `$${data.productsPrice}`;
    if (shippingFeeEl) shippingFeeEl.innerText = `$${data.shippingFee}`;
    if (totalAmountEl) totalAmountEl.innerText = `$${data.totalAmount}`;
}
function updateHeaderCartCount(count) {
    const cartElement = document.querySelector('#cartCount');
    if (cartElement) {
        cartElement.innerText = count;
    }
}
