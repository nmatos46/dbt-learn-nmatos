{% set payment_methods= ['credit_card','coupon','bank_transfer','gift_card']%}

with

payments as (
    select * from {{ref('stg_payments')}}
)

select 
    order_id,
    {%- for payment_method_type in payment_methods%}
    sum(case when payment_method = '{{ payment_method_type }}' then amount else 0 end) as {{payment_method_type}}_amount{{',' if not loop.last}}
    {%endfor%}

from payments
Group by 1