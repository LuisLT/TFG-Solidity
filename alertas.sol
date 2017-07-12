
pragma solidity ^0.4.0;

//Contrato principal que se encarga de crear los contratos Product
contract Fabric{
    //Array que guarda las direcciones de los contratos Product creados
    address[] public contracts;
    address[] contractsB;
    
    //función que genera los contratos product mediante la sentencia new
    function createProduct (string _name, string _company, bytes32 _key) {
        address newProduct = new Product(_name, _company, _key);
        contracts.push(newProduct);

        NewProduct(_name);
    } 

    //Devuelve la longitud del array contracts
    function count() constant returns (uint){
        return contracts.length;
    }
    
    //Función que sirve para borrar un determinado contrato Product por su dirección y elimina huecos en el array
    function deleteProduct(address addr){
        delete contractsB;
        uint j;
        for (j= 0; j<count(); j++){
            if(contracts[j] == addr){
                delete contracts[j];
            }
            
            if (contracts[j] != 0x0000000000000000000000000000000000000000){
                contractsB.push(contracts[j]); 
            }
        }
        contracts = contractsB;
    }
    
    //Evento que se genera al crear un nuevo Product
    event NewProduct(
        string _name
    );
}

//Contrato propio de cada producto con los atributos nombre, compañía, key y activo
contract Product {
    string public name;
    string public company;
    bytes32 public key;
    bool public active;

    //Array de alertas publicadas en ese producto 
    string[] public alerts;

    bool constant productOff = false;

    //Estructura de un punto de control de localización 
    struct TrackingPoint{
        string location;
        string longitude; 
        string latitude;
        uint date;
    }
    // Array que guarda todas los puntos de control de localización creados
    TrackingPoint[] public locations;

    // constructor
    function Product (string _name, string _company, bytes32 _key) {
        name = _name;
        company = _company;
        key = _key;
        active = true;
    }
    
    //metodo para obtener la key del producto en bytes32 y transoformarla a String
    function getKey(bytes32 key) public constant returns(string){
        
        return bytes32ToString(key);
    }
    
    //Devuelve el número de alertas en el array
    function countAlerts() constant returns (uint){
       return alerts.length;
    }
    //Devuelve la longitud del array de Localizaciones
    function countLocations() constant returns (uint){
       return locations.length;
    }
    modifier onlyActive() {
        if (active == false) throw;
        _;
    }
    //función que añade un punto de localización
    function addTrackingPoint(string location, string longitude, string latitude) onlyActive(){
     
        var point = TrackingPoint({location: location, 
                                        longitude: longitude, 
                                        latitude: latitude,
                                        date: now});
        
        locations.push(point);

        NewTrackingPoint(location);
    }
    //función privada que convierte un bytes32 en string
    function bytes32ToString(bytes32 data) private constant returns (string) {
        bytes memory bytesString = new bytes(32);
        for (uint j=0; j<32; j++) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[j] = char;
            }
        }
        return string(bytesString);
    }
    // función cuyo fin es poder añadir una alerta
    function addAlert(string alert) onlyActive(){
        alerts.push(alert);
        AlertProduct(alert);
    }
    //Si el producto es consumido o caducado, active= false
    function productStateOff(){
        active = productOff;
    }
    //evento que muestra que se añadió una alerta
    event AlertProduct(
        string alert
    );
    //evento que muestra un nuevo punto de localización
    event NewTrackingPoint(
        string location
    );

}