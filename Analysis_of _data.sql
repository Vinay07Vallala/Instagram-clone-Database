-- 1. 5 oldest users

SELECT * 
FROM users
ORDER BY created_at
LIMIT 5;


-- 2. Most Popular Registration Day in a week 

SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;

-- 3. Inactive Users (users with no photos)

SELECT username
FROM users
LEFT JOIN photos
    ON users.id = photos.user_id
WHERE photos.id IS NULL;


--  4. Most popular photo (and user who created it)

SELECT 
    username,
    photos.id,
    photos.image_url, 
    COUNT(*) AS total
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

-- 5. Average number of photos per user

SELECT (SELECT Count(*) 
        FROM   photos) / (SELECT Count(*) 
                          FROM   users) AS avg; 


-- 6. The five most popular hashtags

SELECT tags.tag_name, 
       Count(*) AS total 
FROM   photo_tags 
       JOIN tags 
         ON photo_tags.tag_id = tags.id 
GROUP  BY tags.id 
ORDER  BY total DESC 
LIMIT  5; 



-- 7. The bots - the users who have liked every single photo

SELECT username, 
       Count(*) AS num_likes 
FROM   users 
       INNER JOIN likes 
               ON users.id = likes.user_id 
GROUP  BY likes.user_id 
HAVING num_likes = (SELECT Count(*) 


-- 8 Users who have never commented on a photo 
                    
select username,user_id
    from users 
            left join comments
                        on user_id = users.id  
where comments.id is null;
                    
                    
-- 9  The percentage of our users who have either never commented on a photo or have commented on every photo
                    
    select concat(
                (
                    (
                        (select count(*) from users left join comments on comments.user_id = users.id where comments.id is null) 
                  +        
                  (select count(*) from 
                                       (select count(*) from users join comments on comments.user_id = users.id group by user_id having count(comments.id) 
                                   = (select count(*) from photos)) as bots)
                        
                    )*100 
                    /  (select count(*) from users)
                ),'%')
                        as 'Percentage of Abnormal users' ;
