# Analysis Methodology

## Candidate Groups

### Priority Observation

Favor stocks meeting several of these conditions:

- positive price change without already being locked at the daily limit
- listed transaction amount at least RMB 300 million
- net buy amount at least RMB 50 million
- net-buy ratio at least 10%
- price action confirms rather than contradicts the positive capital flow

These thresholds are defaults, not hard guarantees. Tighten them when the list is crowded and relax them transparently when very few stocks qualify.

### Strong Flow, High Chase Risk

Place stocks here when:

- price change is near the applicable daily limit
- net buy amount and net-buy ratio are both strong
- liquidity is sufficient

Describe these as strong-flow observation names, not immediate entries. Look for next-day turnover, opening-gap restraint, and intraday support.

### Divergence or Avoid

Flag stocks when:

- net buying is positive but price falls sharply
- the stock closes near the downside limit
- transaction amount is high while net selling is substantial
- net-buy ratio is small despite a visually large absolute number

Positive net buying during a large decline can represent disagreement, failed support, or trapped capital. Do not automatically interpret it as accumulation.

## Comparative Score

Use this score only to organize judgment, not as a prediction:

```text
liquidity_score:
  2 = transaction amount >= RMB 1 billion
  1 = RMB 300 million to RMB 1 billion
  0 = below RMB 300 million

flow_score:
  3 = net buy >= RMB 300 million
  2 = RMB 100 million to RMB 300 million
  1 = RMB 50 million to RMB 100 million
  0 = below RMB 50 million

intensity_score:
  3 = net-buy ratio >= 30%
  2 = 20% to 30%
  1 = 10% to 20%
  0 = below 10%

confirmation_score:
  2 = price change from 2% to below 9.5%
  1 = price change from 0% to below 2%
  0 = limit-up/near-limit or mildly negative
 -2 = price change <= -7%
```

Use the score as a sorting aid. Prefer balanced liquidity, flow, and price confirmation over the highest raw score.

## Next-Day Conditions

Useful confirmation signals:

- opening gap is restrained rather than excessively extended
- price holds the volume-weighted average price after an initial pullback
- turnover remains active without immediate heavy selling
- sector peers are not collapsing

Invalidation signals:

- large high opening followed by a rapid break below the average price
- expanding volume with persistent selling
- loss of the prior day's key support
- sector-wide reversal

Avoid rigid universal percentages when market volatility differs. If percentages are used, label them as risk controls or observation thresholds rather than forecasts.

