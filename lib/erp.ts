export type Access='None'|'View'|'Edit';
export const containerUnits=(b:{small_box_per_container:number;parts_qty_per_small_box:number;big_box_per_container:number;parts_qty_per_big_box:number})=>b.small_box_per_container*b.parts_qty_per_small_box+b.big_box_per_container*b.parts_qty_per_big_box;
export const interchange=(input:number,inputParts:number,outputParts:number)=>({output:Math.floor(input*inputParts/outputParts),remainder:(input*inputParts)%outputParts});
export const weightedAverage=(rows:{qty:number;rate:number}[])=>{const totals=rows.slice(-7).reduce((a,r)=>({q:a.q+r.qty,v:a.v+r.qty*r.rate}),{q:0,v:0});return totals.q?totals.v/totals.q:0};
export const purchaseSuggestion=(stock:number,daily:number,lead:number,buffer=7)=>daily<=0?0:Math.max(0,(lead+buffer)*daily-stock);

