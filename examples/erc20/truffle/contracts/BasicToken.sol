pragma solidity ^0.4.19;

import "./ERC20Basic.sol";


contract BasicToken is ERC20Basic {
    // Evento que se ejecuta cuando se realiza una compra. Se emite en el evento
    // la dirección de quien ha comprado tokens y la cantidad.
    event Buy(address buyer, uint256 amount);

    // Nombre del token
    string public name = "Colmena Token";

    // Símbolo mostrado en algunas aplicaciones
    string public symbol = "CTKN";

    // Número de decimales que soporta el token
    uint8 public decimals = 18;

    // Precio en wei de cada token
    uint256 public price;

    // Se almacena el saldo de cada cuenta (address) de Ethereum
    mapping(address => uint256) private balances;

    // Tokens que existen actualmente
    uint256 private totalSupply_;

    /**
     * Constructor del token. Se ejecuta sólamente en el momento que se
     * depliega en la red.
     *
     * @param _price  uint256  Precio del token
     */
    function BasicToken(uint256 _price) public {
        // Existen 0 tokens en el momento de la creación
        totalSupply_ = 0;
        price = _price;
    }

    /**
     * Muestra la cantidad de tokens que existen actualmente.
     *
     * @return uint256 La cantidad existente de tokens
     */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /**
     * Muestra el saldo de una cuenta
     *
     * @param  _owner   address  Cuenta de la que se comprueba su saldo
     * @return          uint256  Balance de la cuenta en wei
     */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    /**
     * Método para comprar tokens. Se calcula la cantidad de tokens en función
     * de los ethers enviados al método.
     *
     * @return bool  True si se ha producido correctamente la compra
     */
    function buy() public payable returns (bool) {
        require(msg.value > 0);

        // Importante comprobar que el precio no sea cero porque provocaría
        // una división por cero.
        assert(price != 0);
        uint256 amount = msg.value / price;

        balances[msg.sender] = balances[msg.sender] + amount;
        totalSupply_ = totalSupply_ + amount;

        Buy(msg.sender, amount);

        return true;
    }

    /**
     * Método para transferir tokens a otra dirección de Ethereum. No se puede
     * enviar tokens a la dirección cero.
     *
     * @param  _to     address  Dirección a la que se envían token
     * @param  _value  uint256  Cantidad de tokens a enviar
     * @return         bool     True si se ejecuta correctamente
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;

        Transfer(msg.sender, _to, _value);

        return true;
    }
}
