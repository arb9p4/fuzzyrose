(function() {

var FuzzyRose = function(params) {
  this.initialize(params);
}
var p = FuzzyRose.prototype = new createjs.Container(); // inherit from Container

p.count = 0;

p.Container_initialize = p.initialize;
p.initialize = function(params) {
	this.Container_initialize();



    
    var N = params.length;
    var res = 50;
    
    var dF = 2*Math.PI/N;
    
    for (var i = 0; i < N; i++) {
        
        var f = [];

        var a = params[i][0];
        var b = params[i][1];
        var c = params[i][2];
        var d = params[i][3];
        
        var t = c+d-a-b;
        
        var p1 = (b-a)/t;
        var p2 = (2*c-a-b)/t;
        
        for (var j = 0; j < res; j++) {
            var x = j/(res-1);
            if (x < p1) {
                f.push(a+Math.sqrt(x*(b-a)*t));
            }
            else if (x < p2) {
                f.push((x*t+a+b)/2);
            }
            else {
                f.push(d-Math.sqrt((1-x)*(d-c)*t));
            }
        }
        
        for (var j = res-2; j >= 0; j--) {
            f.push(f[j]);
        }
        
        var theta = [];
        for (var j = 0; j < f.length; j++) {
            theta.push(-Math.PI/2 + i*dF + j/(f.length-1)*dF);
        }
        
        var color = i*dF/(2*Math.PI)*360;
        

        
        
        var sMax = new createjs.Shape();
        sMax.graphics.beginStroke("#000").beginFill("hsl(" + color + ",100%,50%)").moveTo(0,0);
        sMax.graphics.lineTo(Math.cos(theta[0])*d, Math.sin(theta[0])*d);
        sMax.graphics.arc(0,0,d,theta[0],theta[theta.length-1]);
        sMax.graphics.lineTo(0,0);
        sMax.graphics.closePath();
        sMax.alpha = 0.25;
        this.addChild(sMax);
        
        
        var sArc = new createjs.Shape();
        sArc.graphics.beginStroke("#000").beginFill("hsl(" + color + ",100%,50%)").moveTo(0,0); 
        for (var j = 0; j < f.length; j++) {
            sArc.graphics.lineTo(Math.cos(theta[j])*f[j], Math.sin(theta[j])*f[j]);
        }
        sArc.graphics.closePath();      
        sArc.alpha = 0.5;
        this.addChild(sArc);
        
        var sMin = new createjs.Shape();
        sMin.graphics.beginStroke("#000").beginFill("hsl(" + color + ",100%,50%)").moveTo(0,0);
        sMin.graphics.lineTo(Math.cos(theta[0])*a, Math.sin(theta[0])*a);
        sMin.graphics.arc(0,0,a,theta[0],theta[theta.length-1]);
        sMin.graphics.lineTo(0,0);
        sMin.graphics.closePath();
        this.addChild(sMin);
        
        
    }
    
    
    //this.on("click", this.handleClick);
	//this.on("tick", this.handleTick);

	this.mouseChildren = false;
} 


p.handleClick = function (event) {    
	var target = event.target;
	
} 

p.handleTick = function(event) {       
	p.alpha = Math.cos(p.count++*0.1)*0.4+0.6;
}

window.FuzzyRose = FuzzyRose;
}());