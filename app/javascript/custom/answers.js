import $ from 'jquery';
$(document).on('turbolinks:load',function(){
// $(document).ready(function(){
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
})
