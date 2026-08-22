---
name: rust-scripts
description: Create and run single-file Rust scripts using Cargo's nightly -Zscript support with fenced cargo frontmatter dependencies. Use when asked to write Rust scripts, quick Rust utilities, or script-like Rust tools with dependencies.
---

# Rust Scripts with Cargo `-Zscript`

Use Cargo's unstable script mode for executable single-file Rust scripts.

## Requirements

- Nightly Rust toolchain must be installed.
- If nightly is missing, stop and ask the user to install it. Do not work around missing toolchains/packages.

Check:

```sh
rustup toolchain list
```

Install command for the user:

```sh
rustup toolchain install nightly
```

## Script Template

Create a `.rs` file with this shape:

```rust
#!/usr/bin/env -S cargo +nightly -Zscript
---cargo
[dependencies]
rand = "0.9.2"
---

fn main() {
    let x: u8 = rand::random();
    println!("Random number: {x}");
}
```

Make it executable:

```sh
chmod +x path/to/script.rs
```

Run it directly:

```sh
./path/to/script.rs
```

Or run with Cargo explicitly:

```sh
cargo +nightly -Zscript path/to/script.rs
```

## Dependency Frontmatter

Dependencies go in the fenced cargo frontmatter between `---cargo` and `---`:

```rust
#!/usr/bin/env -S cargo +nightly -Zscript
---cargo
[dependencies]
axum = "0.8"
tokio = { version = "1", features = ["full"] }
tower-http = { version = "0.6", features = ["cors"] }
serde_json = "1"
---
```

Use normal `Cargo.toml` syntax inside the frontmatter.

## Axum CORS Test Server Pattern

For local browser/wasm CORS testing, prefer an Axum script like:

```rust
#!/usr/bin/env -S cargo +nightly -Zscript
---cargo
[dependencies]
axum = "0.8"
tokio = { version = "1", features = ["full"] }
tower-http = { version = "0.6", features = ["cors"] }
serde_json = "1"
---

use axum::{routing::{get, post}, Json, Router};
use serde_json::json;
use tower_http::cors::CorsLayer;

#[tokio::main]
async fn main() {
    let addr = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "127.0.0.1:8090".to_string());

    let app = Router::new()
        .route("/random", get(|| async {
            Json(json!({
                "activity": "Use the local CORS test server",
                "availability": 1.0,
                "type": "education",
                "participants": 1,
                "price": 0.0,
                "accessibility": "Few to no challenges",
                "duration": "minutes",
                "kidFriendly": true,
                "link": "",
                "key": "local-test"
            }))
        }))
        .route("/posts", post(Json(|payload: serde_json::Value| async move {
            let mut response = payload;
            if let Some(object) = response.as_object_mut() {
                object.insert("id".to_string(), json!(101));
            }
            Json(response)
        })))
        .layer(CorsLayer::permissive());

    println!("CORS test server listening on http://{addr}");
    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

Note: adapt handlers as needed; verify script compiles after writing.

## Best Practices

- Put project-local scripts under `scripts/` and use kebab-case names, e.g. `scripts/cors-test-server.rs`.
- Prefer scripts for development/test tooling that should not be compiled as crate examples or shipped as library code.
- Keep scripts executable and self-contained.
- Document required invocation in `AGENTS.md` or README when used for test workflows.
