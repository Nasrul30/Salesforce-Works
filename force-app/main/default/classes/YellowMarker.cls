// Extension for the Marker class
public class YellowMarker extends Marker {
    public override void write() {
        System.debug('Writing some text using the yellow marker.');
    } 
    public override void task(){
         System.debug('Taks fromn extend class');
    }
}