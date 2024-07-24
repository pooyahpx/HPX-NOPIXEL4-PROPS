window.addEventListener("message", function (e) {
    $("body").fadeIn(500);
    e = e.data
    switch (e.action) {
    case "openProps":
        return openProps(e.data)
    case "setPropsData":
        return setPropsData(e.data)
    default:
    return;
    }
});


function openProps(data) { 
    $(".prop-box").empty();
    $(".create-prop-page").show();
    $('.washing-box,.control-box').hide();
    $.each(data, function (i, v) {
        $(".prop-box").append(`
        <div data-itemname="${v.itemname}" data-hash="${v.hash}" data-propname="${v.propname}" class="prop-item">
            <img src="../images/${v.propname}.png" class="prop-img" alt="">
            <div class="prop-item-name">${v.label}</div>
            <div class="right-box">></div>
        </div>
        `)
    })
}

function setPropsData(data) {
    $('.posx').html(data["position"]["x"]);
    $('.posy').html(data["position"]["y"]);
    $('.posz').html(data["position"]["z"]);
    $('.rotx').html(data["rotation"]["x"]);
    $('.roty').html(data["rotation"]["y"]);
    $('.rotz').html(data["rotation"]["z"]);
}


$(document).on('click', '.prop-item', function (e) {
    $(".prop-item").css({'background-color': '#2f3137','opacity': '0.7'});
    
    $(".prop-item-name").css('color', '#fff');
    
    $(".right-box").css({'background-color': '#296b5f','color': '#0ceebf'});

    $(this).css({'background-color': '#296b5f','opacity': '1'});

    $(this).find(".prop-item-name").css('color', '#0ceebf');

    $(this).find(".right-box").css({'background-color': '#0ceebf','color': '#296b5f'});

    itemName = $(this).data("itemname");
    propName = $(this).data("propname");
    hash = $(this).data("hash");
    $.post(`http://qb-props/openProps`, JSON.stringify({itemName:itemName,propName:propName,hash:hash}), function (x) {
        if (x=='openProps') {
            
        }
    })

    $(".select-item-img,.create-prop-img").attr('src', `../images/${propName}.png`);

    $(".select-item-name-box,.create-prop-name-box").text(itemName);
    $(".propmodel").text(propName);
    $(".hashbox").text(hash);
})

$(".prop-search-input").on("input", function () {
    var searchTerm = $(this).val().toLowerCase();
    $(".prop-item").each(function () {
        var propName = $(this).find(".prop-item-name").text().toLowerCase();
        if (propName.includes(searchTerm)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        $("body").fadeOut(500);
        $.post(`http://qb-props/close`, JSON.stringify({ }), function (x) {});
    }
});


$(document).on('click', '.prop-settings', function (e) {
    $('.prop-popup').fadeOut(300);
    dataType = $(this).data("type");
    $('.'+dataType+'-pop-up').fadeIn(300);

    if (dataType=="delete") {
        $.post(`http://qb-props/deleteProp`, JSON.stringify({ }), function (x) {});
    }

})

$(document).on('click', '.prop-popup .leave-button', function (e) {
    $("body").fadeOut(500);
    $.post(`http://qb-props/close`, JSON.stringify({ }), function (x) {});
    $.post(`http://qb-props/deleteProp`, JSON.stringify({ }), function (x) {});
    
})

$(document).on('click', '.prop-popup .cancel-button', function (e) {
    $(".prop-popup").fadeOut(300);
})

$(document).on('click', '.save-build-button', function (e) {
    $(".prop-popup").fadeOut(300);
    // $('.computer-build').fadeIn(300);
    $.post(`http://qb-props/saveBuild`, JSON.stringify({ }), function (x) {});
})

$(document).on('click', '.discard-button', function (e) {
    $(".prop-popup").fadeOut(300);
    $.post(`http://qb-props/deleteProp`, JSON.stringify({ }), function (x) {});
})
