-- netflix project
drop table if exists netflix;
create table netflix
(
	show_id VARCHAR(6),	
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country	VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating	VARCHAR(10),
	duration VARCHAR(25),
	listed_in	VARCHAR(100),
	description VARCHAR(250)
);

select* from netflix;


select
count (*) as total_content
from netflix;


-- Business problems
--Q1) Count the number of movies and tv shows

select
	type,
	count(*) as total_content
from netflix
group by type


-- Q2) find the most common rating for movies and TV shows
 select type, rating 
 from(
 select 
 	type, 
	rating,
	count(*) as c,
	RANK() OVER (PARTITION BY type ORDER BY count(*) DESC ) as ranking
from netflix
group by type, rating
)
as t1
where ranking=1

--Q3) List all the movies in a specific year (e.g. 2019)
select * from netflix
where
type= 'Movie'
and 
release_year= 2019

--Q4) find the top 5 countries with the most content on netflix
select 
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;

--Q5) Identify the longest movie
select * from netflix
where 
	type= 'Movie'
	and
	duration = (select max(duration) from netflix)


--Q6) find content added in the last 5 years

SELECT *
FROM netflix
where to_date(date_added,'Month DD, YYYY')>= current_date- interval '5 years';

--Q7) Find all the movies/TV shows by directo 'Rajuv Chilaka'
select * from netflix
where director Ilike'%Rajiv Chilaka%'

-- Q8) List all the TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--Q9) Count the number of contents items in each genre
select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1

-- Q10) Find each year and the average numbers of content release in India on netflix
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


-- 11. List all movies that are documentaries
select *
from netflix
where listed_in like '%Documetaries';

-- 12. Find all content without a director
select *
from netflix
where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select *
from netflix
where casts like '%Salman Khan%'
and release_year> EXTRACT(Year from current_date)-10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select
unnest(string-to_array(casts,',')) as actor,
count(*)
rom netflix
where country='India'
group by actor
order by count(*) Desc
limit 10; 

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

select 
catgory, 
count(*) as content_count
from (
select 
case 
	when description ILIKE '%Kill' or description else 
	'good'
end as category
from netflix
) as categorized_content
group by category; 