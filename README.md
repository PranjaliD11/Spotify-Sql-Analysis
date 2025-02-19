# **Spotify Data Analysis: SQL Queries and Query Optimization**

## **Project Overview**  

This project aims to analyze Spotify's music dataset by utilizing SQL queries to uncover trends and insights related to tracks, albums, and artists. The analysis covers a range of query complexities, from basic retrieval to advanced techniques like window functions and query optimization on 20k+ rows of data.

---

## **Project Workflow**  

### **1. Data Exploration**  
Before diving into the SQL queries, we explored the dataset to understand its structure and contents. Key attributes in the dataset include:

- **Artist:** The performer of the track.
- **Track:** The name of the song.
- **Album:** The album to which the track belongs.
- **Album_type:** The type of album (e.g., single or album).
- **Metrics:** Danceability, energy, loudness, tempo, and more.

### **2. Querying the Data**  
Once the data was loaded into the database, we divided the queries into three levels of complexity: easy, medium, and advanced. This progressive structure helped us build proficiency in SQL while extracting meaningful insights.

#### **Easy Queries**  
- **Retrieve Track Names with More Than 1 Billion Streams:**
  ```sql
  SELECT track FROM spotify WHERE streams > 1000000000;
  ```
- **List Albums with Their Respective Artists:**
  ```sql
  SELECT album, artist FROM spotify;
  ```
- **Get Total Number of Comments for Tracks with Licensed = TRUE:**
  ```sql
  SELECT track, SUM(comments) FROM spotify WHERE licensed = TRUE GROUP BY track;
  ```
- **Find Tracks Belonging to Album Type "Single":**
  ```sql
  SELECT track FROM spotify WHERE album_type = 'single';
  ```
- **Count Total Tracks by Each Artist:**
  ```sql
  SELECT artist, COUNT(track) FROM spotify GROUP BY artist;
  ```

#### **Medium Queries**  
- **Calculate the Average Danceability for Each Album:**
  ```sql
 	SELECT album,avg(danceability) as avg_danceability FROM spotify 
 	GROUP BY 1 
 	ORDER BY 2 DESC;```
- **Calculate Total Views for Tracks in Each Album:**
  ```sql
  SELECT album,track,sum(views) as total_views
  FROM spotify
  GROUP BY 1,2
  ORDER BY 3 DESC;
  ```
- **Retrieve Tracks Streamed More on Spotify Than on YouTube:**
  ```sql
  SELECT * FROM
  (SELECT track,
		COALESCE(SUM(CASE WHEN most_played_on='Youtube'THEN stream END),0) as streamed_on_youtube,
		COALESCE(SUM(CASE WHEN most_played_on='Spotify'THEN stream END),0) as streamed_on_spotify
  FROM spotify
  GROUP BY 1) as t1
  WHERE streamed_on_spotify> streamed_on_youtube AND streamed_on_youtube <> 0;
  ```

#### **Advanced Queries**  
- **Top 3 Most-Viewed Tracks for Each Artist**
  ```sql
  SELECT artist, track, views, ROW_NUMBER() OVER(PARTITION BY artist ORDER BY views DESC) AS rank
  FROM spotify
  WHERE rank <= 3;
  ```
- **Find Tracks Where Liveness Score is Above the Average:**
  ```sql
  SELECT track FROM spotify WHERE liveness > (SELECT AVG(liveness) FROM spotify_data);
  ```
- **Calculate the Difference Between the Highest and Lowest Energy for Each Album Using WITH Clause:**
  ```sql
  WITH energy_range AS (
    SELECT album, MAX(energy) AS max_energy, MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
  )
  SELECT album, (max_energy - min_energy) AS energy_difference FROM energy_range;
  ```

---

## **3. Query Optimization**  

In the advanced stage of the project, we focused on improving query performance by applying optimization strategy like:

### **Indexing**  
- **Add Index on Frequently Queried Columns:**  
  Indexing can significantly speed up queries that filter or sort by specific columns. For instance, indexing the `artist` and `album` columns could optimize queries related to grouping and aggregation.
  
  ```sql
  CREATE INDEX idx_artist_album ON spotify_data (artist, album);
  ```
Query result before indexing : ![Before Indexing](https://github.com/PranjaliD11/Spotify-Sql-Analysis/blob/main/BeforeQueryOptimization.png)

After query optimization: ![After Indexing](https://github.com/PranjaliD11/Spotify-Sql-Analysis/blob/main/AfterQueryOptimization.png)
Visualization of how indexing works: ![Index](https://github.com/PranjaliD11/Spotify-Sql-Analysis/blob/main/ExplainationOfIndex.png)

---
## **Conclusion**  

This project demonstrates how SQL can be used effectively to analyze Spotify’s music data, from basic queries to complex performance optimizations. By progressing through these queries, we’ve gained insights into track popularity, artist performance, and album trends. Future enhancements could include implementing real-time data ingestion, machine learning for recommendation systems, and interactive data visualization.

---
