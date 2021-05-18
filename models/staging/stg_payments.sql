{{
  config(
    materialized='view'
  )
}}

select
    OrderID as order_id,
    Status as Payment_Status,
    Amount

from raw.stripe.payment