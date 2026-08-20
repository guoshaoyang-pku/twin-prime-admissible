import Sound
import lean_certs.cert_35_102

open CertVerify

theorem H35_gt_102 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 35) (d := 102) (c := cert_35_102) (by native_decide)
