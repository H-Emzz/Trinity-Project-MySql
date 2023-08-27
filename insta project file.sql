use ig_clone;
show  tables;
select * from users order by created_at asc limit 5;
select user_id, count(*)
from photos
group by user_id;
select * from photos,users;

-- 2.identify users with no posts
 select username
 from users
 left join photos
 on users.id = photos.user_id
 where photos.id is null limit 5;
 
	
 select photos.id,
 photos.image_url,
 count(*) as total
from photos
inner join likes 
on likes.photo_id = photos.id
group by photo_id	
order by total desc
limit 1;



select  tags.tag_name, count(*) as total_popular
from photo_tags
join tags
on photo_tags.tag_id = tags.id
group by tags.id
order by total_popular desc
limit 5;


select  dayname(created_at) as days,
count(*) as total
from users
group by days
order by total desc
limit 2;



select
(select count(*) from photos) / (select count(*) from users);


select id, username
from users
where id in (select user_id 
from likes
group by user_id
having count(user_id) =  (select count(id) from photos));