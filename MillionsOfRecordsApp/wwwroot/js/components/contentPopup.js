// Global Popup State (Replaces React useState)
let popupState = {
    url: "",
    title: "",
    isVisible: false,
    dataList: { data: [], pagination: {} },
    filters: { order: 2, alpha: 0, limit: 140, page: 1 }
};

const genreList = ["Reggae", "Rock", "Jazz", "Soul", "Blues", "Electronic", "Pop"];

const letters = "abcdefghijklmnopqrstuvwxyz".split("");

// The hardcoded categories from your React ContentPopup.js
const categoriesList = [
    {
        title: "View All",
        links: [
            { label: "View All Items", query: "" },
            { label: "View All LPs", query: "format=LP" },
            { label: "View All CDs", query: "format=CD" },
            { label: 'View All 12"/10"', query: `format=${encodeURIComponent("12\",10\"")}` },
            { label: 'View All 7"', query: `format=${encodeURIComponent("7\"")}` },
        ],
    },
    {
        title: "New Arrivals",
        links: [
            { label: "New Arrival LPs", query: "format=LP&order=2" },
            { label: "New Arrival CDs", query: "format=CD&order=2" },
            { label: 'New Arrival 12"/10"', query: `format=${encodeURIComponent("12\",10\"")}&order=2` },
            { label: 'New Arrival 7"', query: `format=${encodeURIComponent("7\"")}&order=2` },
        ],
    },
    {
        title: "Best Selling",
        links: [
            { label: "Best Selling LPs", query: "format=LP&order=3" },
            { label: "Best Selling CDs", query: "format=CD&order=3" },
            { label: 'Best Selling 12"/10"', query: `format=${encodeURIComponent("12\",10\"")}&order=3` },
            { label: 'Best Selling 7"', query: `format=${encodeURIComponent("7\"")}&order=3` },
        ],
    },
    {
        title: "Special Features",
        links: [
            { label: "180 Gram Vinyl", query: "feaitem=180-gram vinyl" },
            { label: "Colored Vinyl", query: "feaitem=Colored Vinyl" },
            { label: "Limited Edition Vinyl", query: "feaitem=Limited Edition" },
        ],
    },
    {
        title: "Deals",
        links: [
            { label: "LPs $14.99 or Less", query: "format=LP&max_price=16" },
            { label: "CDS Under $5", query: "format=CD&max_price=5" },
            { label: 'Used 7"', query: `format=${encodeURIComponent("7\"")}&order=4` },
        ],
    },
];

/**
 * Replaces the React useEffect/fetchData combo
 */
window.openContentPopup = async (title, url) => {
    popupState.title = title;
    popupState.url = url;
    popupState.filters.page = 1; // Reset to page 1 on new open

    const modal = document.getElementById('contentPopup');
    if (modal) {
        modal.showModal();
        document.body.style.overflow = 'hidden';
        await fetchPopupData();
    }
};

async function fetchPopupData() {
    renderPopupLoading();

    const isGenre = genreList.includes(popupState.title);
    if (isGenre) {
        popupState.filters.limit = 105;
    } else {
        popupState.filters.limit = 140;
    }

    const { order, alpha, limit, page } = popupState.filters;
    // 1. Determine if we need '?' or '&' to start appending
    // If the base URL doesn't have a '?', start with '?', otherwise use '&'
    const separator = popupState.url.includes('?') ? '&' : '?';
    let finalUrl = `${popupState.url}${separator}order=${order}&alpha=${alpha}&limit=${limit}&page=${page}`;
    // 3. Append genre if applicable
    if (isGenre) {
        finalUrl += `&genre=${encodeURIComponent(popupState.title)}`;
    }
    console.log("Requesting Popup Data from:", finalUrl);
    try {
        const response = await fetch(finalUrl);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        popupState.dataList = await response.json();
        renderPopupList();
    } catch (error) {
        console.error("Popup fetch error:", error);
        document.getElementById('popupDataContainer').innerHTML = `<h5 class="text-danger">Failed to load data. Please try again.</h5>`;
    }
}

/**
 * Replaces renderListView()
 */
function renderPopupList() {
    const container = document.getElementById('popupDataContainer');
    const loader = document.getElementById('popupLoader');
    const { dataList, title, filters } = popupState;

    // Update Title with Count from API
    document.getElementById('popupTitle').innerText =
        `${title} (${dataList.pagination?.total || 0})`;

    const isGenre = genreList.includes(title);
    const key = title.toLowerCase().includes("genre") ? "genre" :
        title.toLowerCase().includes("label") ? "label" : "artist"; // : "label"

    // Matching the PrimeReact inner structure
    let html = `<div class="popup-content ${isGenre ? 'filter-popup' : ''}">`;
    html += `<div class="popup-body" style="overflow: auto;">`; // Added wrapper

    // 1. Popup Head (Sticky section)
    html += `<div class="popup-head">`;

    // Alpha Filter
    html += `<ul class="alpha-filter">
        <li><button class="${filters.alpha === 0 ? 'active' : ''}" onclick="updatePopupFilter([{key:'alpha', value:0}])">All</button></li>`;
    letters.forEach(l => {
        html += `<li><button class="${filters.alpha === l ? 'active' : ''}" onclick="updatePopupFilter([{key:'alpha', value:'${l}'},{key:'order', value:1}])">${l}</button></li>`;
    });
    html += `</ul>`; // Close alpha-filter

    // Genre Links
    if (isGenre) {
        html += `<ul class="filter-list">`;
        categoriesList.forEach(cat => {
            html += `<li><ul>`;
            cat.links.forEach(link => {
                // Ensure URL encoding for complex genre names
                html += `<li><a href="/shop?genre=${encodeURIComponent(title)}${link.query ? `&${link.query}` : ""}" onclick="closeContentPopup()">${link.label}</a></li>`;
            });
            html += `</ul></li>`;
        });
        html += `</ul>`; // Close filter-list
    }
    html += `</div>`; // Close popup-head

    // 2. Sort Bar
    html += `
        <div class="sortby-container">
            <button class="${filters.order === 2 ? 'active' : ''}" onclick="updatePopupFilter([{key:'order', value:2},{key:'alpha', value:0}])">
                <i class="fa fa-sort-amount-desc"></i> Sort by Most Popular
            </button>
            <button class="${filters.order === 1 ? 'active' : ''}" onclick="updatePopupFilter([{key:'order', value:1}])">
                <i class="fa fa-sort-alpha-asc"></i> Sort by Alphabetical
            </button>
        </div>`; // Close sortby-container

    // 3. Data List
    html += `<ul class="data-list">`;
    dataList.data.forEach(item => {
        const val = Object.values(item)[1];
        html += `<li><i class="fa fa-music"></i> 
            <a href="/shop?${key}=${encodeURIComponent(val)}${isGenre ? '&genre=' + encodeURIComponent(title) : ''}" onclick="closeContentPopup()">${val} (${item.count})</a>
        </li>`;
    });
    html += `</ul>`; // Close data-list
    html += `</div>`; // Close popup-body

    // 4. Footer (Pagination)
    if (dataList.pagination) {
        const p = dataList.pagination;
        html += `
            <div class="popup-footer">
                <button ${p.current_page === 1 ? 'disabled' : ''} onclick="updatePopupFilter([{key:'page', value:${p.current_page - 1}}])">
                    <i class="fa fa-angle-left"></i> Previous
                </button>
                <span>Page ${p.current_page} of ${p.last_page}</span>
                <button ${p.current_page === p.last_page ? 'disabled' : ''} onclick="updatePopupFilter([{key:'page', value:${p.current_page + 1}}])">
                    Next <i class="fa fa-angle-right"></i>
                </button>
            </div>`;
    }

    html += `</div>`; // Close popup-content
    container.innerHTML = html;
    container.style.opacity = '1';
    if (loader) loader.style.display = 'none';
}

// Helper to update filters and re-fetch (replaces onFilterValuesUpdate)
window.updatePopupFilter = (filters) => {
    filters.forEach((item) => {
        popupState.filters[item.key] = item.value;
        if (item.key !== 'page') popupState.filters.page = 1; // Reset page if filter changes
    });
    fetchPopupData();
};

function renderPopupLoading() {
    // Show the overlay instead of replacing innerHTML
    const loader = document.getElementById('popupLoader');
    if (loader) loader.style.display = 'flex';

    // Optional: add a class to dim the old content while loading
    const container = document.getElementById('popupDataContainer');
    if (container) container.style.opacity = '0.4';
}