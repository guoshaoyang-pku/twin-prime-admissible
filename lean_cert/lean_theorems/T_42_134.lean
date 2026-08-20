import Sound
import lean_certs.cert_42_134

open CertVerify

theorem H42_gt_134 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 42) (d := 134) (c := cert_42_134) (by native_decide)
