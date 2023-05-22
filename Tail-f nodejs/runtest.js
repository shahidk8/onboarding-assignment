var fs = require('fs');

let counter = 1;
fs.appendFile("sourceFile.log",Date.now()+" :"+counter.toString(),(err) => {
    if(err) throw err;
    console.log("test file initialized");
});
counter++;
setInterval(function(){
    fs.appendFile("sourceFile.log","\n"+Date.now()+": "+counter,(err) => {
    if(err) console.log(err);
    console.log("log updated");
    });
    counter++;
},1000);