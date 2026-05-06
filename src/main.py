from sqlalchemy import create_engine, text
from config import *
import pandas as pd
import os

# Create a database connection
def conection_bd():
    """Establece conexión con la base de datos Sakila"""
    # Construir la URL de conexión completa
    url_db = f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
    # Crear el objeto 'motor' (engine) usando la URL
    engine = create_engine(url_db)
    return engine.connect()

def test_connection():
    """Probar la conexión a la base de datos"""
    connection = conection_bd()
    try:
        with connection:
            print("✅ Conexión exitosa a Sakila.")
            # Probamos con la tabla film que siempre existe
            result = connection.execute(text("SELECT * FROM film;"))
            print(result.fetchone())

    except Exception as e:
        print(f"❌ Error al conectar a la base de datos: {e}")
        

# Función principal para extraer el Dataframe
def get_data_list_from_join():
    """Obtener datos DA"""
    connection = conection_bd()
    # DataFrame1
    with connection:
        join_query_sql = """
        SELECT 
            c.customer_id,
            LOWER(c.first_name) AS first_name,
            LOWER(c.last_name) AS last_name,
            LOWER(c.email) AS email,
            LOWER(ci.city) AS city,
            LOWER(co.country) AS country,
            r.rental_id,
            r.rental_date,
            r.return_date,
            DATEDIFF(r.return_date, r.rental_date) AS rental_duration_days,
            p.payment_id,
            p.amount,
            p.payment_date
        FROM customer c
        JOIN address a ON c.address_id = a.address_id
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        JOIN rental r ON c.customer_id = r.customer_id
        JOIN payment p ON r.rental_id = p.rental_id
        WHERE 
            r.rental_id IS NOT NULL 
            AND p.payment_id IS NOT NULL
            AND p.amount > 0              
            AND r.return_date IS NOT NULL 
            AND r.rental_date < r.return_date; """

        # Ejecutar la consulta y capturar datos
        result = connection.execute(text(join_query_sql))
        rows = result.fetchall()
        columns = result.keys()

        # Create the Pandas DataFrame
        df = pd.DataFrame(rows, columns=columns)

        # --- EXPORTAR A CSV ---
        # Ruta del archivo actual
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))
        # Subir un nivel (carpeta padre del proyecto)
        PARENT_DIR = os.path.dirname(BASE_DIR)
        # Carpeta data en el nivel superior
        DATA_DIR = os.path.join(PARENT_DIR, "data")
        # Crear carpeta si no existe
        os.makedirs(DATA_DIR, exist_ok=True)
        # Exportar
        file_path = os.path.join(DATA_DIR, "DataFrame1.csv")
        df.to_csv(file_path, index=False, encoding='utf-8')

        print(f"✅ DataFrame creado con éxito y guardado en: {file_path}")
        print(f"📈 Total de registros: {len(df)}")

        return df
        
# Bloque de ejecución
if __name__ == "__main__":
    test_connection()           # Validar conexión
    get_data_list_from_join()   # Extraer y guardar