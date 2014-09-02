// ActionScript file
import com.altoinu.flash.customcomponents.drawingboard.DrawingBoard;
import com.altoinu.flash.customcomponents.drawingboard.DrawingLayer;
import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.DrawingTool;
import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.EraserTool;
import com.altoinu.flash.datamodels.Axis3DSpace;
import com.altoinu.flash.datamodels.Point3DSpace;
import com.altoinu.flash.pv3d.materials.DrawingBoardMaterial;
import com.altoinu.flash.pv3d.objects.parsers.DesignableDAEModel;
import com.altoinu.flash.pv3d.utils.DisplayObject3DTransformUtil;

import flash.display.DisplayObject;
import flash.display.MovieClip;

import mx.events.FlexEvent;

import org.papervision3d.events.FileLoadEvent;

private const X_AXIS:Axis3DSpace = new Axis3DSpace(new Point3DSpace(), new Point3DSpace(1, 0, 0));
private const Y_AXIS:Axis3DSpace = new Axis3DSpace(new Point3DSpace(), new Point3DSpace(0, 1, 0));

//[Embed(source="/assets/CokeCan.dae", mimeType="application/octet-stream")]
//[Embed(source="/assets/nascar_Car.dae", mimeType="application/octet-stream")]
[Embed(source="/assets/soccerball.dae", mimeType="application/octet-stream")]
private const MODEL_DAE:Class;

//[Embed(source="/assets/SoccerBall.jpg")]
//[Embed(source="/assets/CokeCan10.jpg")]
//[Embed(source="/assets/nascar.jpg")]
[Embed(source="/assets/image_assets.swf", symbol="Balltexture.jpg")]
private const BASETEXTURE_IMAGE:Class;

[Embed(source="/assets/image_assets.swf", symbol="TestIcon")]
private const TESTICON:Class;

private var _modelBaseTexture:Bitmap = new BASETEXTURE_IMAGE();

[Bindable] private var _designModel:DesignableDAEModel = new DesignableDAEModel("SoccerBall", null, false, "soccerball", false);
//[Bindable] private var _designModel:DesignableDAEModel = new DesignableDAEModel("can", null, false, "can", false);
//[Bindable] private var _designModel:DesignableDAEModel = new DesignableDAEModel("polySurface2", null, false, "can", false);

private function setDrawingTool():void
{
	
	// set drawing tool
	content_3DModel.currentTool = new DrawingTool(TESTICON);
	content_3DModel.currentTool.scaleX = 0.5;
	content_3DModel.currentTool.scaleY = 0.5;
	DrawingTool(content_3DModel.currentTool).bitmapMode = true;
	DrawingTool(content_3DModel.currentTool).bitmapSmoothing = true;
	
	// Select a layer to draw on
	if (content_3DModel.targetModel.getDrawingLayers().length <= 1)
		content_3DModel.targetModel.addLayer(new DrawingLayer());
	
	content_3DModel.targetModel.selectedLayerIndex = 1;
	var asdf:Axis3DSpace;
	var asdfasdf:Point3DSpace;
	
}

private function setEraserTool():void
{
	
	// set eraser tool
	content_3DModel.currentTool = new EraserTool(TESTICON);
	var eraserShape:DisplayObject = new TESTICON();
	content_3DModel.currentTool.width = eraserShape.width;
	content_3DModel.currentTool.height = eraserShape.height;
	content_3DModel.currentTool.scaleX = 0.5;
	content_3DModel.currentTool.scaleY = 0.5;
	
	// Select a layer to erase on
	if (content_3DModel.targetModel.getDrawingLayers().length <= 1)
		content_3DModel.targetModel.addLayer(new DrawingLayer());
	
	content_3DModel.targetModel.selectedLayerIndex = 1;
	
}

private function rotateBy(angle:Number, axis:Axis3DSpace):void
{
	
	angle = angle * Math.PI / 180;
	
	DisplayObject3DTransformUtil.rotateArbitrary(_designModel, angle, axis);
	
}

private function onApplicationComplete(event:FlexEvent):void
{
	
	trace("Application creation complete");
	
	// Create DrawingBoard with base layer
	var baseDrawingBoard:DrawingBoard = new DrawingBoard(_modelBaseTexture.width, _modelBaseTexture.height);
	var baseDrawingLayer:DrawingLayer = baseDrawingBoard.addLayerAt(new DrawingLayer(), 0) as DrawingLayer;
	var modelBaseTextureContainer:MovieClip = new MovieClip();
	modelBaseTextureContainer.addChild(_modelBaseTexture);
	baseDrawingLayer.drawItem(modelBaseTextureContainer);
	
	// Camera position and model scale
	//_designModel.y = -500;
	_designModel.scale = 250;
	content_3DModel.basicView.camera.focus = 20;
	
	// Create DrawingBoardMaterial for the model using the DrawingBoard created
	_designModel.designMaterial = new DrawingBoardMaterial(baseDrawingBoard, true, true);
	_designModel.designMaterial.interactive = true;
	_designModel.designMaterial.doubleSided = false;
	_designModel.designMaterial.tiled = true;
	
	// Load model
	_designModel.addEventListener(FileLoadEvent.LOAD_COMPLETE, onModelLoadComplete);
	_designModel.load(new MODEL_DAE());
	
}

private function onModelLoadComplete(event:FileLoadEvent):void
{
	
	var targetModel:DesignableDAEModel = DesignableDAEModel(event.currentTarget);
	targetModel.removeEventListener(FileLoadEvent.LOAD_COMPLETE, onModelLoadComplete);
	
	setDrawingTool();
	
}
