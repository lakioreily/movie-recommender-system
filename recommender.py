import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
from db_connection import get_db_connection

# --- 1. UČITAVANJE PODATAKA ---
def load_data():
    conn = get_db_connection()
    if conn is None: return None, None
    
    query_movies = "SELECT * FROM movies"
    df_movies = pd.read_sql(query_movies, conn)
    
    query_ratings = "SELECT * FROM ratings"
    df_ratings = pd.read_sql(query_ratings, conn)
    
    conn.close()
    return df_movies, df_ratings

# --- 2. PRIPREMA PODATAKA (GENRE BOOSTING) ---
def create_soup(x):
    # Žanr je 2x važniji od opisa
    return (x['genres'] + ' ') * 2 + ' ' + x['description']

def train_content_model(df_movies):
    df_movies['genres'] = df_movies['genres'].fillna('')
    df_movies['description'] = df_movies['description'].fillna('')
    df_movies['soup'] = df_movies.apply(create_soup, axis=1)
    
    tfidf = TfidfVectorizer(stop_words='english')
    tfidf_matrix = tfidf.fit_transform(df_movies['soup'])
    
    cosine_sim = linear_kernel(tfidf_matrix, tfidf_matrix)
    return cosine_sim

# --- 3. POPULARITY MODEL (ZA COLD START) ---
def get_popular_movies(df_movies, df_ratings, top_n=3):
    """
    Ova funkcija se poziva SAMO ako korisnik nema istoriju.
    Računa prosečnu ocenu za svaki film i vraća najbolje.
    """
    # Grupišemo ocene po ID-ju filma i tražimo prosek (mean)
    avg_ratings = df_ratings.groupby('movie_id')['rating'].mean()
    
    # Sortiramo od najveće ka najmanjoj
    sorted_ratings = avg_ratings.sort_values(ascending=False)
    
    # Uzimamo top N ID-jeva
    top_ids = sorted_ratings.head(top_n).index
    
    # Vraćamo naslove tih filmova
    popular_titles = df_movies[df_movies['movie_id'].isin(top_ids)]['title'].tolist()
    return popular_titles

# --- 4. CONTENT-BASED MODEL (ZA STARE KORISNIKE) ---
def get_similar_movies(movie_title, cosine_sim, df_movies, top_n=5):
    if movie_title not in df_movies['title'].values: return []
    
    idx = df_movies.index[df_movies['title'] == movie_title][0]
    source_genres = set(df_movies.iloc[idx]['genres'].lower().split())
    
    sim_scores = list(enumerate(cosine_sim[idx]))
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    
    final_recommendations = []
    
    for i in sim_scores[1:]:
        movie_index = i[0]
        score = i[1]
        
        candidate_title = df_movies.iloc[movie_index]['title']
        candidate_genres = set(df_movies.iloc[movie_index]['genres'].lower().split())
        
        # RIGOROZNI FILTER (Žanr mora da se poklapa)
        common_genres = source_genres.intersection(candidate_genres)
        
        if not common_genres:
            continue

        if score > 0.1: 
            final_recommendations.append(candidate_title)
        
        if len(final_recommendations) >= 3:
            break
            
    return final_recommendations

# --- 5. GLAVNA LOGIKA PREPORUKE ---
def recommend_for_user(username, df_movies, df_ratings, cosine_sim):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT user_id FROM users WHERE username = %s", (username,))
    user = cursor.fetchone()
    conn.close()
    
    if not user: return f"Korisnik '{username}' ne postoji."
    user_id = user['user_id']
    
    # PROVERA ISTORIJE OCENA
    user_likes = df_ratings[(df_ratings['user_id'] == user_id) & (df_ratings['rating'] > 3)]
    
    # --- REŠENJE ZA COLD START ---
    if user_likes.empty:
        print(f"\n[INFO] Korisnik '{username}' nema ocene (COLD START).")
        print("[INFO] Prelazimo na 'Global Popularity' model (Najpopularniji filmovi)...")
        return get_popular_movies(df_movies, df_ratings)
    
    # --- STANDARDNA PREPORUKA (CONTENT-BASED) ---
    liked_titles = df_movies[df_movies['movie_id'].isin(user_likes['movie_id'])]['title'].values
    print(f"\nAnaliza profila za korisnika: {username}")
    print(f"Korisnik je lajkovao: {', '.join(liked_titles)}")
    
    recommendations = set()
    
    for movie_id in user_likes['movie_id']:
        movie_title = df_movies[df_movies['movie_id'] == movie_id]['title'].values[0]
        similar_movies = get_similar_movies(movie_title, cosine_sim, df_movies)
        
        for rec_movie in similar_movies:
            rec_id = df_movies[df_movies['title'] == rec_movie]['movie_id'].values[0]
            if rec_id not in df_ratings[df_ratings['user_id'] == user_id]['movie_id'].values:
                recommendations.add(rec_movie)

    if not recommendations:
        return ["Nema novih preporuka (Sve slično ste već gledali)."]
        
    return list(recommendations)

# --- POMOĆNA FUNKCIJA ZA PRIKAZ IMENA ---
def get_all_users_string():
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute("SELECT username FROM users")
        users = [row[0] for row in cursor.fetchall()]
        conn.close()
        return ", ".join(users)
    return "Greška pri učitavanju korisnika"

# --- MAIN ---
if __name__ == "__main__":
    df_movies, df_ratings = load_data()
    
    if df_movies is not None:
        cosine_sim = train_content_model(df_movies)
        users_display = get_all_users_string()
        
        while True:
            print("-" * 60)
            user_input = input(f"Unesite ime za preporuku \n(Dostupni: {users_display}) \nili 'q' za izlaz: ")
            
            if user_input.lower() == 'q':
                break
            
            recs = recommend_for_user(user_input, df_movies, df_ratings, cosine_sim)
            
            if isinstance(recs, list):
                print(f"--> PREPORUČUJEMO VAM: {', '.join(recs)}")
            else:
                print(recs)