import Sound
import lean_certs.cert_42_154

open CertVerify

theorem H42_gt_154 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 42) (d := 154) (c := cert_42_154) (by native_decide)
