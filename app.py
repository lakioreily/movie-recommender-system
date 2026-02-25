from flask import Flask, render_template, request, jsonify
from recommender import load_data, train_content_model, recommend_for_user, get_popular_movies
from db_connection import get_db_connection
import pandas as pd

app = Flask(__name__)

# --- 1. UČITAVANJE PODATAKA (SAMO JEDNOM) ---
print("Učitavam podatke i treniram model...")
df_movies, df_ratings = load_data()
cosine_sim = train_content_model(df_movies)
print("Sistem spreman!")

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/recommend', methods=['POST'])
def recommend():
    data = request.get_json()
    username = data.get('username')
    
    if not username:
        return jsonify({'error': 'Molimo unesite korisničko ime.'})

    # --- 2. DOHVATANJE ISTORIJE KORISNIKA ---
    # Moramo naći šta je korisnik već gledao da bismo to prikazali "ispod haube"
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT user_id FROM users WHERE username = %s", (username,))
    user = cursor.fetchone()
    conn.close()

    history = []
    
    if user:
        user_id = user['user_id']
        # Uzimamo filmove koje je ocenio sa 4 ili 5
        user_likes = df_ratings[(df_ratings['user_id'] == user_id) & (df_ratings['rating'] > 3)]
        
        if not user_likes.empty:
            # Nalazimo naslove tih filmova
            liked_titles = df_movies[df_movies['movie_id'].isin(user_likes['movie_id'])]['title'].tolist()
            history = liked_titles
    
    # --- 3. GENERISANJE PREPORUKE ---
    try:
        recommendations = recommend_for_user(username, df_movies, df_ratings, cosine_sim)
        
        # Slučaj: Cold Start ili Greška (string)
        if isinstance(recommendations, list) and len(recommendations) > 0 and "Nema novih" in recommendations[0]:
             return jsonify({
                 'status': 'info', 
                 'message': recommendations[0], 
                 'history': history,
                 'movies': []
             })
        
        # Slučaj: Uspeh (lista)
        if isinstance(recommendations, list):
            return jsonify({
                'status': 'success', 
                'history': history, 
                'movies': recommendations
            })
        
        # Slučaj: Neki drugi info (npr. greška u imenu)
        else:
            return jsonify({'status': 'info', 'message': str(recommendations), 'history': []})
            
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)