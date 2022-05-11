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
      console.log(data)
      const element = $(`#${data.store_id}-${data.shoe_model_id}`);
      getHighCount();
      element.html(data.inventory);
      if(data.inventory < 10) {
        element.closest('tr').removeClass().addClass('bg-danger text-white');
      } else {
        element.closest('tr').removeClass();
      }
    }
  });
})


function getHighCount() {
  console.log("get");
}


