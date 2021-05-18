{{
  config(
    materialized='view'
  )
}}

with customers as (
    select * from {{ ref('stg_customers') }}
),
orders as (
    select * from {{ ref('orders') }}
),
customer_order_payments as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(coalesce(total_payment_amount,0)) as lifetime_value
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        cop.first_order_date,
        cop.most_recent_order_date,
        coalesce(cop.number_of_orders, 0) as number_of_orders,
        coalesce(cop.lifetime_value, 0) as lifetime_value
    from customers
    left join customer_order_payments as cop using (customer_id)
)
select * from final