
# 🚚 Supply Chain Performance & Bottleneck Intelligence Dashboard


## 📌 Project Overview

A company was experiencing:

- High delivery delays
- Rising operational costs
- Poor delivery performance
- Declining customer satisfaction
- Lack of visibility into regional and shipping bottlenecks
- Potential revenue exposure from delayed orders

Management needed answers to three key questions:

1. **Where is the supply chain performing poorly?**
2. **What factors are contributing to delivery delays?**
3. **What is the financial impact of these delays?**

## 🎯 Business Problem

The company has a large volume of order and shipment data but lacks a centralized analytical system to understand supply chain performance.

Management cannot easily determine:

- Which shipping modes are underperforming
- Which regions have the highest delivery delays
- Which product categories are affected
- Whether high-value products receive adequate priority
- How delivery performance changes over time
- How much revenue is associated with delayed orders

## 🎯 Project Objectives

The project was designed to:

- Measure overall delivery performance
- Identify major delivery bottlenecks
- Analyze shipping-mode performance
- Compare regional delivery performance
- Analyze product and category performance
- Perform ABC product classification
- Measure revenue associated with delayed deliveries
- Identify high-value products exposed to delivery risk
- Convert analytical findings into business recommendations

## 𝗪𝗛𝗔𝗧 𝗜 𝗕𝗨𝗜𝗟𝗧

Analyzed 170,427 supply chain orders
across 4 years using Python, MySQL,
and Power BI to build a 4-page
executive dashboard that identifies
exactly where the supply chain breaks
down — and quantifies the financial
cost of every broken link.

𝗧𝗼𝗼𝗹𝘀:
Python · Pandas · MySQL · Power BI
· DAX (95 measures) · Excel

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 𝗣𝗔𝗚𝗘 𝟭 — 𝗧𝗛𝗘 𝗖𝗥𝗜𝗦𝗜𝗦

57.30% late delivery rate.
97,660 orders out of 170,427 failed
to arrive on time.

$19,555,003 in revenue is currently
associated with late deliveries.

Industry benchmark: 10-15%.
This supply chain: 57.30%.
4x above benchmark.
Every single month. For 4 years.

The monthly trend line told the
most important story — a flat line
hovering between 56-59% with zero
improvement across 48 months.

This is not a temporary disruption.
This is a chronic strategic failure.

<img width="1132" height="815" alt="Screenshot 2026-09-15 221207" src="https://github.com/user-attachments/assets/9068a91c-60fa-44bb-a0d6-a7c568f13b65" />
<img width="992" height="802" alt="Screenshot 2026-09-15 221213" src="https://github.com/user-attachments/assets/1583df65-9aa9-4596-b763-d87c09c5bb7c" />


## 𝗣𝗔𝗚𝗘 𝟮 — 𝗧𝗛𝗘 𝗖𝗨𝗟𝗣𝗥𝗜𝗧

The shipping mode analysis revealed
something I did not expect.

First Class shipping — the premium
option customers pay more for —
has a 100% late delivery rate.

Not 80%. Not 90%.
One hundred percent.

26,141 First Class orders.
26,141 delivered late.
$5,257,350 revenue. All at risk.

Why?

First Class promises delivery in 1 day.
The logistics network takes 2 days.
Every. Single. Time.

The promise is structurally impossible.

Meanwhile Standard Class — the slowest
and cheapest option — has the best
performance at 39.78% late rate.

Scheduled: 4 days.
Actual: 3.99 days.

Standard Class is the only shipping
mode that keeps its promises.

<img width="987" height="815" alt="Screenshot 2026-09-15 221227" src="https://github.com/user-attachments/assets/3330e4aa-3221-494a-9b54-f843a37ccc50" />
<img width="892" height="801" alt="Screenshot 2026-09-15 221233" src="https://github.com/user-attachments/assets/d9fbc6c4-c9d2-4d85-9a48-a7f83645a3f9" />

## 𝗣𝗔𝗚𝗘 𝟯 — 𝗪𝗛𝗔𝗧 𝗜𝗦 𝗕𝗘𝗜𝗡𝗚 𝗗𝗔𝗠𝗔𝗚𝗘𝗗

ABC Analysis classifies products into:
Class A → top 70% of revenue
Class B → next 20%
Class C → bottom 10%

The late rate across all three classes:
Class A: 57.16%
Class B: 57.21%
Class C: 58.10%

A gap of 0.94 percentage points
between the most valuable and least
valuable products.

There is no priority shipping queue.
A $5 Class C item gets identical
delivery treatment to a $2,000
Class A product.

$12,049,667 of our highest-revenue
products have zero protection.

The category × shipping mode heatmap
proved something crucial — remove
First Class from the analysis and
real category variation appears.

The problem is shipping mode
infrastructure. Not the products.

<img width="1076" height="832" alt="Screenshot 2026-09-15 221249" src="https://github.com/user-attachments/assets/f1cb63ff-c301-42a0-af3d-c6788c867d9a" />

## 𝗣𝗔𝗚𝗘 𝟰 — 𝗪𝗛𝗘𝗥𝗘 𝗔𝗡𝗗 𝗪𝗛𝗔𝗧 𝗡𝗘𝗫𝗧

The geographic map showed no safe
region — every market glows orange
to red. But two numbers stood out:

Europe:  $9,758,561 revenue | Rank 5 delivery
LATAM:   $9,711,305 revenue | Rank 2 delivery

Almost identical revenue.
Completely different delivery performance.

The European logistics partner is
underperforming against a directly
comparable benchmark.

The executive action plan table
translates everything into decisions:

𝟭. Suspend First Class contracts
   Protects: $5,257,350
   Timeline: Week 1

𝟮. Class A priority queue
   Saves:    ~$7,600,000
   Timeline: Month 1

𝟯. Europe logistics audit
   Saves:    ~$1,700,000
   Timeline: Month 2

𝟰. Revise Second Class SLA windows
   Protects: ~$2,600,000
   Timeline: Month 2

𝟱. Review discount strategy
   Gains:    ~$591,000 margin
   Timeline: Quarter 2

Total recovery potential: $17,748,350

<img width="1096" height="826" alt="Screenshot 2026-09-15 221259" src="https://github.com/user-attachments/assets/784beaf7-86d6-47b7-9740-0db6b24d1c6f" />
<img width="1727" height="835" alt="Screenshot 2026-09-15 221600" src="https://github.com/user-attachments/assets/963968a8-1491-4119-87d1-5a489d047edb" />


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 𝗧𝗛𝗘 𝗕𝗜𝗚𝗚𝗘𝗦𝗧 𝗟𝗘𝗦𝗦𝗢𝗡

The data did not just find a problem.
It found 5 specific solutions.
With financial justification.
With timelines.
With business owners.

That is what separates a dashboard
from a decision tool.

A chart shows what happened.
A decision tool tells you
what to do about it.

##  👤 Author

Muhammad Zohaib Khan

BS Software Engineering
COMSATS University Islamabad

## Areas of Interest
Data Analytics
Business Intelligence
Data Science
Machine Learning
AI Engineering
