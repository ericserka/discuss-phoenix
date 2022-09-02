// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix"
import { sortArrOfObjsByPropertyValue } from "./snippets"

// And connect to the path in "lib/discuss_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", { params: { token: window.userToken } })

// When you connect, you'll often need to authenticate the client.
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic.
const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel
    .join()
    .receive("ok", (resp) => {
      renderComments(resp.comments)
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp)
    })

  // server broadcast
  channel.on(`comments:${topicId}:new`, renderNewComment)
  document.querySelector("button").addEventListener("click", () => {
    channel.push("comments:add", {
      comment: document.querySelector("textarea").value,
    })
  })
}

const renderComments = (comments) => {
  // sorting on the client since I haven't figured out how to sort in phoenix using ecto
  document.getElementById("comments-list").innerHTML =
    sortArrOfObjsByPropertyValue(comments, "inserted_at")
      .map((c) => commentTemplate(c))
      .join("")
}

// it is necessary to destructure the socket event object to get to the comment itself
const renderNewComment = ({ comment }) => {
  // the new comment is inserted at the top
  document.getElementById("comments-list").innerHTML =
    commentTemplate(comment) +
    document.getElementById("comments-list").innerHTML
}

const commentTemplate = (comment) => {
  return `
  <li class="border border-black w-full p-3 mb-3 flex justify-between">
    <div class="w-full">
      <img src=${
        comment.user?.avatar ??
        "https://pro2-bar-s3-cdn-cf2.myportfolio.com/c728a553-9706-473c-adca-fa2ea3652db5/df42f6b2-c2f9-4098-8669-bb34edf7b86a_rw_1200.jpg?h=15c65396d99657045b69631683b0a3d6"
      } class="w-12 h-12"/>
      <p>
        ${comment.user?.name ?? "Anonymous"}
      </p>
      <p>
        ${comment.inserted_at}
      </p>
    </div>
    <div>
      ${comment.comment}
    </div>
  </li>
  `
}

window.createSocket = createSocket
