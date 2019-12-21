import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
    connected() {},
    disconnected() {},
    received(data) {
        let question = JSON.parse(data);
        if (gon.user_id === question.user_id) {
            return;
        }
        let $newQuestionDiv = $("<div id=" + "question_" + question.id + "> <hr> </div>");
        $('.questions').append($newQuestionDiv);
        $($newQuestionDiv).append("<p>" + question.title + "</p>", "<p>" + question.body + "</p>")
    }
});
