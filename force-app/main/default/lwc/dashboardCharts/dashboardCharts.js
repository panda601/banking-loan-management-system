import { LightningElement, api } from 'lwc';

export default class DashboardCharts extends LightningElement {
    @api pipelineData = [];

    get hasData() {
        return this.pipelineData && this.pipelineData.length > 0;
    }

    get chartData() {
        if (!this.pipelineData || this.pipelineData.length === 0) return [];
        
        let maxCount = Math.max(...this.pipelineData.map(d => d.count || 1));
        if (maxCount === 0) maxCount = 1;

        const colorMap = {
            'Draft': '#94a3b8',
            'Applied': '#38bdf8',
            'Under Review': '#f59e0b',
            'Approved': '#10b981',
            'Sanctioned': '#6366f1',
            'Disbursed': '#059669',
            'Defaulted': '#ef4444',
            'Rejected': '#64748b'
        };

        return this.pipelineData.map(item => {
            const pct = Math.round(((item.count || 0) / maxCount) * 100);
            const color = colorMap[item.status] || '#3b82f6';
            const formattedAmount = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(item.amount || 0);

            return {
                ...item,
                formattedAmount,
                barStyle: `width: ${pct}%; background-color: ${color};`
            };
        });
    }
}
