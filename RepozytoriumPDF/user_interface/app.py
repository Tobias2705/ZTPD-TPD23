"""
    Wyszukiwanie odbywa się poprzez wykorzystanie postgresowych funkcjonalności.
    Plik tekstowy jest przechowywany w bazie jako kolumna tsvector. Zawiera ona tekst podzielony na tokeny.
    Przeszukiwanie tekstu zostało oparte o indeks oraz odbywa się przy wykorzystaniu tsquery, które na
    podstawie tekstu tworzy zapytanie tokenowe pozwalające przeszukać kolumne typu tsvector (operator @@).

    Przy tworzeniu zapytań i insertowania tekstu do bazy wykorzystano stworzony specjalnie dla języka polskiego
    słownik t_search.
"""
from flask import Flask, render_template, request

import fitz
import psycopg2

app = Flask(__name__)
available_languages = ['pl', 'en']
selected_language = 'pl'


def connect_to_database():
    try:
        connection = psycopg2.connect(
            user="postgres",
            password="mysecretpassword",
            host="localhost",
            port="5432",
            database="mydb"
        )
        return connection
    except psycopg2.Error as e:
        print(f"Błąd połączenia z bazą danych: {e}")
        return None


@app.route('/')
def index():
    return render_template('index.html', available_languages=available_languages, selected_language=selected_language)


@app.route('/set_language/<language>')
def set_language(language):
    global selected_language
    selected_language = language
    return render_template('index.html', available_languages=available_languages, selected_language=selected_language)


@app.route('/search', methods=['POST'])
def search():
    search_query = request.form.get('search_query', '')

    if not search_query:
        return render_template('index.html', error="Wprowadź zapytanie do wyszukiwarki.")

    connection = connect_to_database()
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT file_name FROM pdf_documents
                    WHERE content_text @@ plainto_tsquery('public.polish', %s);
                """, (search_query,))

                results = cursor.fetchall()
        finally:
            connection.close()

        return render_template('index.html', search_results=results, query=search_query)


@app.route('/view_pdf/<file_name>')
def view_pdf(file_name):
    pdf_path = f'C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/pdf_files/{file_name}'
    pdf_document = fitz.open(pdf_path)
    pdf_text = " ".join(page.get_text() for page in pdf_document.pages())
    pdf_document.close()

    pdf_lines = pdf_text.split('\n')
    title = pdf_lines[0]
    subtitle = pdf_lines[1]
    pages = pdf_lines[2:]

    return render_template('view_pdf.html', title=title, subtitle=subtitle, pages=pages)


if __name__ == '__main__':
    app.run(debug=True)
