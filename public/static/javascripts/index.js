    $(window).load(function() { // makes sure the whole site is loaded
        $.when($('#status').delay(400).fadeOut('slow'))
                               .done(function() {
            $('#preloader').css('display','none');
        });
    })