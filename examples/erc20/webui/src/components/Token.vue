<template>
<div>
  <!-- Módulo de información básica del Token -->
  <h2>Información del Token {{ tokenName }}</h2>

  <p>Total supply: {{ totalSupply }}</p>
  <p>Precio: {{ price }}</p>
  <p>Balance: {{ balance }}</p>

  <!-- Módulo de compra -->
  <h2>Comprar tokens</h2>
  <div>
    <input type="text" placeholder="Cantidad"></input>
  </div>
  <button>Comprar</button>

  <!-- Módulo para comprobar el saldo de una cuenta -->
  <h2>Comprobar saldo</h2>
  <div>
    <input type="text" placeholder="Dirección"></input>
  </div>
  <button>Comprobar</button>

  <!-- Módulo para enviar tokens a otra dirección -->
  <h2>Enviar tokens</h2>
  <div class="">
    <input type="text" placeholder="Dirección"></input>
  </div>
  <div>
    <input type="text" placeholder="Cantidad"></input>
  </div>
  <button>Enviar</button>

</div>
</template>

<script>
export default {
  name: 'Token',

  data() {
    return {
      totalSupply: 0,
      price: 0,
      balance: 0,
      tokenName: '',
    };
  },
};
</script>
