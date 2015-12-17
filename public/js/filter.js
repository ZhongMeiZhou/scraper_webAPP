/* intialize select2 dropdown objects */
$(".countries").select2({
    placeholder: "Where do you want to go?",
    allowClear: true,
    maximumSelectionLength: 8
});

$(".categories").select2({
    placeholder: "What type of tour are you looking for?",
    allowClear: true,
    maximumSelectionLength: 8
});
