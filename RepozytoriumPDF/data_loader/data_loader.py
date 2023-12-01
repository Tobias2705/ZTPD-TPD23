import os
import fitz
import psycopg2


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


def clear_table(connection):
    try:
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM pdf_documents;")
        connection.commit()
        print("Wyczyszczono tabelę pdf_documents.")
    except psycopg2.Error as e:
        print(f"Błąd podczas czyszczenia tabeli: {e}")


def insert_document(connection, file_name: str, file_path: str):
    try:
        with connection.cursor() as cursor:
            pdf_document = fitz.open(file_path)
            pdf_text = " ".join(page.get_text() for page in pdf_document.pages())
            pdf_document.close()

            pdf_lines = pdf_text.split('\n')
            title = pdf_lines[0]
            subtitle = pdf_lines[1]

            cursor.execute("""
                INSERT INTO pdf_documents (file_name, file_path, title, subtitle, content_text)
                VALUES (%s, %s, %s, %s, to_tsvector('public.polish', %s));
            """, (file_name, file_path, title, subtitle, pdf_text))

        connection.commit()
        print(f"Dodano dokument do bazy: {file_name}")
    except psycopg2.Error as e:
        print(f"Błąd podczas wstawiania dokumentu do bazy: {e}")


def load_documents_from_folder(folder_path: str):
    connection = connect_to_database()
    if connection:
        try:
            clear_table(connection)

            for file_name in os.listdir(folder_path):
                if file_name.lower().endswith(".pdf"):
                    file_path = os.path.join(folder_path, file_name)
                    insert_document(connection, file_name, file_path)
        finally:
            connection.close()


if __name__ == "__main__":
    pdf_folder_path = "C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/pdf_files"
    load_documents_from_folder(pdf_folder_path)
