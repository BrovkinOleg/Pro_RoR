import $ from 'jquery';
$(document).on('turbolinks:load',function(){
    $(document).on('click', '.create-comment-link', function (event) {
        event.preventDefault();
        let commentableId = $(this).data('commentableId');
        let commentableType = $(this).data('commentableType');
        $('form#' + commentableType + '-' + commentableId + '-' + 'comment').removeClass('hidden');
    });
});
