module ctf::test {
  use sui::tx_context::{TxContext};
  use movectf::move_lock::{Self, ResourceObject};

  public entry fun attack(self: &mut ResourceObject, ctx: &mut TxContext){
    let data1:vector<u64> = vector[2, 14, 13, 6, 17, 0, 19, 20, 11, 0, 19, 8, 14, 13, 18, 24, 14, 20, 12, 0, 13, 0, 6, 4, 3, 19, 14, 1, 17, 4, 0, 10, 19, 7, 4, 7, 8, 11, 11, 2, 8, 15, 7, 4, 17, 7, 0, 2, 10, 19, 7, 4, 7, 0, 2, 10, 24, 15, 11, 0, 13, 4, 19];
    let data2:vector<u64> = vector[25, 11, 6, 10, 13, 25, 12, 19, 2];
    move_lock::movectf_unlock(data1, data2, self, ctx);
    move_lock::get_flag(self, ctx);
  }

}
