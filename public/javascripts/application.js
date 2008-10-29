
function dateFormatter(n){
	var d = new Date(parseFloat(n));
	return (d.getMonth()+1) + '/' + d.getDate();
}

function DrawData(data){

	var ticks = [];
	data.eachSlice(3, function(slice){
		ticks.push(slice[0][0]); 
	});
	
	Flotr.draw(
		$('graph'), [
		{ // => second series
		    data: data
		}],
		{ 
			xaxis:{
				tickFormatter: dateFormatter,
				ticks: ticks,
				autoscaleMargin: 0.06
			},
			yaxis:{min:0}
		}
	);	
}

function GetGraphData(action_name){
	new Ajax.Request('<%= url_for(:controller => :event_logs, :action => :list) %>', {
		method:'get',
		onSuccess: function(transport){
			var json = transport.responseText.evalJSON();
			
			if(json.data){
				DrawData(json.data);
			}
		},
		parameters: {
			application: <%=@app.id%>,
			action_name: action_name,
			aggregate: 'count'
		}
	});
}
