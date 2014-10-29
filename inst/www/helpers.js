// Function for iterating over an object and converting string functions to actual functions
function cleanUp(obj, stack) {
        for (var property in obj) {
            //console.debug(obj[property]);
            if (obj.hasOwnProperty(property)) {
                if (typeof obj[property] == "object") {
                  if( obj[property] == null || obj[property].length == 0 ){
                    delete obj[property];
                  }else{
                    cleanUp(obj[property], stack + '.' + property);
                  }
                } else if(typeof obj[property] == "string" && obj[property].indexOf('function()') !== -1) {
                    try{
                      obj[property] = eval("(" + obj[property] + ")");
                    } catch(e){
                       console.debug(e);
                       console.debug(obj[property]);
                    }
                }
            }
        }
    }


// Function to check for nested arguments
  function checkNested(obj /*, level1, level2, ... levelN*/) {
    var args = Array.prototype.slice.call(arguments),
        obj = args.shift();

    for (var i = 0; i < args.length; i++) {
      if (!obj || !obj.hasOwnProperty(args[i])) {
        return false;
      }
      obj = obj[args[i]];
    }
    return true;
  }