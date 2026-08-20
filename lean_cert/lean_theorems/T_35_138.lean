import Sound
import lean_certs.cert_35_138

open CertVerify

theorem H35_gt_138 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 35) (d := 138) (c := cert_35_138) (by native_decide)
