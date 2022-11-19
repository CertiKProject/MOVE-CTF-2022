module challenge_one::solution {
  use sui::tx_context::{TxContext};

  use game::hero::{Self, Hero};
  use game::adventure::{slay_boar, slay_boar_king};
  use game::inventory::{TreasuryBox, get_flag};

  use challenge_one::random;

  public entry fun get_box(hero: &mut Hero, ctx: &mut TxContext) {
      while(hero::experience(hero) < 100) {
        slay_boar(hero, ctx);
      };
      hero::level_up(hero);
      // manipulate the ctx
      let dist = random::get_distance(ctx);
      random::manipulate(dist-4, ctx);
      slay_boar_king(hero, ctx);

  }

  public entry fun open_box(box: TreasuryBox, ctx: &mut TxContext) {
      let dist = random::get_distance(ctx);
      random::manipulate(dist, ctx);
      get_flag(box, ctx);
  }
}
