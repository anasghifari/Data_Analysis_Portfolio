-- 1. Which product categories generate the highest Gross Merchandise Value (GMV) on the platform, and how does that compare to order volume?

select 
	pcnt.product_category_name_english as product_category,
	count(distinct ooid.order_id) as order_volume,
	round(sum(price),2) as total_gmv
from olist_order_items_dataset ooid 
join olist_products_dataset opd on ooid.product_id = opd.product_id 
join product_category_name_translation pcnt on opd.product_category_name = pcnt.product_category_name
group by pcnt.product_category_name_english 
order by total_gmv asc
limit 10;

-- 2. Which sellers have the highest late-delivery rate, and does it correlate with review scores?

with seller_orders as(
	select 
		ooid.seller_id,
		ood.order_id,
		ood.order_delivered_customer_date,
		ood.order_estimated_delivery_date,
		case 
			when ood.order_delivered_customer_date > ood.order_estimated_delivery_date
			then 1 else 0
		end as is_late
	from olist_order_items_dataset ooid
	join olist_orders_dataset ood on ooid.order_id = ood.order_id
	where ood.order_status = 'delivered' and ood.order_delivered_customer_date is not null 
),
seller_reviews as (
	select 
		ooid.seller_id,
		avg(oord.review_score) as avg_review_score 
	from olist_order_items_dataset ooid
	join olist_order_reviews_dataset oord on ooid.order_id = oord.order_id
	group by ooid.seller_id	
)
select 
	so.seller_id,
	count(distinct so.order_id) as total_orders, 
	sum(so.is_late) as late_orders,
	round(sum(so.is_late)*100/ count(distinct so.order_id), 2) as late_orders_percentage, 
	round(sr.avg_review_score, 2) as  average_review_score
from seller_orders so 
join seller_reviews sr on so.seller_id = sr.seller_id
group by so.seller_id, sr.avg_review_score
having count(distinct so.order_id) >= 20
order by late_orders_percentage desc 
limit 20;

-- 3. Monthly revenue growth over time

with monthly_gmv as (
	select 
		date_format(ood.order_purchase_timestamp, '%Y-%M') as order_month,
		round(sum(ooid.price),2) as total_gmv 
	from olist_orders_dataset ood 
	join olist_order_items_dataset ooid on ood.order_id = ooid.order_id
	where ood.order_status = 'delivered'
	group by order_month
)
select 
	mg.order_month,
	mg.total_gmv,
	lag(mg.total_gmv) over (order by mg.order_month) as previous_month_gmv,
	round(
		(mg.total_gmv - lag(mg.total_gmv) over (order by mg.order_month))/lag(mg.total_gmv) over (order by mg.order_month)*100 
		,2) as monthly_growth_percentage 
from monthly_gmv mg
order by mg.order_month;

-- 4. Customer retention — % of customers who order more than once

with customer_records as(
	SELECT 
		ocd.customer_unique_id as customer,
		count(distinct ood.order_id) as total_orders
	FROM olist_customers_dataset ocd
	join olist_orders_dataset ood on ocd.customer_id = ood.customer_id
	where ood.order_status = 'delivered'
	group by ocd.customer_unique_id
)
select
	count(case when cr.total_orders >= 2 then 1 end) as repeat_orders,
	count(*) as total_customers,
	round(count(case when cr.total_orders >=2 then 1 end)*100/count(*) ,2) as retention_percentage
from customer_records cr


-- 5. Which states/regions have highest average order value?

with order_values as(
	select
		ooid.order_id, 
		ocd.customer_state,
		sum(ooid.price) as total_value
	from olist_order_items_dataset ooid 
	join olist_orders_dataset ood on ooid.order_id = ood.order_id 
	join olist_customers_dataset ocd on ood.customer_id = ocd.customer_id
	where ood.order_status = 'delivered'
	group by ocd.customer_state, ooid.order_id 
)
select 
	ov.customer_state,
	count(distinct ov.order_id),
	round(avg(ov.total_value), 2) as average_order_value 
from order_values ov
group by ov.customer_state
order by average_order_value desc 

-- 6. Payment method analysis (most used payment type)

select 
	oopd.payment_type,
	count(oopd.payment_type) as most_used_payment,
	round(avg(oopd.payment_value), 2) as average_value,
	round(avg(oopd.payment_installments), 2) as average_instalments 
from olist_order_payments_dataset oopd 
where oopd.payment_type != 'not_defined' 
group by oopd.payment_type
order by most_used_payment desc 

-- 7. What is the average gap (in days) between the actual delivery date and the estimated delivery date — and which states are worst affected

with order_gap as (
	select 
		ood.order_id,
		ocd.customer_unique_id, 
		ocd.customer_state, 
		ood.order_estimated_delivery_date, 
		ood.order_delivered_customer_date,
		datediff(ood.order_delivered_customer_date, ood.order_estimated_delivery_date) as days_gap 
	from olist_orders_dataset ood 
	join olist_customers_dataset ocd on ood.customer_id = ocd.customer_id 
	where ood.order_status = 'delivered' 
		and ood.order_delivered_customer_date is not null 
		and ood.order_delivered_customer_date != ''
)
select 
	og.customer_state,
	round(avg(og.days_gap), 2) as average_day_gaps
from order_gap og
group by og.customer_state
order by average_day_gaps desc 
	
-- 8. Top sellers by revenue + rating combined

CREATE INDEX idx_items_seller ON olist_order_items_dataset(seller_id);
CREATE INDEX idx_items_order  ON olist_order_items_dataset(order_id);
CREATE INDEX idx_reviews_order ON olist_order_reviews_dataset(order_id);

with seller_stats as(
	select 
		ooid.seller_id,
		osd.seller_city,
		count(distinct ooid.order_id) as total_orders,
		round(sum(ooid.price), 2) as total_revenue,
		round(avg(oord.review_score ), 2) as average_ratings
	from olist_order_items_dataset ooid 
	join olist_sellers_dataset osd on ooid.seller_id = osd.seller_id 
	join olist_order_reviews_dataset oord on ooid.order_id = oord.order_id 
	group by ooid.seller_id, osd.seller_city 
	having count(distinct ooid.order_id) >= 10 
)
select
	ss.seller_id,
	ss.seller_city,
	ss.total_orders,
	ss.total_revenue,
	ss.average_ratings,
	rank() over (order by total_revenue desc) as revenue_rank,
    rank() over (order by average_ratings desc) as rating_rank,
    rank() over (order by total_revenue desc) + 
    rank() over (order by average_ratings desc) as combined_rank
from seller_stats ss
order by combined_rank asc 
limit 20



