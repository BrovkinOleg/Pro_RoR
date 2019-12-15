import $ from 'jquery';
$(document).on('turbolinks:load', function(){
    $('.vote').on('ajax:success', function(e) {
        let resourceClass = e.detail[0]['resource_class'];
        let resourceId = e.detail[0]['resource'];
        let resourceVotes = e.detail[0]['votes'];
        $('#' + resourceClass + '_' + resourceId + ' .votes').html("Total votes:" + resourceVotes);
    });
});
