-- EDA

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;
SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify; -- there are 3 unique ablum types
-- Checking max and min durations
SELECT MAX(duration_min) FROM spotify; --77.93
SELECT MIN(duration_min) FROM spotify; -- 0

SELECT * FROM spotify
WHERE duration_min=0;

DELETE FROM spotify 
WHERE duration_min=0;

SELECT * FROM spotify
WHERE duration_min=0;

SELECT DISTINCT channel FROM spotify; --6673 distinct channels

SELECT DISTINCT most_played_on FROM spotify;-- only 2 values YT and spotify

-- -------------------------
-- Business Problems
-- -------------------------
SELECT * FROM spotify LIMIT 10;
/*1 Retrieve the names of all tracks that have more than 1 billion streams.*/
SELECT track FROM spotify 
WHERE stream > 1000000000;
/*2List all albums along with their respective artists.*/
SELECT DISTINCT album, artist FROM spotify ORDER BY 1;
/*3Get the total number of comments for tracks where licensed = TRUE.*/
SELECT SUM(comments) as total_comments FROM spotify WHERE licensed= true;
/*4Find all tracks that belong to the album type single.*/
SELECT track FROM spotify WHERE album_type='single';
/*5Count the total number of tracks by each artist.*/
SELECT * FROM spotify;
SELECT 
	artist,count(track) as total_no_tracks 
FROM spotify 
Group By 1 
ORDER BY 2 DESC;

/*6 Calculate the average danceability of tracks in each album.*/
SELECT * FROM spotify;
SELECT 
	album,
	avg(danceability) as average_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;
	
/* 7 Find the top 5 tracks with the highest energy values.*/
SELECT  track,
		MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
/* 8 List all tracks along with their views and likes where official_video = TRUE.*/
SELECT 
		track,
		SUM(views) AS total_views,
		SUM(likes) AS total_likes
FROM spotify
WHERE official_video='true'
GROUP BY 1
ORDER BY 2 DESC;

/* 9 For each album, calculate the total views of all associated tracks.*/
SELECT album,
	   track,
	   sum(views) as total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;
/* 10 Retrieve the track names that have been streamed on Spotify more than YouTube.*/
SELECT * FROM
(SELECT track,
		COALESCE(SUM(CASE WHEN most_played_on='Youtube'THEN stream END),0) as streamed_on_youtube,
		COALESCE(SUM(CASE WHEN most_played_on='Spotify'THEN stream END),0) as streamed_on_spotify
FROM spotify
GROUP BY 1) as t1
WHERE streamed_on_spotify> streamed_on_youtube AND streamed_on_youtube <> 0;

/*11 Find the top 3 most-viewed tracks for each artist using window functions. */
WITH ranking_artist
AS
(SELECT artist,
		track,
		sum(views) as total_views,
		-- dense rank does continuously ranking without skipping i.e same values will be ranked same
		DENSE_RANK() OVER(PARTITION BY artist ORDER BY sum(views) DESC) as rank
FROM spotify 
GROUP BY 1,2
ORDER BY 1,3 DESC 
)

SELECT * 
FROM ranking_artist 
WHERE rank <=3;

/* 12Write a query to find tracks where the liveness score is above the average.*/

SELECT track,
	artist,
	liveness
FROM spotify
WHERE liveness> (SELECT avg(liveness) FROM spotify);

/* 13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.*/
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC;
		
-- Query Optimization with indexing 
Explain ANALYZE
SELECT
	artist,
	track,
	views
FROM spotify
WHERE artist='Gorillaz'
	AND most_played_on='Youtube'
ORDER BY stream DESC LIMIT 25;

CREATE INDEX artist_index on spotify(artist);

