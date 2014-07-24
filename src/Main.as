package {

import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractTextField;

import com.freshplanet.ane.AirFacebook.Facebook;

import com.gamua.flox.Flox;
import com.gamua.flox.Player;
import com.pnwrain.flashsocket.FlashSocket;
import com.pnwrain.flashsocket.events.FlashSocketEvent;

import flash.events.Event;
import flash.events.StatusEvent;

import flash.geom.Point;

import nape.space.Space;

import server.Server;

import settings.Countries;

import signals.ISignalsHub;
import signals.Signals;

import signals.SignalsHub;

import simulation.Producer;

import simulation.Strategy;
import simulation.Transport;

import starling.animation.Juggler;

import starling.utils.AssetManager;

import starlingEngine.StarlingEngine;

import bridge.abstract.AbstractPool;
import bridge.BridgeGraphics;

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.text.TextField;

[SWF(width='480',height='800',frameRate='1')]

public class Main extends Sprite {

    private var _bridgeGraphics:IBridgeGraphics = new BridgeGraphics(
            new Point(480, 800),
            StarlingEngine,
            starling.utils.AssetManager,
            signals.SignalsHub,
            AbstractPool,
            starling.animation.Juggler,
            nape.space.Space,
            true
    );

    private var _flashSocket:FlashSocket;

    private var _currentPlayer:Player = Player.current;
    private var _country:String = Countries.ROMANIA_ID;

    private var _strategy:Strategy = new Strategy();
    private var _server:Server = new Server(_country);

    private var p1:Producer = new Producer("producer1", 1000, 1000, 1, 3, 1);
    private var p2:Producer = new Producer("producer2", 2000, 1000, 1, 7, 1);
    private var t:Transport = new Transport("transporter1", 1000, 5000, 2, 1);

    public function Main()
    {
        initBridge();
        initSocket();
    }

    private function  initSocket():void
    {
        _flashSocket = new FlashSocket("localhost:8080");

        _flashSocket.addEventListener(FlashSocketEvent.CONNECT, onConnect);
        _flashSocket.addEventListener(FlashSocketEvent.MESSAGE, onMessage);
        _flashSocket.addEventListener(FlashSocketEvent.IO_ERROR, onError);
        _flashSocket.addEventListener(FlashSocketEvent.SECURITY_ERROR, onError);

        _flashSocket.addEventListener("my other event", myCustomMessageHandler);
    }

    protected function myCustomMessageHandler(event:FlashSocketEvent):void{
        trace('we got a custom event!')
    }

    protected function onConnect(event:FlashSocketEvent):void {
        trace("CONNECTED")
        clearStatus();

    }

    protected function onError(event:FlashSocketEvent):void {

        setStatus("something went wrong");

    }

    protected function setStatus(msg:String):void{

        trace(msg);

    }
    protected function clearStatus():void{


    }

    protected function onMessage(event:FlashSocketEvent):void{

        trace('we got message: ' + event.data);
        _flashSocket.send({msgdata: event.data},"my other event");

    }

    private function initFacebook():void
    {
        Facebook.getInstance().addEventListener(StatusEvent.STATUS, handler_status);
        Facebook.getInstance().init("1395615130691927");
    }

    protected function handler_status($evt:StatusEvent):void
    {
        trace("statusEvent,type:", $evt.type,",code:", $evt.code,",level:", $evt.level);
        var t:IAbstractTextField = _bridgeGraphics.requestTextField(200,30, String("CONNECTED"));
        _bridgeGraphics.addChild(t);

    }

    private function initFlox():void
    {
        Flox.init("YNclogVX3tC53ete", "P5Id3jtxxpFf3dtn", "0.9");
    }

    private function initBridge():void
    {
        (_bridgeGraphics.signalsManager as ISignalsHub).addListenerToSignal(Signals.STARLING_READY, starlingReady);
        addChild(_bridgeGraphics.engine as DisplayObject);
    }

    private function starlingReady(type:String, obj:Object):void
    {
        //initFacebook();
        //var t:IAbstractTextField = _bridgeGraphics.requestTextField(200,30, String(Facebook.isSupported));
        //_bridgeGraphics.addChild(t);
        //initSimulation();
    }

    private function initSimulation():void
    {
        _server.registerModule(p1.name, p1);
        _server.registerModule(p2.name, p2);
        _server.registerModule(t.name, t);

        _strategy.makeNewLinkage(p1, t, p2);

        addEventListener(Event.ENTER_FRAME, coreStep)
    }

    private function coreStep(event:Event):void {
        _strategy.step();
    }
}
}
