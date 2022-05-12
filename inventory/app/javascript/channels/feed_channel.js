import consumer from "channels/consumer"

$(document).ready(function () {
  var data = []
  consumer.subscriptions.create("FeedChannel", {
    connected() {
      console.log("Connected to feed channel!");
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      $(`#${data.store_name}`).html(data.html_table);
      $(`#${data.store_name}-badge-lower`).html(data.below_lower_limit_count);
      $(`#${data.store_name}-badge-upper`).html(data.over_upper_limit_count);

    }
  });
})


function getHighCount() {
  console.log("get");
}


