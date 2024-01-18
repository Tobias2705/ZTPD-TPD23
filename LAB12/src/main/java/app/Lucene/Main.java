package app.Lucene;

import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException, ParseException {
        // Zad 9
        // StandardAnalyzer analyzer = new StandardAnalyzer();

        // Zad 11
        // EnglishAnalyzer analyzer = new EnglishAnalyzer();
        PolishAnalyzer analyzer = new PolishAnalyzer();

        Directory directory = new ByteBuffersDirectory();
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        IndexWriter w = new IndexWriter(directory, config);

        // Zad 11
        // w.addDocument(buildDoc("Lucene in Action", "9781473671911"));
        // w.addDocument(buildDoc("Lucene for Dummies", "9780735219090"));
        // w.addDocument(buildDoc("Managing Gigabytes", "9781982131739"));
        // w.addDocument(buildDoc("The Art of Computer Science", "9781250301695"));
        // w.addDocument(buildDoc("Dummy and yummy title", "9780525656161"));

        w.addDocument(buildDoc("Lucyna w akcji", "9780062316097"));
        w.addDocument(buildDoc("Akcje rosną i spadają", "9780385545955"));
        w.addDocument(buildDoc("Bo ponieważ", "9781501168007"));
        w.addDocument(buildDoc("Naturalnie urodzeni mordercy", "9780316485616"));
        w.addDocument(buildDoc("Druhna rodzi", "9780593301760"));
        w.addDocument(buildDoc("Urodzić się na nowo", "9780679777489"));
        w.close();

        // Zad 6
        // String querystr = "*:*";

        // Zad 7
        // String querystr = "dummy";
        // String querystr = "and";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12a
        // String querystr = "9780062316097";
        // Query q = new QueryParser("isbn", analyzer).parse(querystr);

        // Zad 12b
        // String querystr = "urodzić";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12c
        // String querystr = "rodzić";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12d
        // String querystr = "ro*";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12e
        // String querystr = "ponieważ";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12f
        // String querystr = "\"Lucyna\" AND \"akcja\"";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12g
        // String querystr = "\"akcja\" NOT \"Lucyna\"";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12h
        // String querystr = "\"naturalnie morderca\"~2";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12i
        // String querystr = "\"naturalnie morderca\"~1";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12j
        // String querystr = "\"naturalnie morderca\"~0";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12k
        // String querystr = "naturalne";
        // Query q = new QueryParser("title", analyzer).parse(querystr);

        // Zad 12l
        String querystr = "\"naturalne\"~";
        Query q = new QueryParser("title", analyzer).parse(querystr);

        int maxHits = 10;
        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);
        TopDocs docs = searcher.search(q, maxHits);
        ScoreDoc[] hits = docs.scoreDocs;

        System.out.println("Found " + hits.length + " matching docs.");
        StoredFields storedFields = searcher.storedFields();
        for(int i=0; i<hits.length; ++i) {
            int docId = hits[i].doc;
            Document d = storedFields.document(docId);
            System.out.println((i + 1) + ". " + d.get("isbn") + "\t" + d.get("title"));
        }
        reader.close();
    }

    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }

}

// Odp
// Zad 9 --> Teraz dla dummy znaleziono dwa tytułu ponieważ uwzględniono odmiany frazy "dummy".
//           W drugi przypadku nie znaleziono wyników ponieważ "and" w języku ang jest traktowane jako stopword
//           i prawdopodobnie zostało pominięte.

// Zad 12
// a) Znaleziono 1 dokument "Lucyna w akcji"
// b) Znaleziono 2 dokumenty "Urordzić się na nowo" i "Naturalnie urodzeni mordercy".
//    Uwzględniono odmiany frazy urodzić.
// c) Nie znaleziono żadnego dokumentu.
// d) Znaleziono 2 dokumenty "Druhna rodzi" i "Akcje rosną i spadają".
// e) Nie znaleziono żadnych dokumentów. Prawdopodobnie jest to stopword.
// f) Znaleziono 1 dokument "Lucyna w akcji"
// g) Znaleziono 1 dokument "Akcje rosną i spadają"
// h) Znaleziono 1 dokument "Naturalnie urodzeni mordercy"
// i) Znaleziono 1 dokument "Naturalnie urodzeni mordercy"
// j) Nie znaleziono żadnego dokumentu.
// k) Znaleziono 1 dokument "Naturalnie urodzeni mordercy"
// l) Znaleziono 1 dokument "Naturalnie urodzeni mordercy"

// Zadanie do samodzielnego wykonania
// Są to pliki cfe, cfs oraz si
// W przypadku nieusunięcia wcześniej indeksów zostały one powielone. Powstały kolejne pliki cfe, cfs oraz si.
// Jak rezultat otrzymuje podwojone wyniki np. dla zapytania i) otrzymaliśmy dwa razy dokument "Naturalnie urodzeni mordercy"