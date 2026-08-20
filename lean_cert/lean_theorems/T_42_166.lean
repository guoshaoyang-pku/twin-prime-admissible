import Sound
import lean_certs.cert_42_166

open CertVerify

theorem H42_gt_166 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 42) (d := 166) (c := cert_42_166) (by native_decide)
