#!/usr/bin/env python3
"""
Script to convert suraujumaat.csv to SQLite database
Run this script to generate assets/data/surau_jumaat.db
"""

import csv
import sqlite3
import os
import sys
import re

def convert_csv_to_db():
    # Paths
    csv_path = 'assets/images/suraujumaat.csv'
    db_path = 'assets/data/surau_jumaat.db'
    
    # Create data directory if it doesn't exist
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    # Remove existing database if it exists
    if os.path.exists(db_path):
        os.remove(db_path)
        print(f'Removed existing database: {db_path}')
    
    # Create database and table
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Create table
    cursor.execute('''
        CREATE TABLE surau (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            negeri TEXT NOT NULL,
            surau TEXT NOT NULL,
            alamat TEXT,
            poskod TEXT,
            daerah TEXT,
            telefon TEXT,
            faksimili TEXT
        )
    ''')
    
    # Create indexes
    cursor.execute('CREATE INDEX idx_negeri ON surau(negeri)')
    cursor.execute('CREATE INDEX idx_daerah ON surau(daerah)')
    cursor.execute('CREATE INDEX idx_surau ON surau(surau)')
    
    print(f'Reading CSV from: {csv_path}')
    
    # Read CSV and insert data
    inserted_count = 0
    error_count = 0
    
    try:
        # Try different encodings
        encodings = ['utf-8', 'latin-1', 'iso-8859-1', 'cp1252']
        reader = None
        file_handle = None
        
        for encoding in encodings:
            try:
                file_handle = open(csv_path, 'r', encoding=encoding, errors='replace')
                # Use csv.reader with proper dialect detection
                sample = file_handle.read(8192)
                file_handle.seek(0)
                sniffer = csv.Sniffer()
                try:
                    dialect = sniffer.sniff(sample, delimiters=',')
                except:
                    dialect = csv.excel
                
                reader = csv.DictReader(file_handle, dialect=dialect)
                print(f'Successfully opened CSV with encoding: {encoding}')
                break
            except Exception as e:
                if file_handle:
                    file_handle.close()
                print(f'Failed with encoding {encoding}: {e}')
                continue
        
        if not reader:
            raise Exception('Could not read CSV with any encoding')
        
        for row_num, row in enumerate(reader, start=2):
                try:
                    # Get all keys to debug
                    if row_num == 2:
                        print(f'CSV columns found: {list(row.keys())}')
                    
                    # Clean and get values - handle None values
                    negeri = (row.get('NEGERI') or '').strip()
                    surau = (row.get('SURAU') or '').strip()
                    alamat = (row.get('ALAMAT') or '').strip()
                    poskod = (row.get('POSKOD') or '').strip()
                    daerah = (row.get('DAERAH') or '').strip()
                    telefon = (row.get('NO. TELEFON') or '').strip()
                    faksimili = (row.get('NO. FAKSIMILI') or '').strip()
                    
                    # Skip empty rows (must have at least negeri or surau)
                    if not negeri and not surau:
                        continue
                    
                    # Replace newlines in alamat with space for cleaner display
                    alamat = alamat.replace('\n', ' ').replace('\r', ' ')
                    # Clean up multiple spaces
                    alamat = re.sub(r'\s+', ' ', alamat).strip()
                    
                    cursor.execute('''
                        INSERT INTO surau (negeri, surau, alamat, poskod, daerah, telefon, faksimili)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                    ''', (negeri, surau, alamat, poskod, daerah, telefon, faksimili))
                    
                    inserted_count += 1
                    
                    if inserted_count % 100 == 0:
                        print(f'Inserted {inserted_count} records...')
                        conn.commit()
                    
                except Exception as e:
                    error_count += 1
                    if error_count <= 5:  # Only print first 5 errors
                        print(f'Error at row {row_num}: {e}')
                        print(f'  Row data: {row}')
                    if error_count > 10:
                        print('Too many errors, stopping...')
                        break
                    continue
        
        # Final commit
        conn.commit()
        
        # Verify
        cursor.execute('SELECT COUNT(*) FROM surau')
        total_count = cursor.fetchone()[0]
        
        print(f'\n✅ Conversion completed successfully!')
        print(f'   Total records inserted: {total_count}')
        print(f'   Database saved to: {db_path}')
        print(f'   Errors encountered: {error_count}')
        
    except Exception as e:
        print(f'❌ Error reading CSV: {e}')
        import traceback
        traceback.print_exc()
        conn.rollback()
        sys.exit(1)
    finally:
        if file_handle:
            file_handle.close()
        conn.close()

if __name__ == '__main__':
    convert_csv_to_db()
