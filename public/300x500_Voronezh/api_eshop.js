// --- DataTransport
var dataTransport = {
    ajaxUrl: "api_eshop.php",
    hold: 0,
    mainCity: "voronez_32951",
    localNumbers: [],
    localCities: [],
    orderDetails: {
        name: "",
        phone: "",
        email: "",

        delivery: "",
        number: "",

        region: "",
        city: "",

        utm_source: window.location.host,
        utm_medium: "banner_api",
    },
    init: function() {
        this.getNumbers();
    },
    getNumbers: function() {
        ui.setModal();
        var self = this;
        if(this.hold > 0) return;
        $(".reload").stop(true).fadeTo(300, 0.5);

        $.post(this.ajaxUrl + '?do=reload_numbers', {
            region: region
        }, function(data) {
            self.dataProcessor(data, "numbers");
            eShop.callbacks("getNumbers");
        }, "json");
        this.hold++;
    },
    getCities: function() {
        var self = this;
        $.post(this.ajaxUrl+'?do=reload_cities', {
            region: region
        }, function(data) {
            self.dataProcessor(data, "cities");
            eShop.callbacks("getCities", data);
        }, "json");
    },
    sendOrder: function() {
        this.orderDetails.name = $("#userName").val();
        this.orderDetails.phone = $("#userPhone").val();
        this.orderDetails.email = $("#userEmail").val();
        this.orderDetails.delivery = $(".delivery-types input:checked").attr("id");
        this.orderDetails.region = region;
        this.orderDetails.city = $("#city-select option:selected").val();

        $.post(this.ajaxUrl+'?do=send_form', 
            dataTransport.orderDetails, 
            function(data) {
                eShop.callbacks("sendOrder", data);
            }, "json");
    },
    dataProcessor: function(data, type) {
        if (type === "numbers") {
            this.localNumbers = [];
            for (var key in data.numbers) {
                this.localNumbers.push(data.numbers[key]);
            }

            this.localNumbers.sort(function (a, b) {
                var x = Number(a.price);
                var y = Number(b.price);
                if (x < y) return 1;
                if (x > y) return -1;
            });
        } else {
            this.localCities = data;
        }
    }
}


var eShop = {
    object: $(".banner"), 
    width: "300",
    height: "500px",
    init: function() {
        $("#userPhone").mask("+7 (999) 999-99-99");
        ui.setLoading(1);
        dataTransport.init();
        this.setupEvents();
    },
    callbacks: function(type, data) { // Callback processor
        dataTransport.hold--;
        switch(type) {
            case "getNumbers":
                ui.createNumberList();
                ui.removeLoading(1);
                ui.removeModal();
            break;

            case "getCities":
                ui.createSelect(dataTransport.localCities, dataTransport.mainCity);
                ui.createDeliveryCity(dataTransport.localCities);
                $(".select").slideDown();
                $(".button.confirm").fadeIn();
                ui.removeLoading(3);
            break;

            case "sendOrder":
                ui.hideX();

                var resultText;
                if (data.result == 1) {
                    resultText = "<h1>Cпасибо. Заказ&nbsp;№" + data.order_number + " принят.</h1><p>В&nbsp;ближайшее время наш&nbsp;специалист перезвонит по&nbsp;указанному номеру телефона.</p><button type='button' class='button choosenumber'><ins class='default'></ins><ins class='hover'></ins></button>";
                } else {
                    resultText = "<h1>Заказ номера не&nbsp;удался.</h1>";
                    if (data.desc === 'error_number_already_taken') {
                        resultText += "<p>Выбранный номер, к&nbsp;сожалению, уже заказан.</p><button type='button' class='button choosenumber'><ins class='default'></ins><ins class='hover'></ins></button>";
                    } else {
                        resultText += "<p>Произошла ошибка при отправке заказа.</p><p>Пожалуйста, повтори попытку чуть позднее.</p><button type='button' class='button choosenumber'><ins class='default'></ins><ins class='hover'></ins></button>";
                        console.error("Ошибка: " + data.desc);
                    }
                }

                $(".s4 .steps-shell").empty().html(resultText);
                ui.stepSwitcher(4);
            break;
        }
    },
    setupEvents: function() {
        var self = this;

        $(".reload").on("click", function() {
            dataTransport.getNumbers();
        });

        $(".numbers").on("click", "li", function() {
            dataTransport.orderDetails.number = $(this).attr("id");
            // dataTransport.orderDetails.number = 693779;

            $("#number").html($(this).find(".number").text());
            ui.showX();
            ui.stepSwitcher(2);
        });

        $(".next").on("click", function() {
            if (ui.validate()) {
                ui.stepSwitcher(3);
                
                if (!$(".sbHolder").length) {
                    ui.setLoading(3);
                    dataTransport.getCities();
                }
            }
        });

        $(".confirm").on("click", function() {
            dataTransport.sendOrder();
        });

        $(".x").on("click", function() {
            ui.hideX();
            ui.stepSwitcher(1);
            dataTransport.orderDetails.number = "";
        });

        $(".delivery-types").on("click", ".custom-checkbox", function() {
            $(".delivery-types label").removeClass("checked");
            $(this).addClass("checked");
            dataTransport.orderDetails.delivery = $(this).find("input").attr("id");
        });

        $(".s4").on("click", ".choosenumber", function() {
            ui.stepSwitcher(1);
            dataTransport.orderDetails.number = "";
        });

        $(document).keydown(function(e) {
            if (e.keyCode === 9) e.preventDefault();
        });
    }
}


// --- UI

var ui = {
    currentSlide: 1,
    setModal: function() {
        $("#modal").show();
    },
    removeModal: function() {
        $("#modal").hide();
    },
    setLoading: function(step) {
        eShop.object.find(".s" + step).addClass("loading");
    },
    removeLoading: function(step) {
        eShop.object.find(".s" + step).removeClass("loading");
    },
    showX: function() {
        $(".x").delay(300).fadeIn(200);
    }, 
    hideX: function() {
        $(".x").fadeOut(200);
    },
    createNumberList: function() {
        // создаем список номеров. Этот же метод будем использовать при обновлении списка номеров
        // console.log("createNumberList");

        $(".numbers").empty();
        var numbers = dataTransport.localNumbers,
                currentNumber, 
                price;

        for (var l = 0; l < numbers.length; l++) {
            currentNumber = numbers[l];
            price = currentNumber["price"];

            if (!currentNumber) continue; // Если нет номерв в регионе, пропускаем цикл
            if (currentNumber["price"].indexOf(".00") != -1) {
                price = currentNumber["price"].substring(0, currentNumber["price"].length - 3);
            } else {
                price = currentNumber["price"];
            }

            $(".numbers").append('<li id="' +
                currentNumber["id"] + '"><div class="price ' +
                currentNumber["simcard_type"] + '">' +
                price + ' руб.</div><div class="number">' +
                currentNumber["name"] + '</div></li>');
        }

        if (!currentNumber) {
            $(".empty").remove();
            $('<div class="empty">' + "В этом регионе нет номеров" + '</div>').insertAfter(".numbers");
            $(".reload").stop(true).fadeTo(300, 0);
        } else {
            $(".empty").remove();
        }

        $(".numbers-wrapper").slideDown(300);
        $(".reload").fadeTo(300, 1);
    },
    createSelect: function(data, mainCity) {
        var self = this;
        // Формируем селект
        if(!$("#city-select option").length){ 
            if (mainCity != undefined)
                $("#city-select").append('<option value="' + mainCity + '">' + data.cities[mainCity].name + '</option>');
            for (key in data.cities) {
                if (mainCity != undefined && mainCity == key)
                    continue;

                var cityName = data.cities[key].name;
                $("#city-select").append('<option value="' + key + '">' + cityName + '</option>');
            }
        }

        // Создаем кастомный селект
        $("#city-select").selectbox({
            onOpen: function() {
                $(this).parent().addClass("showed")
            },
            onClose: function() {
                $(this).parent().removeClass("showed")
            },
            onChange: function() {
                self.createDeliveryCity(dataTransport.localCities);
            }
        });
    },
    resetRadio: function() {
        // убираем у всех и устанавливаем у самовывоза
        $(".delivery-types input").attr("checked", "");
        $(".delivery-types label").removeClass("checked");
        
        $("#samovyvoz_li input").attr("checked", "checked");
        $("#samovyvoz_li label").addClass("checked");
    },
    createDeliveryCity: function(data) {
        dataTransport.orderDetails.city = $("#city-select option:selected").val();

        var delivery = data.cities[dataTransport.orderDetails.city].paid_delivery_price,
                selfDelivery = data.cities[dataTransport.orderDetails.city].has_samovyvoz;

        this.resetRadio();
        if (delivery.length) {
            $("#dostavka_li").slideDown();
            $("#dostavka_li .desc").html("Доставка платная, <br> стоимость " + delivery + "&nbsp;рублей.");
        } else {
            $("#dostavka_li").slideUp();
        }

        if (selfDelivery) {
            $("#samovyvoz_li").slideDown();
        } else {
            $("#samovyvoz_li").slideUp();
        }
    },
    stepSwitcher: function(step) {
        this.currentSlide = step;
        switch (step) {
            case 1:
                $(".s3").animate({
                    "left": eShop.width
                }, 100);
                $(".s4").animate({
                    "left": eShop.width
                }, 100);
                
                $(".s2").animate({
                    "left": eShop.width
                }, 200);
                $(".s1").animate({
                    "left":"0px"
                }, 200, "easeInExpo");
            break;

            case 2:
                $(".s1").animate({
                    "left": "-" + eShop.width
                }, 200, "easeInExpo");

                $(".s2").delay(200).animate({
                    "left":"0px"
                }, 100, "easeOutQuint");

            break;

            case 3: // city + delivery select 
                $(".s2").animate({
                    "left": "-" + eShop.width
                }, 200, "easeInExpo");

                $(".s3").delay(200).animate({
                    "left":"0px"
                }, 100, "easeOutQuint");
            break;

            case 4:
                $(".s3").animate({
                    "left": "-" + eShop.width
                }, 200, "easeInExpo");

                $(".s4").delay(200).animate({
                    "left":"0px"
                }, 100, "easeOutQuint")
            break;
        }
    },
    validate: function() {
        var flag = false;
        $(".required").each(function() {
            var input = $(this),
                value = input.val();
            
            if(value.length < 1) {
                flag = false;
                input.addClass("error");
            }

            if (input.prop("id") === "email" && $("#email").val().length){
                var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                if (value.length > 0 && reg.test(value) === false){
                    input.addClass("error");
                    flag = false;
                } else input.removeClass("error");
            }

            input.focus(function(){
                input.removeClass("error")
            });
        });

        if($(".required.error").length === 0) {
            flag = true;
        }
        return flag;
    }
}

$(document).ready(function () {
    eShop.init();
});