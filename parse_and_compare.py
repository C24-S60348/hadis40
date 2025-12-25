#!/usr/bin/env python3
import json
import re
from docx import Document

def extract_hadiths_from_docx(file_path):
    """Extract hadiths from a .docx file and return as a list of dictionaries"""
    doc = Document(file_path)
    full_text = []
    for para in doc.paragraphs:
        if para.text.strip():
            full_text.append(para.text.strip())
    
    # Join all paragraphs
    text = '\n'.join(full_text)
    
    # Split by separator (long dashes)
    hadiths_raw = re.split(r'-{50,}', text)
    
    hadiths = []
    for hadith_text in hadiths_raw:
        if not hadith_text.strip():
            continue
            
        # Extract hadith number and title
        match = re.match(r'Hadis\s+(\d+):\s*(.+)', hadith_text)
        if match:
            number = int(match.group(1))
            title = match.group(2).strip()
            
            # Extract the rest of the content
            content = hadith_text[match.end():].strip()
            
            hadiths.append({
                'number': number,
                'title': title,
                'content': content
            })
    
    return hadiths

# Load current JSON
print("Loading current hadis40.json...")
with open('assets/data/hadis40.json', 'r', encoding='utf-8') as f:
    current_data = json.load(f)

current_hadiths = {h['number']: h for h in current_data['hadiths']}

# Extract from both docx files
print("\nExtracting from Hadis 1 - Hadis 26.docx...")
hadiths_1_26 = extract_hadiths_from_docx('assets/data/Hadis 1 - Hadis 26.docx')

print("Extracting from Hadis 27 - Hadis 42.docx...")
hadiths_27_42 = extract_hadiths_from_docx('assets/data/Hadis 27 - Hadis 42.docx')

all_new_hadiths = hadiths_1_26 + hadiths_27_42
new_hadiths_dict = {h['number']: h for h in all_new_hadiths}

# Compare and create report
print("\n" + "="*80)
print("COMPARISON REPORT")
print("="*80)

changes_summary = {
    'title_changed': [],
    'content_changed': [],
    'new_hadiths': [],
    'missing_hadiths': []
}

for number in range(1, 43):
    current = current_hadiths.get(number)
    new = new_hadiths_dict.get(number)
    
    if not current:
        changes_summary['missing_hadiths'].append(number)
        print(f"\n⚠️  Hadis {number}: MISSING in current JSON")
    elif not new:
        changes_summary['new_hadiths'].append(number)
        print(f"\n⚠️  Hadis {number}: MISSING in new documents")
    else:
        # Compare title
        if current['title'] != new['title']:
            changes_summary['title_changed'].append(number)
            print(f"\n📝 Hadis {number}: TITLE CHANGED")
            print(f"   Old: {current['title']}")
            print(f"   New: {new['title']}")
        
        # Compare content (htmlDescription)
        # Note: We'll compare the text content, not HTML formatting
        current_desc = current.get('htmlDescription', '')
        new_desc = new['content']
        
        # Simple comparison - check if significantly different
        if current_desc != new_desc:
            changes_summary['content_changed'].append(number)
            print(f"\n📄 Hadis {number}: CONTENT CHANGED")
            print(f"   Title: {new['title']}")
            # Show first 200 chars of difference
            if len(current_desc) > 200:
                print(f"   Old (first 200 chars): {current_desc[:200]}...")
            else:
                print(f"   Old: {current_desc}")
            if len(new_desc) > 200:
                print(f"   New (first 200 chars): {new_desc[:200]}...")
            else:
                print(f"   New: {new_desc}")

print("\n" + "="*80)
print("SUMMARY")
print("="*80)
print(f"Total hadiths in current JSON: {len(current_hadiths)}")
print(f"Total hadiths in new documents: {len(new_hadiths_dict)}")
print(f"\nTitle changes: {len(changes_summary['title_changed'])}")
print(f"Content changes: {len(changes_summary['content_changed'])}")
print(f"Missing in current: {len(changes_summary['missing_hadiths'])}")
print(f"Missing in new: {len(changes_summary['new_hadiths'])}")

# Save detailed comparison
with open('comparison_report.txt', 'w', encoding='utf-8') as f:
    f.write("DETAILED COMPARISON REPORT\n")
    f.write("="*80 + "\n\n")
    for number in sorted(set(changes_summary['title_changed'] + changes_summary['content_changed'])):
        current = current_hadiths.get(number)
        new = new_hadiths_dict.get(number)
        if current and new:
            f.write(f"\n{'='*80}\n")
            f.write(f"HADIS {number}: {new['title']}\n")
            f.write(f"{'='*80}\n\n")
            f.write("CURRENT HTML DESCRIPTION:\n")
            f.write("-"*80 + "\n")
            f.write(current.get('htmlDescription', '') + "\n\n")
            f.write("NEW CONTENT FROM DOCX:\n")
            f.write("-"*80 + "\n")
            f.write(new['content'] + "\n\n")

print("\n✅ Detailed comparison saved to: comparison_report.txt")
