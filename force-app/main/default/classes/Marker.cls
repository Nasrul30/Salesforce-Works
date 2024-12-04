public virtual class Marker {
    public virtual void write() {
        System.debug('Writing some text.');
    }

    public virtual void task(){
        System.debug('Do some task');
     }
    public virtual Double discount() {
        return .05;
    }
}