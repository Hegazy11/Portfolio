-- best_selling_games
SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10; 


--Rank games released in 2022 by user score in descending order.
SELECT RANK() OVER(ORDER BY user_score DESC) AS RANK,g.name,r.user_score,g.platform,g.publisher,g.developer,g.games_sold
FROM reviews as r
JOIN game_sales as g
ON r.name=g.name
WHERE g.year=2015 AND r.user_score IS NOT NULL;

-- critics_top_ten_years
SELECT year,num_games,avg_critic_score
FROM public.critics_avg_year_rating
WHERE num_games >=4
ORDER BY public.critics_avg_year_rating.avg_critic_score DESC
LIMIT 10;

-- golden_years
SELECT u.year,u.num_games,c.avg_critic_score,u.avg_user_score,ABS(c.avg_critic_score-u.avg_user_score) AS diff
FROM public.users_avg_year_rating AS u
JOIN public.critics_avg_year_rating AS c
ON u.year=c.year
WHERE avg_critic_score > 9 OR avg_user_score > 9
ORDER BY diff;


--Determine the platform with the lowest average user review score for each publisher.
WITH average AS (
	SELECT publisher,platform,AVG(r.user_score) AS avg_user_score
	FROM game_sales as g
	JOIN reviews as r
	ON g.name=r.name 
	GROUP BY publisher,platform),
				 
min AS (
	SELECT publisher,MIN(avg_user_score) as min_avg_user_score
			from average
			group by publisher)

SELECT a.publisher,a.platform,a.avg_user_score 
FROM average AS a
JOIN min as m 
ON a.publisher=m.publisher AND a.avg_user_score=m.min_avg_user_score;


--Which publishers published games that sold more copies than the 3rd best selling game of 2019?
SELECT DISTINCT publisher
FROM game_sales 
WHERE games_sold > (SELECT games_sold
   					FROM game_sales 
 					WHERE year = 2019
   				    ORDER BY games_sold DESC 
   					OFFSET 2 LIMIT 1);


--Which games had higher critic scores than the average critic score of EA Sports games?
SELECT name,AVG(critic_score) AS avg_critic_score
FROM reviews 
GROUP BY name
HAVING critic_score > (SELECT AVG(r.critic_score)
							 FROM reviews AS r
							 JOIN game_sales AS g 
							 ON r.name=g.name
							 WHERE g.publisher='EA Sports');