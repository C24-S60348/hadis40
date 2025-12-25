#!/usr/bin/env python3
import json
import re
from docx import Document

def extract_hadiths_from_text(text):
    """Extract hadiths from text content"""
    hadiths = []
    
    # Split by long separator lines (dashes)
    parts = re.split(r'-{50,}', text)
    
    for part in parts:
        part = part.strip()
        if not part:
            continue
        
        # Look for "Hadis X: Title" pattern
        match = re.match(r'Hadis\s+(\d+):\s*(.+?)(?:\n|$)', part)
        if match:
            number = int(match.group(1))
            title = match.group(2).strip()
            
            # Get the rest of the content (everything after the title line)
            content_start = match.end()
            content = part[content_start:].strip()
            
            hadiths.append({
                'number': number,
                'title': title,
                'content': content
            })
    
    return hadiths

def extract_text_from_docx(file_path):
    """Extract all text from a .docx file"""
    doc = Document(file_path)
    full_text = []
    for para in doc.paragraphs:
        if para.text.strip():
            full_text.append(para.text.strip())
    return '\n'.join(full_text)

# Load current JSON
print("Loading current hadis40.json...")
with open('assets/data/hadis40.json', 'r', encoding='utf-8') as f:
    current_data = json.load(f)

current_hadiths = {h['number']: h for h in current_data['hadiths']}

# Extract from both docx files
print("\nExtracting from Hadis 1 - Hadis 26.docx...")
text_1_26 = extract_text_from_docx('assets/data/Hadis 1 - Hadis 26.docx')
hadiths_1_26 = extract_hadiths_from_text(text_1_26)

print("Extracting from Hadis 27 - Hadis 42.docx...")
text_27_42 = extract_text_from_docx('assets/data/Hadis 27 - Hadis 42.docx')
hadiths_27_42 = extract_hadiths_from_text(text_27_42)

all_new_hadiths = hadiths_1_26 + hadiths_27_42
new_hadiths_dict = {h['number']: h for h in all_new_hadiths}

print(f"\nFound {len(all_new_hadiths)} hadiths in documents:")
for h in sorted(all_new_hadiths, key=lambda x: x['number']):
    print(f"  - Hadis {h['number']}: {h['title']}")

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
        current_desc = current.get('htmlDescription', '')
        new_desc = new['content']
        
        # Remove HTML tags from current for comparison
        current_text = re.sub(r'<[^>]+>', '', current_desc)
        current_text = current_text.replace('&nbsp;', ' ').replace('<br>', '\n').replace('<br><br>', '\n\n')
        
        # Simple comparison - check if significantly different (more than just formatting)
        if current_text.strip() != new_desc.strip():
            changes_summary['content_changed'].append(number)
            print(f"\n📄 Hadis {number}: CONTENT CHANGED - {new['title']}")

print("\n" + "="*80)
print("SUMMARY")
print("="*80)
print(f"Total hadiths in current JSON: {len(current_hadiths)}")
print(f"Total hadiths in new documents: {len(new_hadiths_dict)}")
print(f"\nTitle changes: {len(changes_summary['title_changed'])}")
print(f"Content changes: {len(changes_summary['content_changed'])}")
print(f"Missing in current: {len(changes_summary['missing_hadiths'])}")
print(f"Missing in new: {len(changes_summary['new_hadiths'])}")

# Save detailed comparison for content changes
print("\nGenerating detailed comparison report...")
with open('comparison_report.txt', 'w', encoding='utf-8') as f:
    f.write("DETAILED COMPARISON REPORT\n")
    f.write("="*80 + "\n\n")
    f.write(f"Total hadiths with changes: {len(changes_summary['content_changed'])}\n\n")
    
    for number in sorted(changes_summary['content_changed']):
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

print("✅ Detailed comparison saved to: comparison_report.txt")
print(f"\n⚠️  IMPORTANT: Please review comparison_report.txt to verify that")
print("   the MEANING of hadiths has not changed, only formatting/wording.")
