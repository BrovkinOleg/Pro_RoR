import consumer from "./consumer"

consumer.subscriptions.create({
    channel: "AnswersChannel",
    question_id: gon.question_id
}, {
    connected() {},
    disconnected() {},
    received(data) {
        let answer = JSON.parse(data);
        if (gon.user_id === answer.user_id) {
            return;
        }
        let $newAnswerDiv = $("<div id=" + "answer_" + answer.id + "> <hr> </div>");
        $('.answers').append($newAnswerDiv);
        $($newAnswerDiv).append("<p>" + answer.body + "</p>")
    }
});

