import Sound
import lean_certs.cert_42_146

open CertVerify

theorem H42_gt_146 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 42) (d := 146) (c := cert_42_146) (by native_decide)
