//const onHandleFilter = (e) => {
//    const { name, value } = e.target;
//    setSearchParams((prevParams) => {
//        const params = new URLSearchParams(prevParams);
//        if (value !== "") {
//            params.set(name, value);
//            params.set("page", 1);
//        } else {
//            params.delete(name);
//        }
//        return params;
//    });
//};

$(document).ready(function () {
    // Listen for the change event on the select dropdown
    $('#sortOrderSelect').on('change', function () {
        const name = $(this).attr('name');
        const value = $(this).val();

        // 1. Get current URL parameters
        let params = new URLSearchParams(window.location.search);

        // 2. Logic: Update 'order' and reset 'page' to 1
        if (value !== "") {
            params.set(name, value);
            params.set("page", "1");
        } else {
            params.delete(name);
        }

        // 3. Redirect to the new URL with updated parameters
        // This triggers the server-side OnGet/Action method
        window.location.href = window.location.pathname + '?' + params.toString();
    });

    $('#priceFilterSelect').on('change', function () {
        const $option = $(this).find('option:selected');
        const min = $option.data('min');
        const max = $option.data('max');

        let params = new URLSearchParams(window.location.search);

        // Reset to page 1 whenever a filter is changed
        params.set("page", "1");

        // Logic for "Over $"
        if (min) {
            params.set("min_price", min);
            params.delete("max_price");
        }
        // Logic for "Under $"
        else if (max) {
            params.set("max_price", max);
            params.delete("min_price");
        }
        // Logic for "Price" (Reset)
        else {
            params.delete("min_price");
            params.delete("max_price");
        }

        // Apply the new URL
        window.location.href = window.location.pathname + '?' + params.toString();
    });

    $('#formatFilterSelect').on('change', function () {
        const name = $(this).attr('name'); // "format"
        const value = $(this).val();

        let params = new URLSearchParams(window.location.search);

        // Always reset pagination to page 1 on filter mutation
        params.set("page", "1");

        if (value !== "") {
            params.set(name, value);
        } else {
            params.delete(name);
        }

        // Apply redirection to recalculate database dataset matching selection
        window.location.href = window.location.pathname + '?' + params.toString();
    });
});