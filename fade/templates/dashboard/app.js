/**
 * FADE Dashboard - Client-side application logic
 * Vanilla JavaScript - no external dependencies
 */

class FadeDashboard {
    constructor() {
        this.refreshInterval = 30000; // 30 seconds
        this.refreshTimer = null;
        this.selectedRepo = null;
        this.currentFilter = 'all';
        this.currentSort = 'name';
        this.reposData = {};

        // Bind methods
        this.init = this.init.bind(this);
        this.fetchStatus = this.fetchStatus.bind(this);
        this.fetchAggregate = this.fetchAggregate.bind(this);
        this.renderRepoCards = this.renderRepoCards.bind(this);
        this.updateAggregateStats = this.updateAggregateStats.bind(this);
        this.openModal = this.openModal.bind(this);
        this.closeModal = this.closeModal.bind(this);
        this.handleRefresh = this.handleRefresh.bind(this);
        this.handleFilter = this.handleFilter.bind(this);
        this.handleSort = this.handleSort.bind(this);
    }

    init() {
        // Set up event listeners
        document.getElementById('refresh-btn').addEventListener('click', this.handleRefresh);
        document.getElementById('modal-close').addEventListener('click', this.closeModal);
        document.getElementById('modal-overlay').addEventListener('click', (e) => {
            if (e.target.id === 'modal-overlay') {
                this.closeModal();
            }
        });

        // Filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', this.handleFilter);
        });

        // Sort select
        document.getElementById('sort-select').addEventListener('change', this.handleSort);

        // Initial load
        this.refresh();

        // Start auto-refresh
        this.startAutoRefresh();
    }

    handleFilter(e) {
        const filter = e.target.dataset.filter;
        this.currentFilter = filter;

        // Update active state
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        e.target.classList.add('active');

        // Re-render with current data
        this.renderRepoCards(this.reposData);
    }

    handleSort(e) {
        this.currentSort = e.target.value;
        // Re-render with current data
        this.renderRepoCards(this.reposData);
    }

    startAutoRefresh() {
        this.refreshTimer = setInterval(() => {
            this.refresh();
        }, this.refreshInterval);
    }

    stopAutoRefresh() {
        if (this.refreshTimer) {
            clearInterval(this.refreshTimer);
            this.refreshTimer = null;
        }
    }

    handleRefresh() {
        this.refresh();
        // Visual feedback
        const btn = document.getElementById('refresh-btn');
        btn.textContent = 'Refreshing...';
        btn.disabled = true;
        setTimeout(() => {
            btn.textContent = 'Refresh Now';
            btn.disabled = false;
        }, 1000);
    }

    async refresh() {
        await Promise.all([
            this.fetchStatus(),
            this.fetchAggregate()
        ]);
    }

    async fetchStatus() {
        try {
            const response = await fetch('/api/status');
            const data = await response.json();

            this.renderRepoCards(data.repos);
            this.updateLastRefresh(data.lastRefresh);
        } catch (error) {
            console.error('Failed to fetch status:', error);
            this.showError('Failed to fetch repository status');
        }
    }

    async fetchAggregate() {
        try {
            const response = await fetch('/api/aggregate');
            const data = await response.json();

            this.updateAggregateStats(data);
        } catch (error) {
            console.error('Failed to fetch aggregate:', error);
        }
    }

    updateAggregateStats(stats) {
        document.getElementById('active-repos').textContent = stats.activeRepos;
        document.getElementById('blocked-repos').textContent = stats.blockedRepos;
        document.getElementById('pending-stories').textContent = stats.totalPending;
        document.getElementById('completed-stories').textContent = stats.totalCompleted;
    }

    updateLastRefresh(timestamp) {
        if (timestamp) {
            const date = new Date(timestamp);
            const formatted = date.toLocaleTimeString();
            document.getElementById('last-refresh').textContent = `Last refresh: ${formatted}`;
        }
    }

    renderRepoCards(repos) {
        // Store repos data for filtering/sorting
        this.reposData = repos;

        const grid = document.getElementById('repo-grid');

        if (Object.keys(repos).length === 0) {
            grid.innerHTML = `
                <div class="empty-state">
                    <p>No repositories configured</p>
                    <p>Run <code>fade dashboard --add /path/to/repo</code> to add repositories</p>
                </div>
            `;
            return;
        }

        // Convert to array for filtering and sorting
        let repoArray = Object.entries(repos).map(([name, data]) => ({
            name: name,
            data: data
        }));

        // Apply filter
        if (this.currentFilter !== 'all') {
            repoArray = repoArray.filter(repo => {
                return repo.data.status === this.currentFilter;
            });
        }

        // Apply sort
        repoArray.sort((a, b) => {
            switch (this.currentSort) {
                case 'activity':
                    // Sort by last update (most recent first)
                    const dateA = a.data.lastUpdate ? new Date(a.data.lastUpdate) : new Date(0);
                    const dateB = b.data.lastUpdate ? new Date(b.data.lastUpdate) : new Date(0);
                    return dateB - dateA;

                case 'workload':
                    // Sort by pending stories (most first)
                    const workloadA = a.data.workQueue ? a.data.workQueue.reduce((sum, prd) => sum + (prd.pendingCount || 0), 0) : 0;
                    const workloadB = b.data.workQueue ? b.data.workQueue.reduce((sum, prd) => sum + (prd.pendingCount || 0), 0) : 0;
                    return workloadB - workloadA;

                case 'status':
                    // Sort by status (running, blocked, complete, idle)
                    const statusOrder = { 'running': 0, 'blocked': 1, 'complete': 2, 'idle': 3 };
                    const orderA = statusOrder[a.data.status] !== undefined ? statusOrder[a.data.status] : 999;
                    const orderB = statusOrder[b.data.status] !== undefined ? statusOrder[b.data.status] : 999;
                    return orderA - orderB;

                case 'name':
                default:
                    // Sort alphabetically by name
                    return a.name.localeCompare(b.name);
            }
        });

        // Render filtered and sorted cards
        grid.innerHTML = '';

        if (repoArray.length === 0) {
            grid.innerHTML = `
                <div class="empty-state">
                    <p>No repositories match the selected filter</p>
                </div>
            `;
            return;
        }

        for (const repo of repoArray) {
            const card = this.createRepoCard(repo.name, repo.data);
            grid.appendChild(card);
        }
    }

    createRepoCard(repoName, repoData) {
        const card = document.createElement('div');
        card.className = `repo-card status-${repoData.status}`;
        card.addEventListener('click', () => this.openModal(repoName, repoData));

        const status = repoData.status || 'idle';
        const currentPRD = repoData.currentPRD || { name: 'N/A' };
        const currentStory = repoData.currentStory || { title: 'N/A' };
        const iteration = repoData.iteration || 0;
        const model = repoData.model || 'N/A';

        // Calculate elapsed time
        let elapsedTime = '--';
        if (repoData.sessionStartTime) {
            const start = new Date(repoData.sessionStartTime);
            const now = new Date();
            const diffMs = now - start;
            elapsedTime = this.formatDuration(diffMs);
        }

        // Calculate progress
        let progressPercent = 0;
        let progressText = '--';
        if (repoData.workQueue && repoData.workQueue.length > 0) {
            const totalStories = repoData.workQueue.reduce((sum, prd) => {
                return sum + (prd.totalStories || 0);
            }, 0);
            const completedStories = repoData.completedThisSession || 0;

            if (totalStories > 0) {
                progressPercent = (completedStories / totalStories) * 100;
                progressText = `${completedStories} / ${totalStories} stories`;
            }
        }

        card.innerHTML = `
            <div class="repo-card-header">
                <div class="repo-name">${this.escapeHtml(repoName)}</div>
                <span class="repo-status ${status}">${status}</span>
            </div>
            <div class="repo-card-body">
                <div class="repo-info-row">
                    <span class="repo-info-label">PRD:</span>
                    <span class="repo-info-value">${this.escapeHtml(currentPRD.name || 'N/A')}</span>
                </div>
                <div class="repo-info-row">
                    <span class="repo-info-label">Story:</span>
                    <span class="repo-info-value">${this.escapeHtml(currentStory.title || 'N/A')}</span>
                </div>
                <div class="repo-info-row">
                    <span class="repo-info-label">Iteration:</span>
                    <span class="repo-info-value">${iteration}</span>
                </div>
                <div class="repo-info-row">
                    <span class="repo-info-label">Model:</span>
                    <span class="repo-info-value">${this.escapeHtml(model)}</span>
                </div>
                <div class="repo-info-row">
                    <span class="repo-info-label">Elapsed:</span>
                    <span class="repo-info-value">${elapsedTime}</span>
                </div>
                ${status !== 'idle' ? `
                    <div class="repo-progress">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${progressPercent}%"></div>
                        </div>
                        <div class="progress-text">${progressText}</div>
                    </div>
                ` : ''}
            </div>
        `;

        return card;
    }

    openModal(repoName, repoData) {
        this.selectedRepo = { name: repoName, data: repoData };

        document.getElementById('modal-repo-name').textContent = repoName;

        const modalBody = document.getElementById('modal-body');
        modalBody.innerHTML = this.renderModalContent(repoData);

        document.getElementById('modal-overlay').classList.remove('hidden');
    }

    closeModal() {
        document.getElementById('modal-overlay').classList.add('hidden');
        this.selectedRepo = null;
    }

    renderModalContent(repoData) {
        let html = '';

        // Current status
        html += `<div class="work-queue">`;
        html += `<h3>Current Status</h3>`;
        html += `<div class="queue-item">`;
        html += `<div class="queue-item-name">Status: ${repoData.status}</div>`;

        if (repoData.status === 'blocked' && repoData.blockedReason) {
            html += `<div class="queue-item-stats" style="color: var(--color-error)">`;
            html += `Reason: ${this.escapeHtml(repoData.blockedReason)}`;
            html += `</div>`;
        }

        if (repoData.currentPRD) {
            html += `<div class="queue-item-stats">Current PRD: ${this.escapeHtml(repoData.currentPRD.name || 'N/A')}</div>`;
        }

        if (repoData.currentStory) {
            html += `<div class="queue-item-stats">Current Story: ${this.escapeHtml(repoData.currentStory.title || 'N/A')}</div>`;
        }

        html += `<div class="queue-item-stats">Iteration: ${repoData.iteration || 0}</div>`;
        html += `<div class="queue-item-stats">Model: ${this.escapeHtml(repoData.model || 'N/A')}</div>`;
        html += `<div class="queue-item-stats">Mode: ${this.escapeHtml(repoData.mode || 'N/A')}</div>`;
        html += `</div>`;
        html += `</div>`;

        // Work queue
        if (repoData.workQueue && repoData.workQueue.length > 0) {
            html += `<div class="work-queue">`;
            html += `<h3>Work Queue (${repoData.workQueue.length} PRDs)</h3>`;

            for (const prd of repoData.workQueue) {
                html += `<div class="queue-item">`;
                html += `<div class="queue-item-name">${this.escapeHtml(prd.name)}</div>`;
                html += `<div class="queue-item-stats">`;
                html += `ID: ${this.escapeHtml(prd.id)} | `;
                html += `Pending: ${prd.pendingCount} | `;
                html += `Total: ${prd.totalStories}`;
                html += `</div>`;
                html += `</div>`;
            }

            html += `</div>`;
        } else {
            html += `<div class="work-queue">`;
            html += `<h3>Work Queue</h3>`;
            html += `<div class="queue-item">`;
            html += `<div class="queue-item-stats">No PRDs in queue</div>`;
            html += `</div>`;
            html += `</div>`;
        }

        // Session stats
        html += `<div class="work-queue">`;
        html += `<h3>Session Statistics</h3>`;
        html += `<div class="queue-item">`;
        html += `<div class="queue-item-stats">Completed this session: ${repoData.completedThisSession || 0}</div>`;

        if (repoData.sessionStartTime) {
            const start = new Date(repoData.sessionStartTime);
            html += `<div class="queue-item-stats">Session started: ${start.toLocaleString()}</div>`;
        }

        if (repoData.lastUpdate) {
            const updated = new Date(repoData.lastUpdate);
            html += `<div class="queue-item-stats">Last update: ${updated.toLocaleString()}</div>`;
        }

        html += `</div>`;
        html += `</div>`;

        // Test results
        if (repoData.testResults && Object.keys(repoData.testResults).length > 0) {
            const tests = repoData.testResults;
            const hasTests = tests.totalTests > 0;

            html += `<div class="work-queue">`;
            html += `<h3>Regression Tests</h3>`;
            html += `<div class="queue-item">`;

            if (hasTests) {
                const passedPercent = tests.totalTests > 0 ? ((tests.passed / tests.totalTests) * 100).toFixed(0) : 0;
                const statusColor = tests.failed === 0 ? 'var(--color-success)' : 'var(--color-error)';

                html += `<div class="queue-item-stats" style="color: ${statusColor}">`;
                html += `✓ ${tests.passed} passed, ✗ ${tests.failed} failed (${passedPercent}% pass rate)`;
                html += `</div>`;
                html += `<div class="queue-item-stats">Total tests: ${tests.totalTests}</div>`;

                if (tests.lastRun) {
                    const lastRun = new Date(tests.lastRun);
                    html += `<div class="queue-item-stats">Last run: ${lastRun.toLocaleString()}</div>`;
                }
            } else {
                html += `<div class="queue-item-stats">No tests found</div>`;
            }

            html += `</div>`;
            html += `</div>`;
        }

        // Archive list
        if (repoData.archive && repoData.archive.length > 0) {
            html += `<div class="work-queue">`;
            html += `<h3>Completed PRDs (${repoData.archive.length})</h3>`;

            // Limit to last 10 archives
            const archiveList = repoData.archive.slice(0, 10);

            for (const archive of archiveList) {
                html += `<div class="queue-item">`;
                html += `<div class="queue-item-name">${this.escapeHtml(archive.name)}</div>`;
                html += `<div class="queue-item-stats">`;
                html += `ID: ${this.escapeHtml(archive.id)}`;

                if (archive.completedAt) {
                    const completed = new Date(archive.completedAt);
                    html += ` | Completed: ${completed.toLocaleDateString()}`;
                }

                html += `</div>`;
                html += `</div>`;
            }

            if (repoData.archive.length > 10) {
                html += `<div class="queue-item">`;
                html += `<div class="queue-item-stats">... and ${repoData.archive.length - 10} more</div>`;
                html += `</div>`;
            }

            html += `</div>`;
        }

        return html;
    }

    formatDuration(ms) {
        const seconds = Math.floor(ms / 1000);
        const minutes = Math.floor(seconds / 60);
        const hours = Math.floor(minutes / 60);

        if (hours > 0) {
            return `${hours}h ${minutes % 60}m`;
        } else if (minutes > 0) {
            return `${minutes}m ${seconds % 60}s`;
        } else {
            return `${seconds}s`;
        }
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    showError(message) {
        console.error(message);
        // Could add a toast notification here
    }
}

// Initialize dashboard when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const dashboard = new FadeDashboard();
    dashboard.init();
});
