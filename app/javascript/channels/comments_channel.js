import consumer from "./consumer"

consumer.subscriptions.create({ channel:"CommentsChannel", question_id: gon.question_id }, {

    connected() {},
    disconnected() {},
    received(data) {
        let comment = JSON.parse(data);
        console.log('comment_receive_data', data);
        if (gon.user_id === comment.user_id) {
            return;
        }
        let $newCommentDiv = $("<div id=" + "comment_" + comment.id + "></div>");
        let $name = comment.commentable_type.toLowerCase(); //  $name = 'question' or 'answer'

        console.log('$newCommentDiv = ', $newCommentDiv);
        console.log('$remote_comment_name = ', $name);
        $('#comments_'+ $name + '_' + comment.commentable_id).append($newCommentDiv);
        $($newCommentDiv).append("<b>Remote_Comment:</b>", comment.body);
    }
});

