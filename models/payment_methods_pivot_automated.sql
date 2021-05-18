{% set payment_methods_query %}
select distinct payment_method from {{ ref('stg_payments') }}
{% endset %}
{% set results = run_query(payment_methods_query) %}
{% if execute %}
{# Return the first column #}
{% set payment_methods = results.columns[0].values() %}
{% else %}
{% set payment_methods = [] %}
{% endif %}
with 
payments as (
    select * from {{ ref('stg_payments') }}
)
select
    order_id,
    {%- for payment_method_type in payment_methods %}
    sum(case when payment_method = '{{ payment_method_type }}' then amount else 0 end) as {{ payment_method_type }}_amount{{ ',' if not loop.last }}
    {%- endfor -%}
from payments
group by 1