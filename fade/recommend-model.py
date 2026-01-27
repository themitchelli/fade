#!/usr/bin/env python3
"""
recommend-model.py - Recommend model (Haiku/Sonnet/Opus) for a PRD

Usage: recommend-model.py PRD_ID [PRD_JSON_PATH] [HISTORY_PATH]

Loads PRD JSON and model selection history, extracts features,
finds similar PRDs, applies decision tree logic, and recommends
the best model with confidence percentage.

Output format:
  Recommend: {MODEL}
  Confidence: XX%
  Reasoning: Based on similar PRDs...
  Citation: Similar to PRD-ID (features, success record)
"""

import json
import sys
import os
from pathlib import Path

def load_history(history_path):
    """Load model selection history."""
    try:
        with open(history_path, 'r') as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading history: {e}", file=sys.stderr)
        return {"prds": [], "learnedHeuristics": {}}

def extract_features_from_prd(prd_json_path):
    """Extract features from PRD JSON."""
    try:
        with open(prd_json_path, 'r') as f:
            prd = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error reading PRD: {e}", file=sys.stderr)
        return None

    import re

    story_count = len(prd.get('userStories', []))
    ac_count = 0
    for story in prd.get('userStories', []):
        ac_list = story.get('acceptanceCriteria', [])
        if isinstance(ac_list, list):
            ac_count += len(ac_list)

    prd_type = prd.get('type', 'feature')
    prd_text = json.dumps(prd).lower()

    keywords = {
        'architecture': r'architecture|bus|protocol|dag|pipeline|distributed|sync|lock|race|multi-threaded',
        'integrate': r'integrate|connect|bridge|handoff|api|endpoint|interface|import|export',
        'migrate': r'migrate|refactor|rewrite|transform|convert|upgrade',
        'ui': r'webview|panel|ui|visualization|display|results|render|browser',
        'stateful': r'state|cache|persist|memory|buffer|synchron|lock|atomic'
    }

    has_keywords = {}
    for keyword, pattern in keywords.items():
        has_keywords[keyword] = bool(re.search(pattern, prd_text))

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

    component_count = len(components)
    if component_count <= 2:
        integration_surface = 1
    elif component_count <= 5:
        integration_surface = 3
    else:
        integration_surface = 6

    features = {
        'storyCount': max(story_count, 1),
        'acCount': ac_count,
        'type': prd_type,
        'integrationSurface': integration_surface,
        'hasKeywords': has_keywords
    }

    return features

def find_similar_prds(current_features, history_prds, limit=3):
    """Find similar PRDs from history based on feature similarity."""
    if not history_prds:
        return []

    similar = []
    for prd_record in history_prds:
        features = prd_record.get('features', {})

        # Score similarity: story count ±20%, keywords match, integration surface ±1 level
        story_diff = abs(features.get('storyCount', 0) - current_features['storyCount'])
        story_tolerance = max(1, current_features['storyCount'] * 0.2)

        # Story count similarity (0-2 points)
        story_score = 2 if story_diff <= story_tolerance else 0

        # Keyword similarity (0-3 points for matching keywords)
        keyword_score = 0
        current_keywords = set(k for k, v in current_features['hasKeywords'].items() if v)
        prd_keywords = set(k for k, v in features.get('hasKeywords', {}).items() if v)
        if current_keywords and prd_keywords:
            keyword_score = 3 * len(current_keywords & prd_keywords) / max(1, len(current_keywords | prd_keywords))
        else:
            keyword_score = 0

        # Integration surface similarity (0-2 points)
        surface_diff = abs(features.get('integrationSurface', 0) - current_features['integrationSurface'])
        surface_score = 2 if surface_diff <= 1 else 0

        total_score = story_score + keyword_score + surface_score
        if total_score > 0:
            similar.append({
                'prd_id': prd_record.get('id'),
                'score': total_score,
                'features': features,
                'outcome': prd_record.get('actualOutcome', {})
            })

    # Sort by score descending, take top matches
    similar.sort(key=lambda x: x['score'], reverse=True)
    return similar[:limit]

def apply_decision_tree(features, similar_prds, history_heuristics):
    """Apply decision tree logic to recommend model."""

    story_count = features['storyCount']
    ac_count = features['acCount']
    integration_surface = features['integrationSurface']
    has_keywords = features['hasKeywords']

    # Decision tree rules
    if story_count < 7 and ac_count < 50 and not has_keywords.get('architecture', False):
        if story_count <= 3 and ac_count < 20:
            recommendation = 'HAIKU'
            confidence = 80
            reasoning = f"Simple PRD: {story_count} stories, {ac_count} ACs, no architecture keywords"
        else:
            recommendation = 'SONNET'
            confidence = 75
            reasoning = f"Moderate PRD: {story_count} stories, {ac_count} ACs"
    elif story_count <= 9 and has_keywords.get('integrate', False) and integration_surface <= 2:
        recommendation = 'SONNET'
        confidence = 85
        reasoning = f"Integration feature: moderate scope, integration surface {integration_surface}"
    elif has_keywords.get('architecture', False) or (has_keywords.get('integrate', False) and integration_surface >= 3):
        recommendation = 'OPUS'
        confidence = 90
        reasoning = f"Complex feature: architecture=True, integration surface {integration_surface}"
    elif has_keywords.get('stateful', False) and integration_surface >= 2:
        recommendation = 'OPUS'
        confidence = 85
        reasoning = f"Stateful system: complex state management, integration surface {integration_surface}"
    else:
        recommendation = 'SONNET'
        confidence = 70
        reasoning = "Default recommendation for moderate-complexity work"

    # Adjust confidence based on similar PRDs
    if similar_prds:
        similar = similar_prds[0]
        similar_outcome = similar['outcome']

        # If similar PRD succeeded with current recommendation, boost confidence
        if similar_outcome.get('modelSucceeded') == recommendation:
            confidence = min(95, confidence + 10)
            reasoning += f"; similar PRD {similar['prd_id']} succeeded with {recommendation}"

    return recommendation, confidence, reasoning, similar_prds

def main():
    if len(sys.argv) < 2:
        print("Usage: recommend-model.py PRD_ID [PRD_JSON_PATH] [HISTORY_PATH]", file=sys.stderr)
        sys.exit(1)

    prd_id = sys.argv[1]

    # Determine paths
    if len(sys.argv) >= 3:
        prd_json_path = sys.argv[2]
    else:
        # Try common locations
        prd_json_path = None
        for path_candidate in [
            f'fade/prds/{prd_id}.json',
            f'fade/prds/{prd_id}-*.json',
            f'prds/{prd_id}.json',
            f'prds/{prd_id}-*.json',
        ]:
            if '*' not in path_candidate:
                if os.path.exists(path_candidate):
                    prd_json_path = path_candidate
                    break
            else:
                from glob import glob
                matches = glob(path_candidate)
                if matches:
                    prd_json_path = matches[0]
                    break

        if not prd_json_path:
            print(f"Error: Could not find PRD JSON for {prd_id}", file=sys.stderr)
            sys.exit(1)

    if len(sys.argv) >= 4:
        history_path = sys.argv[3]
    else:
        history_path = 'fade/model-selection-history.json'

    # Extract features from current PRD
    features = extract_features_from_prd(prd_json_path)
    if not features:
        sys.exit(1)

    # Load history
    history = load_history(history_path)
    history_prds = history.get('prds', [])

    # Find similar PRDs and apply decision tree
    similar_prds = find_similar_prds(features, history_prds)
    heuristics = history.get('learnedHeuristics', {})
    recommendation, confidence, reasoning, similar_list = apply_decision_tree(features, similar_prds, heuristics)

    # Output recommendation
    print(f"Recommend: {recommendation}")
    print(f"Confidence: {confidence}%")
    print(f"Reasoning: {reasoning}")

    if similar_list:
        similar = similar_list[0]
        similar_features = similar['features']
        similar_outcome = similar['outcome']
        print(f"Based on: {similar['prd_id']} ({similar_features.get('storyCount')} stories, " +
              f"integration_surface={similar_features.get('integrationSurface')}) " +
              f"succeeded with {similar_outcome.get('modelSucceeded')} in {similar_outcome.get('sessionsRequired')} session(s)")

    sys.exit(0)

if __name__ == '__main__':
    main()
