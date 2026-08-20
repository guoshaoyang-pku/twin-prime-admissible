import Sound
import lean_certs.cert_42_176

open CertVerify

theorem H42_gt_176 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 42) (d := 176) (c := cert_42_176) (by native_decide)
