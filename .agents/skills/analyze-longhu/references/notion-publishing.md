# Notion Database Publishing

## Destination

- Parent page: `longhubang`
- Parent page ID: `3ec7f65b-2405-8004-b6e0-e7861386755e`
- Parent page URL: `https://app.notion.com/p/3ec7f65b24058004b6e0e7861386755e`
- Database title: `龙虎榜优先观察数据`
- Database ID: `231f057d-911d-4762-a9c1-1cd0cdf61174`
- Database URL: `https://app.notion.com/p/231f057d911d4762a9c11cd0cdf61174`
- Data source: `collection://2b3d19d1-7658-4766-9881-e4778ce71c6c`
- Preferred table view: `view://3f37f65b-2405-81a1-9b7f-000c8ecce02c`

The preferred table view is embedded on the parent page and sorts `交易日期` descending. Preserve that sort and the existing database structure.

## Schema

Store one priority-observation stock per row:

| Property | Type | Value |
| --- | --- | --- |
| `股票` | title | Stock name |
| `交易日期` | date | Exact verified trading date |
| `代码` | rich text | Six-character stock code; preserve leading zeroes |
| `涨跌幅（%）` | number | Percentage points, for example `4.41` for 4.41% |
| `成交金额（亿元）` | number | Listed transaction amount converted from 万 to 亿元 |
| `净买入（亿元）` | number | Signed net-buy amount converted from 万 to 亿元 |
| `净买比（%）` | number | Percentage points, for example `14.3` for 14.3% |
| `观察理由` | rich text | Concise rationale |
| `数据源` | URL | `https://data.10jqka.com.cn/market/longhu/` |

## Upsert and Verification

1. Fetch the data source before querying or writing so its current schema is authoritative.
2. Query rows for the exact trading date. Use both `交易日期` and `代码` as the logical unique key.
3. Update an existing matching row. Create a row only when that key does not exist.
4. If duplicate rows already exist for the same key, keep the most recently edited correct row and archive the extras only when the available Notion tool supports a scoped, recoverable archive operation. Otherwise report the duplicates.
5. Do not alter rows from other trading dates. The database view, not physical insertion order, keeps newer dates first.
6. Re-query the exact date after writing. Confirm that every intended stock has exactly one row and that all stored values match the analysis.

If the configured database or data source no longer exists, do not silently create a replacement with a new ID. Report the publication failure so the destination can be deliberately reconfigured.
