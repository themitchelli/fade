#!/usr/bin/env python3
"""
extract-features.py - Extract quantifiable features from PRD JSON

Usage: extract-features.py PRD_JSON_PATH

Outputs JSON structure with:
  - storyCount: number of user stories
  - acCount: total acceptance criteria
  - type: PRD type (feature/bug/chore/spike/docs)
  - integrationSurface: 1-2 (light), 3-5 (moderate), 6+ (heavy)
  - hasKeywords: {architecture, integrate, migrate, ui, stateful}
"""

import json
import sys
import re

def extract_features(prd_json_path):
    """Extract features from PRD JSON file."""

    try:
        with open(prd_json_path, 'r') as f:
            prd = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error reading PRD: {e}", file=sys.stderr)
        sys.exit(1)

    # Count stories
    story_count = len(prd.get('userStories', []))

    # Count acceptance criteria
    ac_count = 0
    for story in prd.get('userStories', []):
        ac_list = story.get('acceptanceCriteria', [])
        if isinstance(ac_list, list):
            ac_count += len(ac_list)

    # Get PRD type
    prd_type = prd.get('type', 'feature')

    # Extract all text from PRD for keyword analysis
    prd_text = json.dumps(prd).lower()

    # Define keyword patterns
    keywords = {
        'architecture': r'architecture|bus|protocol|dag|pipeline|distributed|sync|lock|race|multi-threaded',
        'integrate': r'integrate|connect|bridge|handoff|api|endpoint|interface|import|export',
        'migrate': r'migrate|refactor|rewrite|transform|convert|upgrade',
        'ui': r'webview|panel|ui|visualization|display|results|render|browser',
        'stateful': r'state|cache|persist|memory|buffer|synchron|lock|atomic'
    }

    # Check for keywords
    has_keywords = {}
    for keyword, pattern in keywords.items():
        has_keywords[keyword] = bool(re.search(pattern, prd_text))

    # Estimate integration surface by counting component mentions
    # Look for common system components mentioned in PRD
    components = set()
    component_patterns = {
        'parser': r'\bparser\b',
        'engine': r'\bengine\b',
        'storage': r'\bstorage|database|db\b',
        'api': r'\bapi\b',
        'cache': r'\bcache\b',
        'queue': r'\bqueue|message\b',
        'auth': r'\bauth|login|session\b',
        'ui': r'\bui|frontend|client\b',
        'server': r'\bserver|backend\b',
        'config': r'\bconfig|settings\b'
    }

    for component, pattern in component_patterns.items():
        if re.search(pattern, prd_text):
            components.add(component)

    # Map component count to integration surface
    component_count = len(components)
    if component_count <= 2:
        integration_surface = 1  # Light: 1-2 subsystems
    elif component_count <= 5:
        integration_surface = 3  # Moderate: 3-5 subsystems (use mid-range value)
    else:
        integration_surface = 6  # Heavy: 6+ subsystems (use mid-range value)

    # Build output
    features = {
        'storyCount': story_count,
        'acCount': ac_count,
        'type': prd_type,
        'integrationSurface': integration_surface,
        'hasKeywords': has_keywords
    }

    # Validate all numeric fields > 0
    if features['storyCount'] <= 0:
        features['storyCount'] = 1  # At least 1 story
    if features['acCount'] < 0:
        features['acCount'] = 0  # Can be 0 for some PRDs
    if features['integrationSurface'] < 1:
        features['integrationSurface'] = 1

    return features

def main():
    if len(sys.argv) < 2:
        print("Usage: extract-features.py PRD_JSON_PATH", file=sys.stderr)
        sys.exit(1)

    prd_path = sys.argv[1]
    features = extract_features(prd_path)

    # Output as JSON
    print(json.dumps(features, indent=2))
    sys.exit(0)

if __name__ == '__main__':
    main()
