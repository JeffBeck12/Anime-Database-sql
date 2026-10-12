import sys
from pathlib import Path
lines=Path(sys.argv[1]).read_text().strip().splitlines()
assert len(lines)==11, f'Expected 11 validation rows, got {len(lines)}'
for line in lines[:5]:
    name,count=line.split('\t'); assert int(count)==0, f'Orphan records: {name}'
for line in lines[5:]:
    name,actual,expected=line.split('\t'); assert actual==expected, f'Count mismatch: {name}'
print('MySQL foreign keys and sample counts validated.')
