import Sound
import lean_certs.cert_35_156

open CertVerify

theorem H35_gt_156 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 35) (d := 156) (c := cert_35_156) (by native_decide)
