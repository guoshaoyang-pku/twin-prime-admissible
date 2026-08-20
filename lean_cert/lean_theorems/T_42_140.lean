import Sound
import lean_certs.cert_42_140

open CertVerify

theorem H42_gt_140 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 42) (d := 140) (c := cert_42_140) (by native_decide)
