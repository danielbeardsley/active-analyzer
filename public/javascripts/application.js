var Data = new Hash();
var graph_type = null;
var graphed_series = [];
var data_options = {aggregate:'count'};

var ticks = get_ticks();
function get_ticks(){
	var ticks = [];
	var today = new Date(2008, 8, 4);
	var current = today.getTime() + today.getTimezoneOffset() * 60000;
	var end = current + (1000 * 3600 * 24 * 30);
	do 
	{
		ticks.push(current);
		current += (1000 * 3600 * 24 * 3);
	}
	while (current <= end)
	return ticks;
}

Event.observe(window, 'load',function(){
	var aggregate_selector = $('aggregate_selector');
	aggregate_selector.observe('change', function(){
		setAggregate(aggregate_selector.getValue());
	});
});

function setAggregate(value){
	if(data_options.aggregate != value){
		Data = new Hash();
		data_options.aggregate = value;
		refreshData();
	}
}


function dateFormatter(n){
	var d = new Date(parseFloat(n));
	return (d.getMonth()+1) + '/' + d.getDate();
}

function AddData(key, data){
	if(data.length == 0) return;
	
	Data.set(key, data);
	
	Flotr.draw(
		$('graph'), Data.map(function(pair){
			return {data: pair.value};
		}),
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

function GetGraphData(options){
	options = $H(options).only($w('template action_name from to aggregate application'));

	store_options_and_add_key(options);

	SendDataRequest(options);
}

function SendDataRequest(options){
	options = options.merge(data_options);
	
	new Ajax.Request('/event_logs/list', {
		method:'get',
		onSuccess: function(transport){
			var json = transport.responseText.evalJSON();
			if(json.data)
				AddData(options.get('key'), json.data);
		},
		parameters: options
	});
}


function store_options_and_add_key(options){
	var key;
	if(key = options.get('action_name')){
		set_graph_type('request');
	}else if(key = options.get('template')){
		set_graph_type('template');
	}

	options.set('key', key);
	graphed_series.push(options);
}

function refreshData(){
	graphed_series.each(SendDataRequest);
}

function set_graph_type(type){
	if (graph_type != type) 
	{
		alert('graph_type changed from: ' + graph_type + ' to: ' + type)
		graphed_series = [];
		Data = new Hash();
		graph_type = type;
	}
}

function GetRequestData(action_name){
	GetGraphData({
			application: Application_ID,
			action_name: action_name,
		});
}

function GetTemplateData(template_path){
	GetGraphData({
			application: Application_ID,
			template: template_path,
		});
}

Hash.prototype.only = function(allowed){
	var h = new Hash();
	this.each(function(pair){
		if(allowed.include(pair.key))
			h.set(pair.key, pair.value);
	});
	return h;
}

