select category.name, count(*) as count_film from film
join film_category using(film_id) 
join category using(category_id)
group by category.name
order by count_film desc;

select actor_id, actor.first_name, actor.last_name, count(*) as count_actor from rental
join inventory using(inventory_id)
join film using(film_id)
join film_actor using(film_id)
join actor using(actor_id)
group by actor_id, actor.first_name, actor.last_name
order by count_actor desc
limit 10;

select sum(film.rental_rate *
ceil(EXTRACT(EPOCH FROM (rental.return_date - rental.rental_date) / 3600))) as money, 
category_id, category.name
from rental 
join inventory using(inventory_id)
join film using(film_id)
join film_category using(film_id)
join category using(category_id)
group by category_id, category.name
order by money desc
limit 1;

select title from inventory
right join film using(film_id)
group by film_id, title
having count(*) = 1;

select actor_id, first_name, last_name, count(*) as count_films 
from actor 
join film_actor using(actor_id)
join film_category using(film_id)
join category using(category_id)
where category.name = 'Children'
group by actor_id, first_name, last_name
order by count_films desc
limit 3;

select city_id, count(*) as active_count, 0 as non_active_count from customer 
join address using(address_id)
join city using(city_id)
where customer.active = 1
group by city_id
union
select city_id, 0 as active_count, count(*) as non_active_count from customer 
join address using(address_id)
join city using(city_id)
where customer.active = 0
group by city_id
order by non_active_count desc, active_count desc;

select distinct on(tabl.city) tabl.city, tabl.name_category from (
select city_id, city, category_id, category.name as name_category,
sum(ceil(EXTRACT(EPOCH FROM (rental.return_date - rental.rental_date) / 3600))) as hours
from rental
join inventory using(inventory_id)
join customer using(customer_id)
join address using(address_id)
join city using (city_id)
join film using(film_id)
join film_category using(film_id)
join category using(category_id)
where city like 'A%' or city like 'a%' or city like '%-%'
group by city_id, city, category_id, category.name
having sum(ceil(EXTRACT(EPOCH FROM (rental.return_date - rental.rental_date) / 3600))) is not null
order by city_id, hours desc) as tabl;