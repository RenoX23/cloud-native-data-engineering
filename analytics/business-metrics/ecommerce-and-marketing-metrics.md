Here is the complete, production-ready content for `ecommerce-and-marketing-metrics.md`. This module covers high-velocity transactional retail, complex attribution tracking loops, and unit profit modeling.

Copy this raw markdown block directly into your repository.

```markdown
# eCommerce & Marketing Metrics: Transactional Velocity & Attribution Modeling

This document establishes the analytical frameworks required to evaluate B2C commerce pipelines, digital marketing budgets, and purchase behavior. Unlike subscription models, eCommerce relies on discrete, high-frequency transactions where profitability hinges on optimizing conversion funnels, maximizing basket values, and attributing marketing spend accurately across multi-touch digital channels.

---

## 1. The eCommerce Financial Engine

In transactional commerce, financial health is determined by tracking the margins on individual units shipped and the purchasing behavior of customers within a single session.

### A. Average Order Value (AOV)
* **What it actually is:** The average gross dollar amount spent by a customer every time they complete a checkout transaction.
* **The Strategic Value:** Increasing AOV is often significantly cheaper than acquiring new customers. It is the primary lever used to offset rising acquisition costs (CAC).
* **Optimization Vectors:** Driven by product recommendation engines (cross-selling complementary items), volume-based discount thresholds (e.g., "Spend \$50 to get free shipping"), and product bundling.
* **Formula:**
  $$\text{AOV} = \frac{\text{Total Revenue}}{\text{Total Number of Completed Orders}}$$

### B. Purchase Frequency & Repeat Purchase Rate
* **What it actually is:** The structural velocity of your customer retention. It tracks how often a unique customer returns to buy from your store within a defined period (typically a 365-day trailing window).
* **The Nuance:** High purchase frequency indicates strong brand loyalty or an inherently consumable product line (e.g., groceries, cosmetics). Low purchase frequency requires a business to constantly acquire new customers to survive, placing intense pressure on marketing efficiency.
* **Formulas:**
  $$\text{Purchase Frequency} = \frac{\text{Total Orders Processed}}{\text{Total Unique Customers}}$$
  $$\text{Repeat Purchase Rate} = \frac{\text{Number of Customers with } >1\text{ Purchase}}{\text{Total Unique Customers}} \times 100$$

### C. Contribution Margin (Unit-Level Profitability)
* **The Vanity Trap:** Tracking Gross Revenue or Gross Profit alone can hide structural losses. An analyst must calculate **Contribution Margin**, which isolates the true profit of an item after subtracting all variable costs required to ship that specific unit.
* **Variable Costs Include:** Cost of Goods Sold (COGS), pick-and-pack fulfillment warehouse fees, shipping carrier fees, packaging materials, and payment gateway percentages (e.g., Stripe's 2.9% + \$0.30).
* **Formula:**
  $$\text{Contribution Margin} = \text{Revenue} - (\text{COGS} + \text{Shipping Cost} + \text{Fulfillment Cost} + \text{Transaction Fees})$$

---

## 2. Marketing Performance & Spend Efficiency

Modern marketing requires tracking how capital deployed across platforms (Meta Ads, Google Ads, TikTok Shop) translates into conversions.

### A. Customer Acquisition Cost (CAC) vs. Blended MER
* **Paid CAC:** The marketing spend of a *specific paid channel* divided by the users attributed directly to that channel.
* **Blended MER (Marketing Efficiency Ratio):** The holistic view of your entire business's marketing efficiency. It prevents attribution silos from hiding reality.
* **Why Blended MER Matters:** Paid ad channels often claim duplicate attribution for the same user. For example, a user might click a Meta ad, then later click a Google Branded Search ad before purchasing. Both platforms will claim 100% credit for that sale. Blended MER gives executives a realistic view of overall spend efficiency.
* **Formula:**
  $$\text{Blended MER} = \frac{\text{Total Net Revenue}}{\text{Total Marketing Ad Spend across All Channels}}$$
  *A MER of 4x means the company generates \$4 of revenue for every \$1 spent on marketing.*

### B. ROAS (Return on Ad Spend)
* **What it is:** A platform-level efficiency metric measuring the gross revenue generated per dollar spent on a specific advertising campaign.
* **The Trap:** ROAS does *not* equal profitability. If your gross margins are low (e.g., 30%), a campaign with a 3x ROAS is actually losing money when you factor in product costs. Analysts must calculate the **Break-Even ROAS**.
* **Formula:**
  $$\text{ROAS} = \frac{\text{Revenue Attributed to Ad Campaign}}{\text{Cost of Ad Campaign}}$$
  $$\text{Break-Even ROAS} = \frac{1}{\text{Gross Margin \%}}$$

---

## 3. Digital Marketing Attribution Models

Attribution defines how credit for a conversion is allocated across the various touchpoints a user interacts with before completing an order.



| Attribution Model | Logic Definition | Strategic Use Case | Fundamental Flaw |
| :--- | :--- | :--- | :--- |
| **First-Touch** | Gives 100% of the conversion credit to the very first channel the user clicked. | Top-of-Funnel (ToFu) analysis. Excellent for identifying which channels drive brand awareness. | Completely ignores retargeting efforts and the final channels that closed the deal. |
| **Last-Touch** | Gives 100% of the credit to the final channel the user clicked before checking out. | Bottom-of-Funnel (BoFu) analysis. Evaluates direct conversion triggers. | Biased toward branded search and email marketing; ignores the channels that discovered the user. |
| **Linear** | Distributes credit equally across every single touchpoint in the user journey. | Useful for long, highly collaborative sales cycles. | Over-values accidental or passive clicks that had no impact on the buying decision. |
| **Time-Decay** | Gives more credit to touchpoints that occurred closest in time to the conversion event. | Ideal for high-intent, short-window promotional campaigns (e.g., Black Friday sales). | Under-values the initial discovery touchpoint if the research cycle is long. |
| **Data-Driven (W-Shaped/Algorithmic)** | Uses machine learning/statistical modeling to analyze historical user paths and assign credit based on actual incremental lift. | The modern industry standard for complex, multi-million dollar multi-channel budgets. | Requires high data volume and complex data pipeline infrastructure to compute accurately. |

---

## 4. The Marketing-Commerce Translation Layer (SQL State)

### Scenario A: Calculating Basket Analytics (Items Purchased Together)
* **The Ambiguous Ask:** *"What items do people usually buy at the same time so we can create product bundles?"*
* **The Engineering Formulation:** Perform a self-join on the transaction line-item database table where the `order_id` matches, but the product identifiers are distinct. Group the results by product pairs and rank them by co-occurrence frequency.
* **The Execution Logic:**
```sql
WITH transaction_items AS (
    -- Clean and isolate successful order items
    SELECT
        order_id,
        product_id,
        product_name
    FROM production.order_items oi
    JOIN production.orders o ON oi.order_id = o.id
    WHERE o.status = 'DELIVERED'
)
SELECT
    a.product_name AS primary_item,
    b.product_name AS co_purchased_item,
    COUNT(*) AS joint_purchase_count,
    -- Calculate relative popularity rank within each primary item category
    RANK() OVER(PARTITION BY a.product_name ORDER BY COUNT(*) DESC) AS correlation_rank
FROM transaction_items a
JOIN transaction_items b ON a.order_id = b.order_id
  -- Prevent self-matching a product (A to A) and avoid duplicate reciprocal pairs (A to B and B to A)
  AND a.product_id < b.product_id
GROUP BY a.product_name, b.product_name
QUALIFY correlation_rank <= 5
ORDER BY joint_purchase_count DESC;

```

### Scenario B: Tracking Multi-Channel Funnel Drop-off (Checkout Abandonment)

* **The Ambiguous Ask:** *"Where are we losing users during the checkout process on our website?"*
* **The Engineering Formulation:** Construct a funnel visualization using conditional aggregation over clickstream telemetry data. We will track users across four distinct chronological steps: viewing a product, adding it to the cart, starting checkout, and completing payment.
* **The Execution Logic:**

```sql
WITH checkout_funnel_steps AS (
    SELECT
        user_session_id,
        MAX(CASE WHEN event_name = 'product_viewed' THEN 1 ELSE 0 END) AS step_1_view,
        MAX(CASE WHEN event_name = 'cart_added' THEN 1 ELSE 0 END) AS step_2_cart,
        MAX(CASE WHEN event_name = 'checkout_initiated' THEN 1 ELSE 0 END) AS step_3_checkout,
        MAX(CASE WHEN event_name = 'payment_completed' THEN 1 ELSE 0 END) AS step_4_payment
    FROM telemetry.web_traffic_logs
    WHERE event_timestamp BETWEEN '2026-05-01' AND '2026-05-15'
    GROUP BY user_session_id
)
SELECT
    SUM(step_1_view) AS product_views,
    SUM(step_2_cart) AS cart_additions,
    SUM(step_3_checkout) AS checkout_starts,
    SUM(step_4_payment) AS completed_purchases,
    -- Calculate conversion efficiencies between adjacent steps
    SAFE_DIVIDE(SUM(step_2_cart), SUM(step_1_view)) * 100 AS view_to_cart_pct,
    SAFE_DIVIDE(SUM(step_3_checkout), SUM(step_2_cart)) * 100 AS cart_to_checkout_pct,
    SAFE_DIVIDE(SUM(step_4_payment), SUM(step_3_checkout)) * 100 AS checkout_to_payment_pct,
    -- Total end-to-end funnel conversion rate
    SAFE_DIVIDE(SUM(step_4_payment), SUM(step_1_view)) * 100 AS macro_conversion_rate
FROM checkout_funnel_steps;

```

```

