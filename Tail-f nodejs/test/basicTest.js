const WatcherClass = require('../watcher')
const watch = new WatcherClass('./sourceFile.log')
const EventEmitter = require('events');
const assert = require('assert');
const eventEmitter = new EventEmitter();

describe('Log file read', ()=>{
    it("Server started succcessfully",()=>{
        watch.start()   //start server
    })
    it("Initial content to be displayed on server should not be empty", async ()=>{
        const logs = await watch.getLogs();
        assert.equal(logs.length>0,true)    
    })

    it("Continuous update log event",()=>{
        eventEmitter.on('update-log',(data)=>{
            assert.equal(data.length>0,true)
        })
    })
})

describe('check connection established', ()=>{
    it('New client connection established',()=>{
        eventEmitter.on('connection',async()=>{
            const data = await fetch('ws://localhost:3000');
            assert.equal(data,!null)
        })
    })
})