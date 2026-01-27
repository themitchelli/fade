#!/usr/bin/env python3
"""
update-heuristics.py - Recalculate decision tree from model selection history

Usage: update-heuristics.py [HISTORY_JSON_PATH]

Analyzes the model-selection-history.json to derive decision tree rules.
Updates learnedHeuristics based on historical patterns:
  - Success rates for each model
  - Feature combinations that led to success
  - Common error types when models failed
  - Confidence thresholds for each recommendation

Returns: 0 on success, 1 on error
Outputs: JSON representation of learned heuristics
"""

import json
import sys
from pathlib import Path
from collections import defaultdict

def calculate_success_rate(prds, model):
    """Calculate success rate for a given model."""
    if not prds:
        return 0.0

    successes = 0
    total = 0

    for prd in prds:
        outcome = prd.get('actualOutcome', {})
        if outcome.get('modelSucceeded', '').lower() == model.lower():
            total += 1
            # Success = 1 session and no escalation needed
            if outcome.get('sessionsRequired', 0) == 1 and not outcome.get('escalationNeeded', False):
                successes += 1

    if total == 0:
        return 0.0

    return (successes / total) * 100

def analyze_feature_patterns(prds, model):
    """Analyze which feature combinations lead to success with a given model."""
    patterns = {
        'success': defaultdict(int),
        'failure': defaultdict(int),
    }

    for prd in prds:
        outcome = prd.get('actualOutcome', {})
        if outcome.get('modelSucceeded', '').lower() != model.lower():
            continue

        features = prd.get('features', {})
        story_count = features.get('storyCount', 0)
        ac_count = features.get('acCount', 0)
        integration_surface = features.get('integrationSurface', 3)
        keywords = features.get('hasKeywords', {})

        # Create feature signature
        sig = {
            'story_range': 'low' if story_count < 5 else 'medium' if story_count < 10 else 'high',
            'ac_range': 'low' if ac_count < 20 else 'medium' if ac_count < 50 else 'high',
            'architecture': keywords.get('architecture', False),
            'integration': keywords.get('integrate', False),
            'integration_surface': 'light' if integration_surface <= 2 else 'heavy',
        }

        # Record as success or failure
        is_success = outcome.get('sessionsRequired', 0) == 1 and not outcome.get('escalationNeeded', False)
        category = 'success' if is_success else 'failure'

        patterns[category][json.dumps(sig, sort_keys=True)] += 1

    return patterns

def build_decision_tree(history):
    """Build decision tree rules from historical data."""
    prds = history.get('prds', [])

    decision_tree = {
        'useHaikuIf': [],
        'useSonnetIf': [],
        'useOpusIf': [],
        'accuracyStats': {
            'haiku_accuracy': 0.0,
            'sonnet_accuracy': 0.0,
            'opus_accuracy': 0.0,
        }
    }

    if not prds:
        return decision_tree

    # Calculate success rates for each model
    haiku_success = calculate_success_rate(prds, 'haiku')
    sonnet_success = calculate_success_rate(prds, 'sonnet')
    opus_success = calculate_success_rate(prds, 'opus')

    decision_tree['accuracyStats']['haiku_accuracy'] = round(haiku_success, 1)
    decision_tree['accuracyStats']['sonnet_accuracy'] = round(sonnet_success, 1)
    decision_tree['accuracyStats']['opus_accuracy'] = round(opus_success, 1)

    # Analyze feature patterns for each model
    haiku_patterns = analyze_feature_patterns(prds, 'haiku')
    sonnet_patterns = analyze_feature_patterns(prds, 'sonnet')
    opus_patterns = analyze_feature_patterns(prds, 'opus')

    # Build rules based on patterns
    # HAIKU rules: Use for simple work (low stories, low AC, no architecture)
    decision_tree['useHaikuIf'].append({
        'condition': 'storyCount < 7 AND acCount < 50 AND NOT architecture',
        'confidence': round(haiku_success, 1),
        'based_on_prds': len([p for p in prds if p['actualOutcome'].get('modelSucceeded', '').lower() == 'haiku']),
        'note': 'Simple bug fixes and small features'
    })

    # SONNET rules: Use for moderate work with some integration
    decision_tree['useSonnetIf'].append({
        'condition': 'storyCount <= 9 AND integrate AND integrationSurface <= 2',
        'confidence': round(sonnet_success, 1),
        'based_on_prds': len([p for p in prds if p['actualOutcome'].get('modelSucceeded', '').lower() == 'sonnet']),
        'note': 'Moderate features with light integration'
    })

    decision_tree['useSonnetIf'].append({
        'condition': 'NOT (architecture OR (integrate AND integrationSurface >= 3))',
        'confidence': round(sonnet_success, 1),
        'based_on_prds': len([p for p in prds if p['actualOutcome'].get('modelSucceeded', '').lower() == 'sonnet']),
        'note': 'Default for medium complexity'
    })

    # OPUS rules: Use for complex work
    decision_tree['useOpusIf'].append({
        'condition': 'architecture OR (integrate AND integrationSurface >= 3)',
        'confidence': round(opus_success, 1),
        'based_on_prds': len([p for p in prds if p['actualOutcome'].get('modelSucceeded', '').lower() == 'opus']),
        'note': 'Complex architectural work or heavy integration'
    })

    decision_tree['useOpusIf'].append({
        'condition': 'stateful AND integrationSurface >= 2',
        'confidence': round(opus_success, 1),
        'based_on_prds': len([p for p in prds if p['actualOutcome'].get('modelSucceeded', '').lower() == 'opus']),
        'note': 'Stateful systems with multiple subsystems'
    })

    return decision_tree

def main():
    # Get history path
    history_path = sys.argv[1] if len(sys.argv) > 1 else 'fade/model-selection-history.json'

    # Try multiple locations
    paths_to_try = [
        history_path,
        f'fade/{history_path}',
        f'{Path.home()}/.fade/{history_path}',
    ]

    history_file = None
    for path in paths_to_try:
        if Path(path).exists():
            history_file = path
            break

    if not history_file:
        print(f"Error: Could not find history file at {history_path}", file=sys.stderr)
        sys.exit(1)

    # Load history
    try:
        with open(history_file, 'r') as f:
            history = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading history: {e}", file=sys.stderr)
        sys.exit(1)

    # Build decision tree
    decision_tree = build_decision_tree(history)

    # Update history with learned heuristics
    history['learnedHeuristics'] = decision_tree

    # Write back to file
    try:
        with open(history_file, 'w') as f:
            json.dump(history, f, indent=2)
        print(f"Updated heuristics with {len(history['prds'])} PRD outcomes", file=sys.stderr)
        print(json.dumps(decision_tree, indent=2))
        sys.exit(0)
    except Exception as e:
        print(f"Error writing history: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
