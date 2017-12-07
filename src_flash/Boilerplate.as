class Boilerplate extends MovieClip
{
    // Constructor
    function Boilerplate(globalMovieClip)
	{
        // Invoke parent class constructor
        super();

        var self = this;

        // Enable gfx extensions
        _global.gfxExtensions = true;
        // Save ref to global movie clip
        this.globalMC = globalMovieClip;

        // Init main movie clip
        this.contentMC                  = this.globalMC.attachMovie('CONTENT', 'CONTENT', this.globalMC.getNextHighestDepth());
        this.contentMC._width           = 500;
        this.contentMC._height          = 500;
        this.contentMC._x               = 250;
        this.contentMC._y               = 250;
		this.contentMC.opaqueBackground = 0xFF0000;

		// Movie clip loader
		var mclListener:Object = new Object(); 
		
		mclListener.onLoadInit = function(mc:MovieClip)
		{ 
			self.loadedImage = mc;
			
			self.contentMC._width  = 500;
			self.contentMC._height = 500;
			self.contentMC._x      = 250  / 2;
			self.contentMC._y      = 250  / 2;
			
			mc._x = mc._width  / 2;
			mc._y = 0;
		}; 
		
		this.mcLoader = new MovieClipLoader();
        this.mcLoader.addListener(mclListener);
		
		// Image handle
		this.loadedImage = null;

	}

	// Public functions
	function LOAD_IMAGE(txd:String, name:String)
	{
		this.mcLoader.loadClip('img://' + txd + '/' + name, this.contentMC.imgcontainer);
	}
	
	function SET_ALPHA(alpha:Number)
	{
		this.contentMC._alpha = alpha;
	}

}
