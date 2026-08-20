import Sound
import lean_certs.cert_42_174

open CertVerify

theorem H42_gt_174 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 42) (d := 174) (c := cert_42_174) (by native_decide)
