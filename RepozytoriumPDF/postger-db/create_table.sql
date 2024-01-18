CREATE TABLE pdf_documents (
    document_id SERIAL PRIMARY KEY,
    file_name VARCHAR(255),
    file_path VARCHAR(255),
    title VARCHAR(255),
	subtitle VARCHAR(255),
    content_text TSVECTOR
);

CREATE INDEX idx_content_text ON pdf_documents USING gin(content_text);