# FFXIV Collect Write API

This document describes the **write API** that lets an external client
push the in-game contents of a character to FFXIV Collect.

It complements the existing public read API at `/api` — the read API
stays unchanged, this is a narrow, opt-in write surface bound to a single
character.

## Table of contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Token lifecycle](#token-lifecycle)
4. [Writeable collections](#writeable-collections)
5. [Endpoint reference](#endpoint-reference)
6. [Idempotency and write semantics](#idempotency-and-write-semantics)
7. [Errors](#errors)
8. [Rate limits](#rate-limits)
9. [Security model](#security-model)
10. [Example clients](#example-clients)

---

## Overview

```
┌─────────────┐    Discord OAuth     ┌──────────────────────┐
│  External   │  (existing)          │   FFXIV Collect Web  │
│   Client    │ ───── User-Browser ──>                      │
└─────┬───────┘                      │  Character page →    │
      │                              │  [Generate API token]│
      │ Bearer <token>               └──────────┬───────────┘
      │ POST /api/characters/:id/                │ token shown once
      │      :collection/owned                   ▼
      │ { "ids": [1,2,3,...] }              user pastes it
      ▼                                          │
┌──────────────────────────────────────┐         │
│        FFXIV Collect API             │<────────┘
│  Adds new IDs to the character's     │
│  owned set for the given collection  │
└──────────────────────────────────────┘
```

- Authentication uses **per-character bearer tokens** generated on the
  FFXIV Collect web UI.
- The API is **add-only** — collections can grow but never shrink via
  the write API. Once an item is owned, it stays owned.
- Writes are **idempotent** — re-sending the same IDs is safe; the
  server filters them against the current owned set.
- The token is bound to **one specific character** and authorises writes
  to **that character only**.

---

## Authentication

Every write request must include a bearer token:

```
Authorization: Bearer <token>
```

- Tokens are 32 random URL-safe bytes (`SecureRandom.urlsafe_base64(32)`),
  produced on the server, shown to the user exactly once.
- Server-side only the **SHA-256 hash** of the token is stored. There is
  no way to recover a lost token — generate a new one instead.
- A token is bound to a **single, verified** FFXIV Collect character. If
  the character loses verification (e.g. it is re-verified by a
  different Discord account), the token is rejected on the next request.
- One active token per character. Generating a new one **immediately
  invalidates the previous one** (hard-delete, no audit trail).

### Required scope

A token's owning character must be **verified** — i.e. the user has
proven they own that character via the existing Lodestone bio
verification flow. Unverified characters cannot generate tokens at all.

### Recommended client behaviour

- Send a descriptive `User-Agent` header on every request, e.g.
  `MyClient/1.2.3 (+https://example.org/myclient)`. The server logs the
  last UA per token, useful for the user to identify which client last
  used a token. UA is **not enforced** — a missing UA is not a 4xx — but
  it helps debugging and incident response.
- Treat the token like a password: keep it in the OS keychain or an
  encrypted client configuration; never log it.

---

## Token lifecycle

Token operations live on the **web UI**, not the API. They require an
active web session (Discord-OAuth-authenticated user) who is the
verified owner of the target character.

### Generate or regenerate

The web user opens `https://ffxivcollect.com/character/<character_id>/api_token`
and clicks **Generate token** (or **Regenerate token** if one already
exists). The new token is displayed exactly once; subsequent reloads
will not show it again. The previous token (if any) is destroyed.

### Revoke

Same page, **Revoke token**. The DB row is deleted; the next API call
with that token returns `401`.

### Inspect

The same page shows, when a token is active:

- when it was created,
- when it was last used (`last_used_at`),
- the `User-Agent` of the last client that used it.

---

## Writeable collections

Collections that are **not** populated from Lodestone — i.e. things a
Lodestone profile sync does not know about — are writeable via this API:

| Collection      | Path segment   |
| --------------- | -------------- |
| Emotes          | `emotes`       |
| Bardings        | `bardings`     |
| Hairstyles      | `hairstyles`   |
| Fashion access. | `fashions`     |
| Facewear        | `facewear`     |
| Orchestrion     | `orchestrions` |
| Framer's kits   | `frames`       |
| Armoire         | `armoires`     |
| Glamour outfits | `outfits`      |
| Triple Triad    | `cards`        |

Everything else — `achievements`, `mounts`, `minions`, etc. — is
explicitly **rejected** with `400`. Those collections are kept
authoritative from Lodestone, and accepting writes for them would race
with the next sync and produce confusing results.

---

## Endpoint reference

### `POST /api/characters/:character_id/:collection/owned`

Add IDs to the character's owned set for the given collection.

**URL parameters**

| Name           | Type    | Notes                                                       |
| -------------- | ------- | ----------------------------------------------------------- |
| `character_id` | integer | FFXIV Collect character ID. Must match the token's binding. |
| `collection`   | string  | One of the [writeable collections](#writeable-collections). |

**Headers**

| Header          | Value                                                |
| --------------- | ---------------------------------------------------- |
| `Authorization` | `Bearer <token>`                                     |
| `Content-Type`  | `application/json`                                   |
| `User-Agent`    | Recommended (see [Authentication](#authentication)). |

**Request body**

```json
{
  "ids": [12, 47, 88, 1024]
}
```

- `ids` must be a **non-empty array of integers**.
- IDs are the canonical FFXIV Collect IDs of the collectables — the
  same ones returned by the read API.
- Send as many IDs as you want; one batch is one HTTP request.

**Success response** — `200 OK`

```json
{
  "character_id": 5659713,
  "collection":   "hairstyles",
  "added":        2,
  "already_owned": 1,
  "invalid_ids":  [99999],
  "total_owned":  117
}
```

| Field           | Meaning                                                                |
| --------------- | ---------------------------------------------------------------------- |
| `character_id`  | Echo of the path parameter.                                            |
| `collection`    | Echo of the path parameter.                                            |
| `added`         | Number of IDs newly added to the owned set.                            |
| `already_owned` | Number of IDs that were already in the owned set (no-op).              |
| `invalid_ids`   | IDs the server didn't recognise (don't exist in this collection).      |
| `total_owned`   | Total size of the character's owned set for this collection after the write. |

---

## Idempotency and write semantics

- **Additive only** — the API never removes IDs from the owned set.
  Re-running a request with the same IDs is a no-op (`added: 0`,
  `already_owned: N`). This is intentional: collections in-game are
  monotonic, you never lose something you owned.
- **No PUT / no DELETE.** If you need to "fix" a wrongly-marked item,
  use the web UI; the API doesn't expose that.
- **Send the full known-owned set if you like** — the server diffs
  against the existing rows, so over-sending is cheap and safe. Don't
  feel obliged to track "what did I push last time" client-side.
- **Order of IDs does not matter.**
- **Unknown IDs are silently filtered** into `invalid_ids` instead of
  failing the whole request. This makes the client tolerant to game
  updates that add new IDs the server hasn't been told about yet.

---

## Errors

All errors return a JSON body of the form:

```json
{ "status": <code>, "error": "<message>" }
```

| HTTP | When                                                                                        |
| ---- | ------------------------------------------------------------------------------------------- |
| 400  | `ids` missing, not an array, or empty.                                                      |
| 400  | `:collection` is not in the writeable allowlist (e.g. `mounts`, `achievements`).            |
| 401  | `Authorization` header missing, malformed, or token doesn't match any record.               |
| 403  | Token is valid but the URL's `:character_id` doesn't match the token's bound character.     |
| 403  | Character lost its verification (verified user is now somebody else, or none).              |
| 429  | Rate limit exceeded. See [Rate limits](#rate-limits). Includes a `Retry-After` header.      |
| 500  | Internal server error — please open a bug with the request signature (no token in it).      |

---

## Rate limits

Enforced per token by `Rack::Attack`:

| Window     | Limit       |
| ---------- | ----------- |
| per minute | **60** writes |
| per day    | **5 000** writes |

Token **generation** (on the web UI) is throttled per IP at **10 per hour**.

On a `429`, the response carries:

```
Retry-After: <seconds>
```

A correctly-implemented client should:

1. Honour `Retry-After`.
2. Back off exponentially on repeated `429`s.
3. Never tight-loop — the per-minute window is generous enough that
   any legitimate sync should fit inside it. If you're hitting limits,
   batch more aggressively (more IDs per request, fewer requests).

---

## Security model

Threat assumptions and mitigations:

| Threat                                                                       | Mitigation                                                                                              |
| ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Token leak from the user's client configuration                              | Token only writes to **one specific character**, only to non-Lodestone collections, and is revocable.   |
| Server compromise leaks the token DB                                         | Only SHA-256 hashes are stored — the raw tokens can't be recovered.                                     |
| Replay across characters                                                     | The URL `:character_id` must equal the token's bound character (`403` otherwise).                       |
| Replay after the user re-verifies their character to a different account     | Every write call re-checks `character.verified_user_id == token.user_id` (`403` if mismatched).         |
| Brute-forcing the token UI                                                   | Per-IP throttle of 10/hour on token generation.                                                         |
| Brute-forcing tokens via the API                                             | 256-bit entropy plus per-token rate limit — exhausting the space is infeasible.                         |
| Man-in-the-middle                                                            | Production runs TLS only. Don't use this API over plain HTTP outside local dev.                         |
| Client pushing items the user never owned                                    | This is a trust decision — the user opted in by installing the client. The owned set can only grow, so the user can audit it via the read API and revoke if surprised. |

What the API **cannot** do:

- Read or modify any character other than the one the token is bound to.
- Touch Lodestone-driven collections (mounts, minions, achievements, etc).
- Modify any web-only state (profile privacy, account settings, etc).
- Delete items from the owned set.

---

## Example clients

### curl

```sh
curl -X POST 'https://ffxivcollect.com/api/characters/5659713/hairstyles/owned' \
     -H 'Authorization: Bearer pAsVcRORRRYBXl_IeS2aZdlEhuJC3zocXKpPYvxoO_A' \
     -H 'Content-Type: application/json' \
     -H 'User-Agent: MyClient/1.0.0' \
     -d '{"ids":[573]}'
```

### C# (HttpClient)

```csharp
using var http = new HttpClient();
http.DefaultRequestHeaders.UserAgent.ParseAdd("MyClient/1.0.0");
http.DefaultRequestHeaders.Authorization =
    new AuthenticationHeaderValue("Bearer", token);

var payload = JsonSerializer.Serialize(new { ids = ownedHairstyleIds });
using var content = new StringContent(payload, Encoding.UTF8, "application/json");

var response = await http.PostAsync(
    $"https://ffxivcollect.com/api/characters/{characterId}/hairstyles/owned",
    content);

// Honour Retry-After on 429
if ((int)response.StatusCode == 429 &&
    response.Headers.RetryAfter?.Delta is { } delay)
{
    await Task.Delay(delay);
    // ... retry
}

response.EnsureSuccessStatusCode();
var result = await response.Content.ReadFromJsonAsync<OwnedResult>();
```

### Python

```python
import requests

resp = requests.post(
    f"https://ffxivcollect.com/api/characters/{character_id}/emotes/owned",
    json={"ids": emote_ids},
    headers={
        "Authorization": f"Bearer {token}",
        "User-Agent": "my-script/0.1",
    },
    timeout=15,
)
resp.raise_for_status()
print(resp.json())
```

---

## FAQ

**Q: Can I get a list of IDs the user already owns via this API?**
A: Use the existing public read endpoint
`GET /api/characters/:id/:collection/owned` — it returns the canonical
owned set and is unaffected by this API. The write API only **adds**;
the read API is your source of truth.

**Q: What if my client pushes an item that's later removed from the
game?**
A: The server filters against the current collectable table. If the ID
no longer exists, it ends up in `invalid_ids` and is not added. The
existing owned rows aren't pruned by this endpoint.

**Q: Can two clients share one token?**
A: Technically yes — the server doesn't care. But the rate limit is
**per token**, so they will compete for the same quota. Practically,
one token per client per character keeps audit and rate-limit blame
clean. Generating a new token in one client will invalidate the
shared token, breaking the other.

**Q: Can the user generate one token that covers all their characters?**
A: No. Each character has its own token. This is a security feature —
a client can only ever affect the character the user explicitly opted
in for.

**Q: Is there a way to delete an ID from the owned set via the API?**
A: No, by design. Collections in-game are monotonic. If you need to
manually correct a wrongly-tracked item, use the web UI.

**Q: Where do I report a bug?**
A: Open an issue in the FFXIV Collect GitHub repository. Include the
endpoint, the request body (with `ids` truncated if long), the HTTP
status and response body, and your User-Agent. **Never paste your
token.**
