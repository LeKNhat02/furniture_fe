#!/usr/bin/env python3
"""
Script hỗ trợ migration từ SQLite sang FastAPI
Tự động fix các lỗi phổ biến trong codebase
"""

import os
import re
from pathlib import Path

# Màu sắc cho terminal
class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    END = '\033[0m'

def find_dart_files():
    """Tìm tất cả files .dart trong lib/"""
    lib_path = Path('lib')
    return list(lib_path.rglob('*.dart'))

def fix_database_handler_imports(content):
    """Xóa imports DatabaseHandler và thay bằng Provider"""
    pattern = r"import\s+['\"]\.\.\/services\/DatabaseHandler\.dart['\"];"
    if re.search(pattern, content):
        print(f"  {Colors.YELLOW}→ Removing DatabaseHandler import{Colors.END}")
        content = re.sub(pattern, "// DatabaseHandler removed - use Provider instead", content)
    return content

def fix_api_service_singleton(content):
    """Fix ApiService.instance thành ApiService()"""
    pattern = r"ApiService\.instance"
    if re.search(pattern, content):
        print(f"  {Colors.YELLOW}→ Fixing ApiService.instance{Colors.END}")
        content = re.sub(pattern, "ApiService()", content)
    return content

def fix_provider_methods(content):
    """Update old provider method names"""
    replacements = {
        r'\.getCategory\(\)': '.loadCategories()',
        r'\.getProduct\(\)': '.loadProducts()',
        r'\.getNewArchiveProduct\(\)': '.loadNewProducts()',
        r'\.getTopSeller\(\)': '.loadTopSellers()',
        r'\.getReview\(\)': '.loadReviews()',
    }
    
    for old, new in replacements.items():
        if re.search(old, content):
            print(f"  {Colors.YELLOW}→ Replacing {old} with {new}{Colors.END}")
            content = re.sub(old, new, content)
    
    return content

def fix_database_handler_calls(content):
    """Comment out DatabaseHandler method calls"""
    patterns = [
        r'handler\.getListCart\(\)',
        r'handler\.getListFavorite\(\)',
        r'handler\.getListUser\(\)',
        r'handler\.getListHistorySearch\(\)',
        r'handler\.insertCart\(',
        r'handler\.deleteFavorite\(',
    ]
    
    for pattern in patterns:
        if re.search(pattern, content):
            print(f"  {Colors.RED}→ Found DatabaseHandler call: {pattern}{Colors.END}")
            print(f"    {Colors.BLUE}TODO: Replace with Provider pattern{Colors.END}")
            # Không tự động fix vì cần refactor logic
    
    return content

def process_file(file_path):
    """Process một file dart"""
    print(f"\n{Colors.GREEN}Processing: {file_path}{Colors.END}")
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Apply fixes
        content = fix_database_handler_imports(content)
        content = fix_api_service_singleton(content)
        content = fix_provider_methods(content)
        content = fix_database_handler_calls(content)
        
        # Write back if changed
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"  {Colors.GREEN}✓ Updated{Colors.END}")
        else:
            print(f"  {Colors.BLUE}○ No changes needed{Colors.END}")
        
        return True
    except Exception as e:
        print(f"  {Colors.RED}✗ Error: {e}{Colors.END}")
        return False

def main():
    print(f"{Colors.BLUE}{'='*60}{Colors.END}")
    print(f"{Colors.BLUE}SQLite → FastAPI Migration Helper{Colors.END}")
    print(f"{Colors.BLUE}{'='*60}{Colors.END}")
    
    files = find_dart_files()
    print(f"\nFound {len(files)} Dart files")
    
    success_count = 0
    for file_path in files:
        if process_file(file_path):
            success_count += 1
    
    print(f"\n{Colors.BLUE}{'='*60}{Colors.END}")
    print(f"{Colors.GREEN}Processed: {success_count}/{len(files)} files{Colors.END}")
    print(f"{Colors.BLUE}{'='*60}{Colors.END}")
    
    print(f"\n{Colors.YELLOW}Next steps:{Colors.END}")
    print("1. Review changes: git diff")
    print("2. Run: flutter pub get")
    print("3. Run: flutter analyze")
    print("4. Fix remaining errors manually")
    print("5. Test with backend running")

if __name__ == '__main__':
    main()
