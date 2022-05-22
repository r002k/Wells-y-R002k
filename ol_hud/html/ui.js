$(document).ready(function() {
    var hudmodo = 1;
    var vida = new ProgressBar.Circle("#vida", {
        color: "rgb(22, 185, 27)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    var chaleco = new ProgressBar.Circle("#chaleco", {
        color: "rgb(0, 100, 200)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    var oxigeno = new ProgressBar.Circle("#oxigeno", {
        color: "rgb(0, 200, 255)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    var hambre = new ProgressBar.Circle("#hambre", {
        color: "rgb(200, 100, 0)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    var sed = new ProgressBar.Circle("#sed", {
        color: "rgb(0, 100, 255)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    var police = new ProgressBar.Circle("#police", {
        color: "rgb(0, 100, 255)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    var stress = new ProgressBar.Circle("#stress", {
        color: "rgb(171, 77, 244)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    var droga = new ProgressBar.Circle("#droga", {
        color: "rgb(0, 100, 0)",
        strokeWidth: 10,
        fill: 'rgba(0, 0, 0, 0.8)',
        duration: 250,
        easing: "easeInOut",
    });

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.show == true) {
            $('.container').fadeIn();
        } else if (item.show == false) {
            $('.container').fadeOut();
        }

        if (item.health || item.health === 0) {
            if (item.health > 0) {
                vida.animate(item.health / 100);
                $('#vidaicono').css('color', 'white');
            } else {
                vida.animate(0);
                $('#vidaicono').css('color', 'red');
            }
        }

        if (item.police) {
            $('#policeicono').css('color', 'green');
        } else {
            $('#policeicono').css('color', 'grey');
        }

        if (item.armor || item.armor === 0) {
            if (item.armor > 0) {
                $('#chaleco').fadeIn();
                chaleco.animate(item.armor / 100);
            } else {
                $('#chaleco').fadeOut();
                chaleco.animate(0);
            }
        }

        if(item.oxigeno || item.oxigeno === 0) {
            if (item.oxigeno > 0) {
                if (item.nadando) {
                    $('#oxigeno').fadeIn();
                    oxigeno.animate(item.oxigeno / 100);
                } else {
                    $('#oxigeno').fadeOut();
                }
            } else {
                oxigeno.animate(0);
            }
        }

        if (item.st) {
            const sthambre = item.st[0].percent;
            const stsed = item.st[1].percent;
            const ststress = item.st[2].percent;
            const stdroga = item.st[3].percent;
            
            hambre.animate(sthambre / 100);
            sed.animate(stsed / 100);

            if (ststress > 0) {
                stress.animate(ststress / 100);
                $('#stress').fadeIn();
            } else {
                $('#stress').fadeOut();
            }
            if (stdroga > 0) {
                droga.animate(stdroga / 100);
                $('#droga').fadeIn();
            } else {
                $('#droga').fadeOut();
            }
        }
        

        if (item.radar || item.radar == false) {
            if (item.radar == 1) {
                $('#estadisticas').removeClass('estadisticas2')
                $('#estadisticas').removeClass('estadisticas3')
                $('#estadisticas').addClass('estadisticas1')
            } else if (item.radar == 2) {
                $('#estadisticas').removeClass('estadisticas2')
                $('#estadisticas').removeClass('estadisticas1')
                $('#estadisticas').addClass('estadisticas3')
            } else {
                $('#estadisticas').removeClass('estadisticas1')
                $('#estadisticas').removeClass('estadisticas3')
                $('#estadisticas').addClass('estadisticas2')
            }
        }

        // if (item.trabajo) {
        //     $("#spantrabajo").html(item.trabajo);
        // }

        // if (item.trabajo2) {
        //     if (item.trabajo2 != 'Desempleado - Desempleado') {
        //         $('#spantrabajo2').fadeIn();
        //         $("#spantrabajo2").html(item.trabajo2);
        //     } else {
        //         $('#spantrabajo2').fadeOut();
        //     }
        // }

        if (Number(item.cambiarhud)) {
            hudmodo = item.cambiarhud
        }

        if (hudmodo == 1) {
            $('#estadisticas').fadeIn();
            // $('#trabajo').fadeIn();
        } else if (hudmodo == 2) {
            $('#estadisticas').fadeIn();
            // $('#trabajo').fadeOut();
        } else if (hudmodo == 3) {
            $('#estadisticas').fadeIn();
            // $('#trabajo').fadeOut();
        } else if (hudmodo == 4) {
            // $('#trabajo').fadeOut();
            $('#estadisticas').fadeOut();
        }
    })
})