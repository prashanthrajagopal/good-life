$(document).ready(function(){
 function remove_fields(link){
        $(link).closest("div").find("input[type=hidden]").val("1");
        $(link).closest("div.row").hide();
    };

    function add_fields(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        $(link).parent().after(content.replace(regexp, new_id));
    };

    $('.datepicker').datepicker({ minDate: '-1Y', 
            maxDate: '0',
            dateFormat : "dd MM yy",
            buttonImageOnly : true
        });
});
