import Sound
import lean_certs.cert_38_174

open CertVerify

theorem H38_gt_174 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 38) (d := 174) (c := cert_38_174) (by native_decide)
