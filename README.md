<p align="center">
  <a href="https://www.piloterr.com"><img src="images/banner.png" alt="GSA eLibrary Scraper API by Piloterr – scrape GSA eLibrary data as JSON" width="100%"></a>
</p>

# GSA eLibrary Scraper API

[![Discord](https://img.shields.io/badge/Discord-Join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/CFj3ph8aHU) [![Get API key](https://img.shields.io/badge/Piloterr-Get%20a%20free%20API%20key-111827)](https://app.piloterr.com) [![API docs](https://img.shields.io/badge/Docs-OpenAPI-0EA5E9)](https://app.piloterr.com/openapi) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

The **Piloterr GSA eLibrary Scraper API** lets you extract public data from GSA eLibrary as **clean, structured JSON** — no proxies, headless browsers or HTML parsing to maintain. Endpoints available in production:

- **GSA eLibrary Contract API** — Read one GSA eLibrary contractor record from the contract URL returned by search.
- **GSA eLibrary Search API** — Search GSA eLibrary for schedule, SIN, and contract rows by keyword or by a full search URL.

Use it for price monitoring, assortment tracking, competitor analysis, product research or catalog enrichment.

| Endpoint | Path | Credits | What you get |
|---|---|---|---|
| [GSA eLibrary Contract API](#gsa-elibrary-contract-api) | `/v2/gsaelibrary/contract` | 1 | Read one GSA eLibrary contractor record from the contract URL returned by search. |
| [GSA eLibrary Search API](#gsa-elibrary-search-api) | `/v2/gsaelibrary/search` | 1 | Search GSA eLibrary for schedule, SIN, and contract rows by keyword or by a full search URL. |

## Table of contents

- [How it works](#how-it-works)
- [GSA eLibrary Contract API](#gsa-elibrary-contract-api)
- [GSA eLibrary Search API](#gsa-elibrary-search-api)
- [Code examples in other languages](#code-examples-in-other-languages)
- [Practical use cases](#practical-use-cases)
- [Why Piloterr?](#why-piloterr)
- [FAQ](#faq)
- [Related scrapers](#related-scrapers)
- [Support](#support)

## How it works

1. **Create a free Piloterr account** and copy your API key from the [dashboard](https://app.piloterr.com).
2. **Send a `GET` (or `POST`) request** to `https://api.piloterr.com/v2/...` with the header `x-api-key: YOUR_API_KEY`.
3. **Receive structured JSON** — Piloterr handles rendering, proxies, retries and parsing.

```bash
export PILOTERR_API_KEY="your-api-key"
pip install requests        # Python
# TypeScript: Node.js 18+ (native fetch), run with `npx tsx file.ts`
```

> Every endpoint accepts both `GET` (query string) and `POST` (JSON body with the same fields).

## GSA eLibrary Contract API

Read one GSA eLibrary contractor record from the contract URL returned by search.

`GET | POST https://api.piloterr.com/v2/gsaelibrary/contract` · **1 credit per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Required. The contractorInfo.do URL from a search contract row. A contract number is also accepted, but GS-07F-0239T alone currently returns 404 because GSA needs the contractor name that search includes in the URL. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/gsaelibrary/contract",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-07F-0239T&contractorName=US+RADAR+INC&executeQuery=YES",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type GsaElibraryContract = {
  url?: string;
  epls?: string;
  email?: string;
  phone?: string;
  address?: string;
  sam_uei?: string;
  website?: string;
  terms_url?: unknown;
  categories?: {
    sin?: string;
    name?: string;
  }[];
  schedule_name?: string;
  socio_economic?: string;
  contract_number?: string;
  contractor_name?: string;
  schedule_number?: string;
  government_poc_name?: string;
  government_poc_email?: string;
  government_poc_phone?: string;
  current_option_period_end_date?: string;
};

const params = new URLSearchParams({
  "query": "https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-07F-0239T&contractorName=US+RADAR+INC&executeQuery=YES",
});

const response = await fetch(`https://api.piloterr.com/v2/gsaelibrary/contract?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as GsaElibraryContract;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/gsaelibrary/contract
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-07F-0239T&contractorName=US+RADAR+INC&executeQuery=YES"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "url": "https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-07F-0239T&contractorName=US+RADAR+INC&executeQuery=YES",
  "epls": "Contractor not found on the Excluded Parties List System",
  "email": "example",
  "phone": "example",
  "address": "173 AMBOY RD, MORGANVILLE, NJ 07751-1003",
  "sam_uei": "TL26M1812HG4",
  "website": "http://usradar.com",
  "terms_url": null,
  "categories": [
    {
      "sin": "334515",
      "name": "Diagnostic, Measuring and Testing Equipment"
    }
  ],
  "schedule_name": "Multiple Award Schedule",
  "socio_economic": "Small Business",
  "contract_number": "GS-07F-0239T",
  "contractor_name": "US RADAR INC",
  "schedule_number": "MAS",
  "government_poc_name": "Brian Buffett",
  "government_poc_email": "brian.buffett@gsa.gov",
  "government_poc_phone": "470-496-9410",
  "current_option_period_end_date": "Feb 14, 2027"
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `url` | string |  |
| `epls` | string |  |
| `email` | string |  |
| `phone` | string |  |
| `address` | string |  |
| `sam_uei` | string |  |
| `website` | string |  |
| `terms_url` | object |  |
| `categories[]` | object[] |  |
| `categories[].sin` | string |  |
| `categories[].name` | string |  |
| `schedule_name` | string |  |
| `socio_economic` | string |  |
| `contract_number` | string |  |
| `contractor_name` | string |  |
| `schedule_number` | string |  |
| `government_poc_name` | string |  |
| `government_poc_email` | string |  |
| `government_poc_phone` | string |  |
| `current_option_period_end_date` | string |  |

## GSA eLibrary Search API

Search GSA eLibrary for schedule, SIN, and contract rows by keyword or by a full search URL.

`GET | POST https://api.piloterr.com/v2/gsaelibrary/search` · **1 credit per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Required. A keyword, or a full search URL on gsaelibrary.gsa.gov. The URL must contain searchResults.do or searchText=. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/gsaelibrary/search",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "radar",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type GsaElibrarySearch = {
  results?: {
    sin?: unknown;
    url?: string;
    name?: string;
    category?: string;
    description?: unknown;
    result_type?: string;
    schedule_name?: string;
    contract_number?: string;
    schedule_number?: string;
  }[];
  pagination?: {
    next?: unknown;
    page?: number;
    per_page?: number;
    total_pages?: number;
    total_results?: number;
  };
};

const params = new URLSearchParams({
  "query": "radar",
});

const response = await fetch(`https://api.piloterr.com/v2/gsaelibrary/search?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as GsaElibrarySearch;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/gsaelibrary/search
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "radar"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "results": [
    {
      "sin": null,
      "url": "https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-07F-0239T&contractorName=US+RADAR+INC&executeQuery=YES",
      "name": "US RADAR INC",
      "category": "Contractors",
      "description": null,
      "result_type": "contract",
      "schedule_name": "Multiple Award Schedule",
      "contract_number": "GS-07F-0239T",
      "schedule_number": "MAS"
    }
  ],
  "pagination": {
    "next": null,
    "page": 1,
    "per_page": 63,
    "total_pages": 1,
    "total_results": 63
  }
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `results[]` | object[] |  |
| `results[].sin` | object |  |
| `results[].url` | string |  |
| `results[].name` | string |  |
| `results[].category` | string |  |
| `results[].description` | object |  |
| `results[].result_type` | string |  |
| `results[].schedule_name` | string |  |
| `results[].contract_number` | string |  |
| `results[].schedule_number` | string |  |
| `pagination` | object |  |
| `pagination.next` | object |  |
| `pagination.page` | integer |  |
| `pagination.per_page` | integer |  |
| `pagination.total_pages` | integer |  |
| `pagination.total_results` | integer |  |

## Code examples in other languages

Ready-to-run examples live in the [`examples/`](examples) folder. Each one reads your key from the `PILOTERR_API_KEY` environment variable.

| Language | Contract | Search |
|---|---|---|
| cURL (Bash) | [`contract`](examples/curl/contract.sh) | [`search`](examples/curl/search.sh) |
| PHP | [`contract`](examples/php/contract.php) | [`search`](examples/php/search.php) |
| C# | [`contract`](examples/csharp/Contract.cs) | [`search`](examples/csharp/Search.cs) |
| Go | [`contract`](examples/go/contract.go) | [`search`](examples/go/search.go) |
| Java | [`contract`](examples/java/ContractExample.java) | [`search`](examples/java/SearchExample.java) |
| Ruby | [`contract`](examples/ruby/contract.rb) | [`search`](examples/ruby/search.rb) |
| Node.js | [`contract`](examples/nodejs/contract.mjs) | [`search`](examples/nodejs/search.mjs) |

## Practical use cases

- **Price monitoring** — Track prices, promotions and availability over time to react to competitors.
- **Assortment & catalog tracking** — Follow new products, delisted items and category changes.
- **Competitor analysis** — Benchmark ranges, brands and positioning across retailers.
- **Product research** — Spot best-sellers and trends from search results.
- **Catalog enrichment** — Pull titles, images and attributes into your PIM or marketplace listings.

## Why Piloterr?

- **No infrastructure** — no proxies, headless browsers or CAPTCHA solving to run yourself.
- **Structured JSON** — stable, documented fields instead of brittle HTML selectors.
- **Pay per request** — transparent credit cost per endpoint, failed requests are retried for you.
- **One API key, hundreds of sources** — GSA eLibrary plus many other e-commerce, search and company data endpoints in the [Piloterr library](https://www.piloterr.com/library).
- **Any language** — plain HTTPS + JSON, with examples for Python, TypeScript, cURL, PHP, C#, Go, Java, Ruby and Node.js.

## FAQ

### Is it legal to scrape GSA eLibrary?

Collecting publicly available data is generally allowed in many jurisdictions, but rules depend on your country, the data you collect and how you use it. Avoid personal data unless you have a lawful basis, respect the website's terms where they apply, and get legal advice for your specific use case. This is not legal advice.

### Do I need proxies or a headless browser?

No. Piloterr handles rendering, proxy rotation and retries on its side. You only send an HTTPS request with your `x-api-key` header and receive JSON.

### How much does a request cost?

Credits per call: `/v2/gsaelibrary/contract` **1**, `/v2/gsaelibrary/search` **1**. See the [Piloterr website](https://www.piloterr.com) for plans.

### What data does the GSA eLibrary API return?

Each endpoint returns structured JSON: **GSA eLibrary Contract** — `url`, `epls`, `email`, `phone`, `address`, `sam_uei`; **GSA eLibrary Search** — `results[]`, `results[].sin`, `results[].url`, `results[].name`, `results[].category`, `results[].description`.

### Which languages are supported?

Any language that can make an HTTP request. This README shows Python and TypeScript; the [`examples/`](examples) folder contains cURL, PHP, C#, Go, Java, Ruby and Node.js.

## Related scrapers

- [About You Scraper API](https://github.com/piloterr/aboutyou-scraper)
- [Action Scraper API](https://github.com/piloterr/action-scraper)
- [Aldi Scraper API](https://github.com/piloterr/aldi-scraper)
- [Alibaba Scraper API](https://github.com/piloterr/alibaba-scraper)
- [AliExpress Scraper API](https://github.com/piloterr/aliexpress-scraper)
- [Allegro Scraper API](https://github.com/piloterr/allegro-scraper)
- [All Piloterr scrapers on GitHub](https://github.com/piloterr)

## Support

- 💬 Join the [Piloterr Discord](https://discord.gg/CFj3ph8aHU) to ask questions and share what you build.
- 📚 Browse the [API reference (OpenAPI)](https://app.piloterr.com/openapi) and the [Piloterr library](https://www.piloterr.com/library).
- 🔑 [Get your API key](https://app.piloterr.com).

---

<p align="center">
  <a href="https://www.piloterr.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
      <img src="images/logo.svg" alt="Piloterr" height="32">
    </picture>
  </a>
  <br>
  <sub>Built by <a href="https://www.piloterr.com">Piloterr</a> — web scraping APIs for e-commerce, search, real estate and more, one API key.</sub>
</p>

<sub>GSA eLibrary is a trademark of its respective owner. This repository is not affiliated with or endorsed by GSA eLibrary. Examples are released under the MIT license.</sub>
