const WatcherClass = require('../watcher')
const watch = new WatcherClass('./sourceFile.log')
const EventEmitter = require('events');
const assert = require('assert');
const eventEmitter = new EventEmitter();

describe('Log file read', ()=>{
    it("Server started succcessfully",()=>{
        watch.start()                                   //start server - start function
    })
    it("Initial content to be displayed on server should not be empty", async ()=>{
        const logs = await watch.getLogs();             //getLogs function
        assert.equal(logs.length>0,true)    
    })

    it("Log file should have atleast 10 lines",()=>{    //update log from watch() method
        eventEmitter.on('update-log',(data)=>{
            assert.equal(data.length <= 10,true)
        })
    })
})

describe('check connection established', ()=>{
    it('New client connection established',()=>{    //New connection established
        eventEmitter.on('connection',async()=>{
            const data = await fetch('ws://localhost:3000');
            assert.equal(data,!null)
        })
    })
})

describe('Negative case', ()=>{
    it('Empty buffer argument should return null',()=>{     // Empty buffer is returned as Null
        assert.equal(watch.watch(null,null),null)
    })

    it("Text update string must be greater than 0",()=>{    // Process contains new string to be updated, length should be greater than 0
        eventEmitter.on('process',(logs)=>{
            assert.equal(logs.length>0,false)
        })
    })
})