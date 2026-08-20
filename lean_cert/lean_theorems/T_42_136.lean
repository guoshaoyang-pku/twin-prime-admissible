import Sound
import lean_certs.cert_42_136

open CertVerify

theorem H42_gt_136 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 42) (d := 136) (c := cert_42_136) (by native_decide)
