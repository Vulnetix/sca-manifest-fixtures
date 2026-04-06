use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Message {
    text: String,
}

#[tokio::main]
async fn main() {
    let message = Message {
        text: "Hello from cargo".to_string(),
    };
    println!("{:?}", message);
}
