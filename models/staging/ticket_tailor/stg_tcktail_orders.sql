select
    id as order_id,
    status as order_status,
    refund_amount/100 as refunded_amount,
    total/100 as total_amount,
    to_timestamp(created_at) as created_at

from {{source('ticket_tailor','orders')}}