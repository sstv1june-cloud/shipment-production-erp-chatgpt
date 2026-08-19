import { Shell } from '@/components/erp-shell'; import { ModulePage } from '@/modules/shared/module-page'; export default function Dashboard(){return <Shell><ModulePage def={{title:'Dashboard',table:'v_dashboard',columns:['metric','value'],report:true}}/></Shell>}

