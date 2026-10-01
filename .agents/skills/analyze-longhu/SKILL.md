---
name: analyze-longhu
description: Fetch and analyze the latest daily A-share Dragon-Tiger List from Tonghuashun for Shanghai and Shenzhen non-ST stocks, then publish the dated priority-observation table to the configured Notion page. Use when the user asks for today's or a specified trading day's 龙虎榜, capital-flow ranking, short-term trading candidates, net-buy analysis, turnover analysis, or a repeatable daily 龙虎榜 review.
---

# Analyze Longhu

## Goal

Produce a date-verified, data-driven review of Shanghai and Shenzhen non-ST stocks on the Tonghuashun Dragon-Tiger List. Treat the output as market research, not personalized investment advice.

## Workflow

1. Determine the requested trading date. Default to the current date in the user's timezone.
2. Open `https://data.10jqka.com.cn/market/longhu/` with the Browser skill.
3. Verify the date displayed by the page. Never call stale data "today's data."
4. If the current day's list is unavailable, report the latest available trading date and analyze that date only after clearly labeling it.
5. Read the summary table with these fields:
   - list period marker, such as blank or `3日`
   - stock code
   - stock name
   - latest price
   - price change
   - listed transaction amount
   - net buy amount
6. If Browser is unavailable, run `scripts/extract_longhu.ps1`. The script fetches the public page and returns structured JSON.
7. Apply the filtering and ranking rules below.
8. Present the result using the required output format.
9. Publish the dated `优先观察` table to the configured Notion page using the workflow below.

## Filtering

Keep only:

- Shenzhen codes beginning with `000`, `001`, `002`, `003`, `300`, or `301`
- Shanghai codes beginning with `600`, `601`, `603`, or `605`
- ordinary non-ST stocks
- single-day rows where the period marker is blank

Exclude:

- names containing `ST`, `*ST`, or `退市`
- Beijing Stock Exchange stocks
- STAR Market stocks beginning with `688`
- duplicate `3日` rows
- rows with missing or zero transaction amount

Explain that Tonghuashun's summary field is `成交金额`, not share volume, when the user asks for 成交量.

## Metrics

Calculate:

```text
net_buy_ratio = net_buy_amount / listed_transaction_amount * 100
```

Use all of the following rather than ranking on net buy alone:

- listed transaction amount as a liquidity/activity signal
- net buy amount as an absolute capital-flow signal
- net buy ratio as a capital-intensity signal
- price change as confirmation or divergence
- whether the stock closed near a 10% or 20% limit

Read `references/methodology.md` for scoring, candidate groups, and risk interpretation.

## Required Output

Start with:

- source URL
- exact data date
- filters applied
- number of qualifying stocks

Then provide:

1. `优先观察`: normally 3-6 stocks with code, change, transaction amount, net buy, net-buy ratio, and concise rationale.
2. `强势但不追高`: limit-up or near-limit stocks with strong flows that require next-day confirmation.
3. `资金价格背离/回避`: stocks with positive net buying but sharp price declines, or high activity with major net selling.
4. `次日观察条件`: objective confirmation and invalidation conditions, without presenting guaranteed entry prices.
5. A brief conclusion naming the highest-quality observation candidates and why.

Keep the distinction between:

- suitable for observation
- suitable only after confirmation
- unsuitable to chase

Never say that any stock is certain to rise or directly instruct the user to buy. Include a concise statement that龙虎榜 data is a one-day snapshot and does not constitute investment advice.

## Data Integrity

- Prefer the authoritative visible date and summary table on Tonghuashun.
- Do not combine different trading dates.
- Do not silently substitute search-result snippets for the source table.
- State any missing fields, access restrictions, or incomplete publication.
- Preserve signs and units when converting `万` and `亿`.
- Deduplicate by stock code after excluding multi-day rows.

## Notion Publishing

After completing the analysis, publish the latest `优先观察` table to the top of the existing Notion page:

- Page title: `longhubang`
- Page ID: `3ec7f65b-2405-8004-b6e0-e7861386755e`
- Page URL: `https://app.notion.com/p/3ec7f65b24058004b6e0e7861386755e`

Before writing, fetch the page and preserve all existing content. Add a dated section at the very beginning of the page using this structure:

1. Heading: `龙虎榜优先观察 — YYYY-MM-DD`, using the exact verified trading date rather than the execution date.
2. A table with: stock name, code, price change, listed transaction amount, net buy amount, net-buy ratio, and concise rationale.
3. A source link to `https://data.10jqka.com.cn/market/longhu/`.

Keep the newest trading date at the top. If a section for the same trading date already exists, update that section in place instead of creating a duplicate. Never replace, delete, or reorder older dated sections except as needed to keep the newest section first.

Use the connected Notion tools rather than browser UI when available. Fetch the page again after writing and verify that the date and every priority-observation row were saved. If Notion is unavailable, disconnected, read-only, or the write fails, report that the analysis succeeded but publishing did not; do not retry the same failed write more than once.

