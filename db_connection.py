import mysql.connector
import sys

def get_db_connection():
    """
    Kreira i vraća konekciju ka MySQL bazi podataka.
    """
    try:
        connection = mysql.connector.connect(
            host='localhost',       # Server (XAMPP)
            user='root',            # Default korisnik na XAMPP-u
            password='',            # Default lozinka je prazna
            database='movie_recommender' # Ime baze koju smo napravili
        )
        return connection
    except mysql.connector.Error as err:
        print(f"GRESKA pri povezivanju sa bazom: {err}")
        return None

# Test blok - izvršava se samo ako direktno pokrenemo ovaj fajl
if __name__ == "__main__":
    conn = get_db_connection()
    if conn and conn.is_connected():
        print("USPEH! Python je povezan sa MySQL bazom.")
        print(f"Verzija MySQL servera: {conn.get_server_info()}")
        conn.close()
    else:
        print("Povezivanje nije uspelo.")