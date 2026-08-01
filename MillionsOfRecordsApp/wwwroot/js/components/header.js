document.addEventListener("DOMContentLoaded", function () {
    /**
     * Ported from fetchFilteredAlbums in Header.js
     * Handles individual API calls for search suggestions and pagination.
     */
    const fetchFilteredAlbums = async (url, val, page, limit = 10, isLoad = false) => {
        // 1. Replicate setIsLoading(true)
        if (isLoad) toggleLoadingState(true);

        try {
            // Construct the URL exactly like the React version
            // Note: We use & instead of ? for params because window.AppConfig urls 
            // already end with '?search=' or similar.
            const response = await fetch(`${url}${encodeURIComponent(val)}&page=${page}&limit=${limit}`);

            if (!response.ok) throw new Error("Network response was not ok");

            return await response.json();
        } catch (error) {
            console.error("Fetch Error:", error);
            return null;
        } finally {
            // 2. Replicate setIsLoading(false)
            if (isLoad) toggleLoadingState(false);
        }
    };
    /**
     * Creates the initial skeleton with loaders so the user sees 
     * the tabs and the spinner while the first fetch happens.
     */
    function initializeEmptyTabs() {
        const tabs = ['albumsTab', 'artistsTab', 'labelsTab', 'genreTab'];
        tabs.forEach(id => {
            const container = document.getElementById(id);
            container.innerHTML = `
            <div class="tab-body">
                <div class="loader active">
                    <div class="scale-loader"><div></div><div></div><div></div></div>
                </div>
            </div>`;
        });
    }
    /**
     * Helper to handle the UI loading state
     * Targets the .loader divs inside our tab panes
     */
    function toggleLoadingState(isLoading) {
        // We target all loaders in the suggestion box
        const loaders = document.querySelectorAll('#searchSuggestions .loader');

        loaders.forEach(loader => {
            if (isLoading) {
                loader.classList.add('active'); // CSS will set display: flex
            } else {
                loader.classList.remove('active'); // CSS will set display: none
            }
        });

        // Optional: Dim the existing list while loading new pages
        const lists = document.querySelectorAll('.suggestions-list');
        lists.forEach(list => {
            list.style.opacity = isLoading ? "0.5" : "1";
        });
    }
    /**
     * Ported from handlePagination in Header.js
     * @param {string} tabId - The ID of the tab to refresh (e.g., 'albumsTab')
     * @param {string} urlKey - The key in AppConfig (e.g., 'ALBUM_SUGGESTIONS')
     * @param {number} page - The new page number
     * @param {number} limit - Items per page
     */
    window.handleSearchPagination = async (tabId, urlKey, page, limit) => {
        const searchVal = document.querySelector('#headerSearch').value;
        const url = window.AppConfig[urlKey];

        // fetchFilteredAlbums is our helper that handles the loading state
        const result = await fetchFilteredAlbums(url, searchVal, page, limit, true);

        if (result) {
            // Map the tabId to the specific rendering settings
            const settings = {
                "albumsTab": { img: "frontImg", title: "artistTitle", prefix: "album-details" },
                "artistsTab": { img: null, title: "artistTitle", prefix: "artist" },
                "labelsTab": { img: null, title: "artistTitle", prefix: "label" },
                "genreTab": { img: null, title: "artistTitle", prefix: "genre" }
            };

            const s = settings[tabId];
            // Re-render just this specific tab content
            renderSpecificTab(tabId, result, s.img, s.title, s.prefix, true, urlKey);
        }
    };

    /**
     * Main UI Renderer - Replaces SuggestionTab.js component
     */
    function renderSuggestions(combinedData) {
        const { albumsData, artistData, labelData, genreData } = combinedData;

        // Render each tab using the logic from SuggestionTab.js
        renderSpecificTab("albumsTab", albumsData, "frontImg", "artistTitle", "title", true, "ALBUM_SUGGESTIONS");
        renderSpecificTab("artistsTab", artistData, null, "artistTitle", "artist", false, "ARTIST_SUGGESTIONS");
        renderSpecificTab("labelsTab", labelData, null, "artistTitle", "label", false, "LABEL_SUGGESTIONS");
        renderSpecificTab("genreTab", genreData, null, "artistTitle", "genre", false, "GENRE_SUGGESTIONS");
    }
    function renderSpecificTab(containerId, data, imageKey, titleKey, linkPrefix, isActive, urlKey) {
        const container = document.getElementById(containerId);
        if (!container) return;

        let html = `<div class="tab-body">`;

        // 1. Loader Logic (Ported as CSS Spinner)
        html += `
        <div class="loader">
            <div class="scale-loader"><div></div><div></div><div></div></div>
        </div>`;

        if (data?.status === "Success") {
            html += `<ul class="suggestions-list ${imageKey ? "" : "no-img"}">`;
            data.data.forEach(item => {
                if (imageKey) {
                    // Albums style link
                    html += `
                    <li>
                        <a href="/shop?${linkPrefix}=${encodeURIComponent(item[titleKey])}">
                            <img src="${item[imageKey]}" alt="" /> ${item[titleKey]}
                        </a>
                    </li>`;
                } else {
                    // Artist/Label/Genre style link
                    html += `
                    <li>
                        <a href="/shop?${linkPrefix}=${encodeURIComponent(item[titleKey])}">
                            ${item[titleKey]} (${item.count || 0})
                        </a>
                    </li>`;
                }
            });
            html += `</ul>`;
        } else if (data?.status === "Not Found") {
            html += `<h5>No results found for your search</h5>`;
        }

        html += `</div>`; // Close tab-body

        // 2. Pagination Logic (Ported from renderPagination)
        if (data?.pagination?.total > data?.pagination?.per_page) {
            const p = data.pagination;
            const limit = p.per_page || 10; // Fallback to 10 if missing
            html += `
            <div class="btn-block">
                <button onclick="window.handleSearchPagination('${containerId}', '${urlKey}', ${p.current_page - 1}, ${limit})" 
                        ${p.current_page === 1 ? 'disabled' : ''}>
                    <i class="fa fa-angle-left"></i> Previous
                </button>
                <span>Page ${p.current_page} of ${p.last_page}</span>
                <button onclick="window.handleSearchPagination('${containerId}', '${urlKey}', ${p.current_page + 1}, ${limit})" 
                        ${p.current_page === p.last_page ? 'disabled' : ''}>
                    Next <i class="fa fa-angle-right"></i>
                </button>
            </div>`;
        }

        container.innerHTML = html;
    }
    // --- 1. Mobile Menu Toggle ---
    const mobileToggle = document.querySelector('.mobile-toggle');
    const navMenu = document.querySelector('#nav');

    if (mobileToggle && navMenu) {
        mobileToggle.addEventListener('click', function () {
            this.classList.toggle('is-active');
            navMenu.classList.toggle('is-active');
            document.body.classList.toggle('overflow-y');
        });
    }
    
    // --- 2. Search Logic (Debounced) ---
    const searchInput = document.querySelector('#headerSearch');
    const clearBtn = document.querySelector('#clearSearch');
    const suggestionBox = document.querySelector('#searchSuggestions');
    let debounceTimer;

    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const value = e.target.value;

            // A. Handle the Clear Button (X) visibility immediately
            if (clearBtn) clearBtn.style.display = value ? 'block' : 'none';

            // B. Clear the timer every time the user types
            clearTimeout(debounceTimer);

            // C. Length check: Only act if we have > 2 characters
            if (value.length > 2) {
                // 1. Show the suggestion box immediately
                suggestionBox.style.display = 'block';

                // 2. INITIALIZE the tabs with loaders if they are empty
                // This ensures toggleLoadingState finds the .loader divs!
                if (document.getElementById('albumsTab').innerHTML === "") {
                    initializeEmptyTabs();
                }
                // 3. Start the debounce timer for the API calls
                debounceTimer = setTimeout(async () => {
                    // Re-get value inside timer to ensure we have the latest
                    const latestValue = searchInput.value;
                    console.log("Fetching all suggestions for:", latestValue);
                    toggleLoadingState(true);

                    try {
                        const [albumsData, artistData, labelData, genreData] = await Promise.all([
                            fetchFilteredAlbums(window.AppConfig.ALBUM_SUGGESTIONS, latestValue, 1, 10),
                            fetchFilteredAlbums(window.AppConfig.ARTIST_SUGGESTIONS, latestValue, 1, 20),
                            fetchFilteredAlbums(window.AppConfig.LABEL_SUGGESTIONS, latestValue, 1, 20),
                            fetchFilteredAlbums(window.AppConfig.GENRE_SUGGESTIONS, latestValue, 1, 20)
                        ]);

                        const combinedData = { albumsData, artistData, labelData, genreData };
                        //debugger;
                        if (typeof renderSuggestions === "function") {
                            renderSuggestions(combinedData);
                        }

                    } catch (err) {
                        console.error("Multi-fetch search error:", err);
                    } finally {
                        toggleLoadingState(false);
                    }

                    const value = searchInput.value;
                    
                }, 500);
            } else {
                // D. If input is cleared or too short, hide the box
                if (suggestionBox) suggestionBox.style.display = 'none';
            }
        });
    }
    if (clearBtn) {
        clearBtn.addEventListener('click', () => {
            searchInput.value = '';
            clearBtn.style.display = 'none';
            if (suggestionBox) suggestionBox.style.display = 'none';
        });
    }
    // --- 3. Category Popups ---
    document.querySelectorAll('.category-popup-trigger').forEach(btn => {
        btn.addEventListener('click', function () {
            const url = this.getAttribute('data-url');
            const title = this.getAttribute('data-title');

            // Logic to be linked to your ContentPopup partial port
            console.log("Opening popup for:", title, url);
            if (typeof openContentPopup === "function") {
                openContentPopup(title, url);
            }
        });
    });
    // Helper to close
    window.closeContentPopup = () => {
        const modal = document.getElementById('contentPopup');
        modal.close();
        document.body.style.overflow = 'auto'; // Re-enable scroll
    };
});
