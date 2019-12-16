import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    received(data) {
        let answer = JSON.parse(data);
        if (gon.user_id !== answer.user_id) {
            let $newAnswerDiv = $("<div id=" + "answer_" + answer.id + "></div>");
            $('.answers').append($newAnswerDiv);
            $($newAnswerDiv).append("<p>" + answer.body + "</p>")
        }
    }
});
